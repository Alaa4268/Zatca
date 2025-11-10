codeunit 50202 "ZATCA API Processing"
{
    Permissions = tabledata "Sales Cr.Memo Header" = RM,
        tabledata "Sales Header" = R,
        tabledata "Sales Invoice Header" = RM,
        tabledata "ZATCA Device Onboarding" = RM,
        tabledata "ZATCA Error Log" = RID,
        tabledata "ZATCA Hash" = RI;

    internal procedure ZATCADeviceOnboardingProc(OldDeviceId: Text)
    var
        ZATCADeviceOnboarding: Record "ZATCA Device Onboarding";
        IsSuccess: Boolean;
        ResponseJson: JsonObject;
        JToken: JsonToken;
        Body, Response, Url : Text;
    begin
        if not ZATCAActivationMgt.IsZATCAIntegrationModuleActive() then exit;
        if ZATCADeviceOnboarding.Get() then;
        Url := ZATCADeviceOnboarding."Base URL" + ZATCADeviceOnboarding."Onboarding Endpoint";
        Body := ZATCAPayloadMgt.OnboadingJsonBody(OldDeviceId);
        SendHttpRequest(Url, Response, HttpRequestType::POST, Body);
        if ResponseJson.ReadFrom(Response) then begin
            if ResponseJson.Get('IsSuccess', JToken) then IsSuccess := JToken.AsValue().AsBoolean();
            if IsSuccess then begin
                ZATCADeviceOnboarding."Has Error" := false;
                ZATCADeviceOnboarding."Error Message" := '';
                if ResponseJson.Get('CSID', JToken) then ZATCADeviceOnboarding.CSID := CopyStr(JToken.AsValue().AsText(), 1, MaxStrLen(ZATCADeviceOnboarding.CSID));
                if ResponseJson.Get('PrivateKey', JToken) then ZATCADeviceOnboarding."Private Key" := CopyStr(JToken.AsValue().AsText(), 1, MaxStrLen(ZATCADeviceOnboarding."Private Key"));
                if ResponseJson.Get('SecretKey', JToken) then ZATCADeviceOnboarding."Secret Key" := CopyStr(JToken.AsValue().AsText(), 1, MaxStrLen(ZATCADeviceOnboarding."Secret Key"));
                ZATCADeviceOnboarding."Last Onboarding Date" := Today();
            end
            else begin
                if ResponseJson.Get('ErrorMessage', JToken) then ZATCADeviceOnboarding."Error Message" := CopyStr(JToken.AsValue().AsText(), 1, MaxStrLen(ZATCADeviceOnboarding."Error Message"));
                ZATCADeviceOnboarding."Has Error" := true;
            end;
            ZATCADeviceOnboarding.Modify();
        end;
    end;

    [TryFunction]
    internal procedure SignAndSubmit(var SalesInvoiceHeader: Record "Sales Invoice Header"; IsPostedDoc: Boolean)
    var
        ZATCADeviceOnboarding: Record "ZATCA Device Onboarding";
        InvoiceSigned, IsB2B : Boolean;
        ICV: Integer;
        ErrorMessagesArray: JsonArray;
        ErrorMessage, InvoiceReportingResults, InvoiceValidationResults, ResponseJson, ValidationResults : JsonObject;
        ErrorDetail, JToken : JsonToken;
        Base64, Body, InvoiceId, PIH, Response, Url : Text;
        ErrorToShow: Text;
        InvoiceXml: XmlDocument;
    begin
        if not ZATCAActivationMgt.IsZATCAIntegrationModuleActive() then exit;
        ZATCADeviceOnboarding.Get();
        Url := ZATCADeviceOnboarding."Base URL" + ZATCADeviceOnboarding."Submit Document Endpoint";
        if ZATCAPayloadMgt.SalesInvoiceInvoiceXML(SalesInvoiceHeader, InvoiceXml, InvoiceId, IsB2B) then begin
            Base64 := Base64Convert.ToBase64(Format(InvoiceXml), TextEncoding::UTF8);
            Body := ZATCAPayloadMgt.RequestPayload(Base64);
            SendHttpRequest(Url, Response, HttpRequestType::POST, Body);
            if ResponseJson.ReadFrom(Response) then
                if ResponseJson.Get('InvoiceReportingResponse', JToken) then begin
                    if Format(JToken) <> 'null' then InvoiceReportingResults := JToken.AsObject();
                    if InvoiceReportingResults.Get('IsSuccess', JToken) then InvoiceSigned := JToken.AsValue().AsBoolean();
                    if InvoiceSigned then
                        if ResponseJson.Get('InvoicevalidationResult', JToken) then begin
                            InvoiceValidationResults := JToken.AsObject();
                            if InvoiceValidationResults.Get('InvoiceHash', JToken) then begin
                                ZATCAHash.SetAscending(ID, true);
                                if ZATCAHash.FindLast() then begin
                                    ICV := ZATCAHash."Invoice Counter Value";
                                    PIH := JToken.AsValue().AsText()
                                end
                                else begin
                                    ICV := 1;
                                    PIH := ZATCADeviceOnboarding."First Invoice Hash";
                                end;
                                Clear(ZATCAHash);
                                ZATCAHash.Init();
                                ZATCAHash."Previous Invoice Hash" := CopyStr(PIH, 1, MaxStrLen(ZATCAHash."Previous Invoice Hash"));
                                ZATCAHash."Invoice Counter Value" := ICV + 1;
                                ZATCAHash."BC Invoice Number" := SalesInvoiceHeader."No.";
                                ZATCAHash."ZATCA ID" := CopyStr(InvoiceId, 1, MaxStrLen(ZATCAHash."ZATCA ID"));
                                ZATCAHash.Insert();
                            end;
                            if InvoiceValidationResults.Get('QRCode', JToken) then begin
                                SalesInvoiceHeader.QRCode := CopyStr(JToken.AsValue().AsText(), 1, MaxStrLen(SalesInvoiceHeader.QRCode));
                                SalesInvoiceHeader."Has QR Code" := true;
                                SalesInvoiceHeader."Invoice Hash" := CopyStr(PIH, 1, MaxStrLen(SalesInvoiceHeader."Invoice Hash"));
                                SalesInvoiceHeader."ZATCA Id" := CopyStr(InvoiceId, 1, MaxStrLen(SalesInvoiceHeader."ZATCA Id"));
                                SalesInvoiceHeader."Issue Date" := Today();
                                if IsB2B then
                                    SalesInvoiceHeader.Status := SalesInvoiceHeader.Status::Cleared
                                else
                                    SalesInvoiceHeader.Status := SalesInvoiceHeader.Status::Reported;
                                if IsPostedDoc then Message('Approved from ZATCA!');
                            end;
                        end;
                    if (not InvoiceSigned) and ResponseJson.Get('InvoicevalidationResult', JToken) then begin
                        InvoiceValidationResults := JToken.AsObject();
                        if InvoiceValidationResults.Get('IsValid', JToken) then
                            if not JToken.AsValue().AsBoolean() then
                                if InvoiceValidationResults.Get('lstSteps', JToken) then begin
                                    ZATCAErrorLog.SetRange("Document No.", SalesInvoiceHeader."No.");
                                    if ZATCAErrorLog.FindSet() then ZATCAErrorLog.DeleteAll();
                                    ErrorMessagesArray := JToken.AsArray();
                                    SalesInvoiceHeader.Status := SalesInvoiceHeader.Status::Error;
                                    SalesInvoiceHeader."ZATCA Message" := 'Invoice Validation Error.Please check error logs.';
                                    foreach ErrorDetail in ErrorMessagesArray do begin
                                        ErrorMessage := ErrorDetail.AsObject();
                                        if ErrorMessage.Get('IsValid', JToken) then
                                            if not JToken.AsValue().AsBoolean() then begin
                                                Clear(ZATCAErrorLog);
                                                ZATCAErrorLog.Init();
                                                if IsPostedDoc then begin
                                                    if ErrorMessage.Get('ErrorMessage', JToken) then ZATCAErrorLog.Message := CopyStr(JToken.AsValue().AsText(), 1, MaxStrLen(ZATCAErrorLog.Message));
                                                    ZATCAErrorLog.Status := 'Error';
                                                    ZATCAErrorLog."Document No." := SalesInvoiceHeader."No.";
                                                    ZATCAErrorLog.Insert();
                                                end
                                                else if ErrorMessage.Get('IsValid', JToken) then if not JToken.AsValue().AsBoolean() and (ErrorMessage.Get('ErrorMessage', JToken)) then ErrorToShow += JToken.AsValue().AsText() + '\\';
                                            end;
                                    end;
                                    if not IsPostedDoc then Error(ErrorToShow);
                                end;
                    end
                    else if (not InvoiceSigned) then begin
                        SalesInvoiceHeader.Status := SalesInvoiceHeader.Status::Error;
                        if IsB2B then
                            InvoiceReportingResults.Get('ClearanceStatus', JToken)
                        else
                            InvoiceReportingResults.Get('ReportingStatus', JToken);
                        if (JToken.AsValue().AsText() = 'NOT_CLEARED') or (JToken.AsValue().AsText() = 'NOT_REPORTED') then SalesInvoiceHeader.Status := SalesInvoiceHeader.Status::Error;
                        if InvoiceReportingResults.Get('ErrorMessage', JToken) then SalesInvoiceHeader."ZATCA Message" := CopyStr(JToken.AsValue().AsText(), 1, MaxStrLen(SalesInvoiceHeader."ZATCA Message"));
                        if InvoiceReportingResults.Get('validationResults', JToken) then begin
                            ValidationResults := JToken.AsObject();
                            if ValidationResults.Get('ErrorMessages', JToken) then begin
                                ErrorMessagesArray := JToken.AsArray();
                                ZATCAErrorLog.SetRange("Document No.", SalesInvoiceHeader."No.");
                                if ZATCAErrorLog.FindSet() then ZATCAErrorLog.DeleteAll();
                                foreach ErrorDetail in ErrorMessagesArray do begin
                                    ErrorMessage := ErrorDetail.AsObject();
                                    Clear(ZATCAErrorLog);
                                    ZATCAErrorLog.Init();
                                    if IsPostedDoc then begin
                                        if ErrorMessage.Get('Type', JToken) then ZATCAErrorLog.Type := CopyStr(JToken.AsValue().AsText(), 1, MaxStrLen(ZATCAErrorLog.Type));
                                        if ErrorMessage.Get('Code', JToken) then ZATCAErrorLog.Code := CopyStr(JToken.AsValue().AsText(), 1, MaxStrLen(ZATCAErrorLog.Code));
                                        if ErrorMessage.Get('Category', JToken) then ZATCAErrorLog.Category := CopyStr(JToken.AsValue().AsText(), 1, MaxStrLen(ZATCAErrorLog.Category));
                                        if ErrorMessage.Get('Message', JToken) then ZATCAErrorLog.Message := CopyStr(JToken.AsValue().AsText(), 1, MaxStrLen(ZATCAErrorLog.Message));
                                        if ErrorMessage.Get('Status', JToken) then ZATCAErrorLog.Status := CopyStr(JToken.AsValue().AsText(), 1, MaxStrLen(ZATCAErrorLog.Status));
                                        ZATCAErrorLog."Document No." := SalesInvoiceHeader."No.";
                                        ZATCAErrorLog.Insert();
                                    end
                                    else begin
                                        if ErrorMessage.Get('Code', JToken) then ErrorToShow += JToken.AsValue().AsText() + '\';
                                        if ErrorMessage.Get('Category', JToken) then ErrorToShow += JToken.AsValue().AsText() + '\';
                                        if ErrorMessage.Get('Message', JToken) then ErrorToShow += JToken.AsValue().AsText() + '\\\';
                                    end;
                                end;
                                if not IsPostedDoc then Error(ErrorToShow);
                            end
                        end;
                    end;
                    if SalesInvoiceHeader.Modify() then;
                end;
        end
        else begin
            SalesInvoiceHeader."ZATCA Message" := CopyStr(GetLastErrorText(), 1, MaxStrLen(SalesInvoiceHeader."ZATCA Message"));
            SalesInvoiceHeader.Status := SalesInvoiceHeader.Status::Error;
            if not IsPostedDoc then
                Error(GetLastErrorText())
            else
                Message(GetLastErrorText());
            SalesInvoiceHeader.Modify();
        end;
    end;

    [TryFunction]
    internal procedure SignAndSubmit(SalesCrMemoHeader: Record "Sales Cr.Memo Header"; IsPostedDoc: Boolean)
    var
        ZATCADeviceOnboarding: Record "ZATCA Device Onboarding";
        InvoiceSigned, IsB2B : Boolean;
        ICV: Integer;
        ErrorMessagesArray: JsonArray;
        ErrorMessage, InvoiceReportingResults, InvoiceValidationResults, ResponseJson, ValidationResults : JsonObject;
        ErrorDetail, JToken : JsonToken;
        Base64, Body, CrMemoId, ErrorToShow, PIH, Response, Url : Text;
        CrMemoXml: XmlDocument;
    begin
        if not ZATCAActivationMgt.IsZATCAIntegrationModuleActive() then exit;
        ZATCADeviceOnboarding.Get();
        Url := ZATCADeviceOnboarding."Base URL" + ZATCADeviceOnboarding."Submit Document Endpoint";
        if ZATCAPayloadMgt.SalesCreditMemoXML(SalesCrMemoHeader, CrMemoXml, CrMemoId, IsB2B) then begin
            Base64 := Base64Convert.ToBase64(Format(CrMemoXml));
            Body := ZATCAPayloadMgt.RequestPayload(Base64);
            SendHttpRequest(Url, Response, HttpRequestType::POST, Body);
            if ResponseJson.ReadFrom(Response) then
                if ResponseJson.Get('InvoiceReportingResponse', JToken) then begin
                    if Format(JToken) <> 'null' then InvoiceReportingResults := JToken.AsObject();
                    if InvoiceReportingResults.Get('IsSuccess', JToken) then InvoiceSigned := JToken.AsValue().AsBoolean();
                    if InvoiceSigned then
                        if ResponseJson.Get('InvoicevalidationResult', JToken) then begin
                            InvoiceValidationResults := JToken.AsObject();
                            if InvoiceValidationResults.Get('InvoiceHash', JToken) then begin
                                ZATCAHash.SetAscending(ID, true);
                                if ZATCAHash.FindLast() then begin
                                    ICV := ZATCAHash."Invoice Counter Value";
                                    PIH := JToken.AsValue().AsText()
                                end
                                else begin
                                    ICV := 1;
                                    PIH := ZATCADeviceOnboarding."First Invoice Hash";
                                end;
                                Clear(ZATCAHash);
                                ZATCAHash.Init();
                                ZATCAHash."Previous Invoice Hash" := CopyStr(PIH, 1, MaxStrLen(ZATCAHash."Previous Invoice Hash"));
                                ZATCAHash."Invoice Counter Value" := ICV + 1;
                                ZATCAHash."BC Invoice Number" := SalesCrMemoHeader."No.";
                                ZATCAHash."ZATCA ID" := CopyStr(CrMemoId, 1, MaxStrLen(ZATCAHash."ZATCA ID"));
                                ZATCAHash.Insert();
                            end;
                            if InvoiceValidationResults.Get('QRCode', JToken) then begin
                                SalesCrMemoHeader.QRCode := CopyStr(JToken.AsValue().AsText(), 1, MaxStrLen(SalesCrMemoHeader.QRCode));
                                SalesCrMemoHeader."Has QR Code" := true;
                                SalesCrMemoHeader."Invoice Hash" := CopyStr(PIH, 1, MaxStrLen(SalesCrMemoHeader."Invoice Hash"));
                                SalesCrMemoHeader."ZATCA Id" := CopyStr(CrMemoId, 1, MaxStrLen(SalesCrMemoHeader."ZATCA Id"));
                                SalesCrMemoHeader."Issue Date" := Today();
                                if IsB2B then
                                    SalesCrMemoHeader.Status := SalesCrMemoHeader.Status::Cleared
                                else
                                    SalesCrMemoHeader.Status := SalesCrMemoHeader.Status::Reported;
                                if IsPostedDoc then Message('Approved from ZATCA!');
                            end;
                        end;
                    if (not InvoiceSigned) and ResponseJson.Get('InvoicevalidationResult', JToken) then begin
                        InvoiceValidationResults := JToken.AsObject();
                        if InvoiceValidationResults.Get('IsValid', JToken) then
                            if not JToken.AsValue().AsBoolean() then
                                if InvoiceValidationResults.Get('lstSteps', JToken) then begin
                                    ZATCAErrorLog.SetRange("Document No.", SalesCrMemoHeader."No.");
                                    if ZATCAErrorLog.FindSet() then ZATCAErrorLog.DeleteAll();
                                    ErrorMessagesArray := JToken.AsArray();
                                    SalesCrMemoHeader.Status := SalesCrMemoHeader.Status::Error;
                                    SalesCrMemoHeader."ZATCA Message" := 'Invoice Validation Error.Please check error logs.';
                                    foreach ErrorDetail in ErrorMessagesArray do begin
                                        ErrorMessage := ErrorDetail.AsObject();
                                        if ErrorMessage.Get('IsValid', JToken) then
                                            if not JToken.AsValue().AsBoolean() then begin
                                                Clear(ZATCAErrorLog);
                                                ZATCAErrorLog.Init();
                                                if IsPostedDoc then begin
                                                    if ErrorMessage.Get('ErrorMessage', JToken) then ZATCAErrorLog.Message := CopyStr(JToken.AsValue().AsText(), 1, MaxStrLen(ZATCAErrorLog.Message));
                                                    ZATCAErrorLog.Status := 'Error';
                                                    ZATCAErrorLog."Document No." := SalesCrMemoHeader."No.";
                                                    ZATCAErrorLog.Insert();
                                                end
                                                else if ErrorMessage.Get('IsValid', JToken) then if not JToken.AsValue().AsBoolean() and (ErrorMessage.Get('ErrorMessage', JToken)) then ErrorToShow += JToken.AsValue().AsText() + '\\';
                                            end;
                                    end;
                                    if not IsPostedDoc then Error(ErrorToShow);
                                end;
                    end
                    else if not InvoiceSigned then begin
                        SalesCrMemoHeader.Status := SalesCrMemoHeader.Status::Error;
                        if IsB2B then
                            InvoiceReportingResults.Get('ClearanceStatus', JToken)
                        else
                            InvoiceReportingResults.Get('ReportingStatus', JToken);
                        if (JToken.AsValue().AsText() = 'NOT_CLEARED') or (JToken.AsValue().AsText() = 'NOT_REPORTED') then SalesCrMemoHeader.Status := SalesCrMemoHeader.Status::Error;
                        if InvoiceReportingResults.Get('ErrorMessage', JToken) then SalesCrMemoHeader."ZATCA Message" := CopyStr(JToken.AsValue().AsText(), 1, MaxStrLen(SalesCrMemoHeader."ZATCA Message"));
                        if InvoiceReportingResults.Get('validationResults', JToken) then begin
                            ValidationResults := JToken.AsObject();
                            if ValidationResults.Get('ErrorMessages', JToken) then begin
                                ErrorMessagesArray := JToken.AsArray();
                                ZATCAErrorLog.SetRange("Document No.", SalesCrMemoHeader."No.");
                                if ZATCAErrorLog.FindSet() then ZATCAErrorLog.DeleteAll();
                                foreach ErrorDetail in ErrorMessagesArray do begin
                                    ErrorMessage := ErrorDetail.AsObject();
                                    Clear(ZATCAErrorLog);
                                    ZATCAErrorLog.Init();
                                    if ErrorMessage.Get('Type', JToken) then ZATCAErrorLog.Type := CopyStr(JToken.AsValue().AsText(), 1, MaxStrLen(ZATCAErrorLog.Type));
                                    if ErrorMessage.Get('Code', JToken) then ZATCAErrorLog.Code := CopyStr(JToken.AsValue().AsText(), 1, MaxStrLen(ZATCAErrorLog.Code));
                                    if ErrorMessage.Get('Category', JToken) then ZATCAErrorLog.Category := CopyStr(JToken.AsValue().AsText(), 1, MaxStrLen(ZATCAErrorLog.Category));
                                    if ErrorMessage.Get('Message', JToken) then ZATCAErrorLog.Message := CopyStr(JToken.AsValue().AsText(), 1, MaxStrLen(ZATCAErrorLog.Message));
                                    if ErrorMessage.Get('Status', JToken) then ZATCAErrorLog.Status := CopyStr(JToken.AsValue().AsText(), 1, MaxStrLen(ZATCAErrorLog.Status));
                                    ZATCAErrorLog."Document No." := SalesCrMemoHeader."No.";
                                    ZATCAErrorLog.Insert();
                                end;
                            end
                        end;
                    end;
                    if SalesCrMemoHeader.Modify() then;
                end;
        end
        else begin
            SalesCrMemoHeader."ZATCA Message" := CopyStr(GetLastErrorText(), 1, MaxStrLen(SalesCrMemoHeader."ZATCA Message"));
            SalesCrMemoHeader.Status := SalesCrMemoHeader.Status::Error;
            if not IsPostedDoc then
                Error(GetLastErrorText())
            else
                Message(GetLastErrorText());
            SalesCrMemoHeader.Modify();
        end;
    end;

    local procedure SendHttpRequest(Url: Text; var ResponseTxt: Text; ActionType: Enum "Http Request Type"; Body: Text)
    var
        RequestDate: Date;
        ExecutionTime: Duration;
        HttpClient: HttpClient;
        HttpContent: HttpContent;
        HttpHeaders: HttpHeaders;
        HttpResponseMessage: HttpResponseMessage;
        EndTime, RequestTime, StartTime : Time;
    begin
        if not ZATCAActivationMgt.IsZATCAIntegrationModuleActive() then exit;
        Clear(HttpClient);
        Clear(HttpContent);
        Clear(HttpHeaders);
        Clear(HttpResponseMessage);
        case ActionType of
            ActionType::POST:
                begin
                    HttpContent.WriteFrom(Body);
                    HttpContent.ReadAs(Body);
                end;
        end;
        HttpContent.GetHeaders(HttpHeaders);
        HttpHeaders.Remove('Content-Type');
        HttpHeaders.Remove('Content-Length');
        HttpHeaders.Add('Content-Type', 'application/json');
        StartTime := Time();
        RequestDate := DT2Date(CurrentDateTime);
        RequestTime := DT2Time(CurrentDateTime);
        case ActionType of
            ActionType::POST:
                if HttpClient.Post(URL, HttpContent, HttpResponseMessage) then;
            ActionType::GET:
                HttpClient.Get(URL, HttpResponseMessage);
        end;
        EndTime := Time();
        HttpResponseMessage.Content().ReadAs(ResponseTxt);
        ExecutionTime := EndTime - StartTime;
        LogHttpRequest(URL, HttpResponseMessage, Body, HttpResponseMessage.IsSuccessStatusCode, RequestDate, RequestTime, ExecutionTime, ActionType);
    end;

    internal procedure LogHttpRequest(URL: Text; HttpResponseMessage: HttpResponseMessage; Body: Text; HttpStatusCode: Boolean; RequestDate: Date; RequestTime: Time; ExecutionTime: Duration; ActionType: Enum "Http Request Type")
    var
        ZATCAAPILog: Record "ZATCA API Log";
        ResponseMessage: Text;
    begin
        if not ZATCAActivationMgt.IsZATCAIntegrationModuleActive() then exit;
        ZATCAAPILog.Reset();
        ZATCAAPILog.Init();
        ZATCAAPILog."Request URL" := CopyStr(URL, 1, MaxStrLen(ZATCAAPILog."Request URL"));
        ZATCAAPILog."Request Date" := RequestDate;
        ZATCAAPILog."Request Time" := RequestTime;
        ZATCAAPILog."Request Method" := ActionType;
        ZATCAAPILog.User := CopyStr(UserId(), 1, MaxStrLen(ZATCAAPILog.User));
        ZATCAAPILog.SetRequestBody(Body);
        if HttpResponseMessage.Content.ReadAs(ResponseMessage) then ZATCAAPILog.SetResponseMessage(ResponseMessage);
        ZATCAAPILog."Response Code" := HttpResponseMessage.HttpStatusCode;
        ZATCAAPILog."Response Phrase" := CopyStr(HttpResponseMessage.ReasonPhrase, 1, MaxStrLen(ZATCAAPILog."Response Phrase"));
        ZATCAAPILog."Is Success" := HttpStatusCode;
        ZATCAAPILog."Execution Time" := ExecutionTime;
        if ZATCAAPILog.Insert() then;
    end;

    var
        ZATCAErrorLog: Record "ZATCA Error Log";
        ZATCAHash: Record "ZATCA Hash";
        Base64Convert: Codeunit "Base64 Convert";
        ZATCAActivationMgt: Codeunit "ZATCA Activation Mgt.";
        ZATCAPayloadMgt: Codeunit "ZATCA Payload Mgt.";
        HttpRequestType: Enum "Http Request Type";
}
