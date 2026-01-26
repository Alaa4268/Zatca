codeunit 50204 "ZATCA Payload Mgt."
{
    internal procedure OnboadingJsonBody(OldDeviceId: Text): Text
    var
        CertificateJsonObject: JsonObject;
        JsonObject: JsonObject;
        JsonBody: Text;
    begin
        ValidateOnboardingData();
        CertificateJsonObject.Add('CommonName', ZATCADeviceOnboarding."Device Id");
        CertificateJsonObject.Add('OTP', ZATCADeviceOnboarding.OTP);
        CertificateJsonObject.Add('OrganizationIdentifier', CompanyInformation."VAT Registration No.");
        if ZATCADeviceOnboarding.CSID = '' then
            ZATCADeviceOnboarding."Serial Number" := 1
        else if ZATCADeviceOnboarding."Device Id" <> OldDeviceId then ZATCADeviceOnboarding."Serial Number" += 1;
        CertificateJsonObject.Add('SerialNumber', ZATCADeviceOnboarding."Serial Code" + Format(ZATCADeviceOnboarding."Serial Number"));
        CertificateJsonObject.Add('InvoiceType', '1100');
        CertificateJsonObject.Add('Location', CompanyInformation.City);
        CertificateJsonObject.Add('StreetName', CompanyInformation.Address);
        CertificateJsonObject.Add('BuildingNumber', CompanyInformation."ZATCA Building No.");
        CertificateJsonObject.Add('OrganizationName', CompanyInformation.Name);
        CertificateJsonObject.Add('OrganizationUnitName', CompanyInformation.Name);
        CertificateJsonObject.Add('BusinessCategory', CompanyInformation."Industrial Classification");
        CertificateJsonObject.Add('CountryName', 'SA');
        CertificateJsonObject.Add('PostalZone', CompanyInformation."Post Code");
        if EnvironmentInformation.IsSandbox() then
            CertificateJsonObject.Add('mode', 1)
        else
            CertificateJsonObject.Add('mode', 2);
        JsonObject.Add('certrequest', CertificateJsonObject);
        JsonObject.Add('CR_No', CompanyInformation."Registration No.");
        ZATCADeviceOnboarding.Modify();
        JsonObject.WriteTo(JsonBody);
        exit(JsonBody);
    end;

    local procedure ValidateOnboardingData();
    begin
        ZATCADeviceOnboarding.Get();
        ZATCADeviceOnboarding.TestField(OTP);
        ZATCADeviceOnboarding.TestField("Device Id");
        ZATCADeviceOnboarding.TestField("Serial Number");
        ValidateCompanyInformation();
    end;

    local procedure ValidateCompanyInformation()
    begin
        CompanyInformation.Get();
        CompanyInformation.TestField("VAT Registration No.");
        CompanyInformation.TestField(City);
        CompanyInformation.TestField(Name);
        CompanyInformation.TestField("ZATCA Street Name");
        CompanyInformation.TestField("ZATCA Building No.");
        CompanyInformation.TestField("Country/Region Code");
        CompanyInformation.TestField("Registration No.");
    end;

    local procedure ValidateCustomerInfo()
    var
        CustomerTypeLbl: label '%1 Customer should be either B2B or B2C', Comment = '%1:Customer No.';
    begin
        if Customer."Is B2B" then begin
            Customer.TestField("VAT Registration No.");
            Customer.TestField(City);
            Customer.TestField(Name);
            Customer.TestField("ZATCA Scheme Type");
            Customer.TestField("ZATCA Scheme ID");
            Customer.TestField("ZATCA Street Name");
            Customer.TestField("ZATCA Building No.");
            Customer.TestField("Country/Region Code");
        end else begin
            Customer.TestField("ZATCA Scheme Type");
            Customer.TestField("ZATCA Scheme ID");
            Customer.TestField("Mobile Phone No.");
            Customer.TestField(Address);
        end;
        if (not Customer."Is B2B") and (not Customer."Is B2C") then Error(CustomerTypeLbl, Customer."No.");
    end;

    local procedure ValidateSupplierAddressError(var ValidationMsg: Text): Boolean
    var
        HasError: Boolean;
    begin
        if (StrLen(CompanyInformation."ZATCA Building No.") > 4) or (CompanyInformation."ZATCA Building No." = '') then begin
            ValidationMsg += 'Supplier''s Building No field value should have 4 digits.\\';
            HasError := true;
        end;
        if (StrLen(CompanyInformation."Post Code") > 5) or (CompanyInformation."Post Code" = '') then begin
            ValidationMsg += 'Supplier''s Postal Code field value can have 5 digits';
            HasError := true;
        end;
        exit(HasError);
    end;

    internal procedure RequestPayload(InputXMLString: Text): Text
    var
        JsonObject: JsonObject;
        JsonBody: Text;
    begin
        ZATCADeviceOnboarding.Get();
        JsonObject.Add('publicKey', ZATCADeviceOnboarding.CSID);
        JsonObject.Add('privatekey', ZATCADeviceOnboarding."Private Key");
        JsonObject.Add('Secretpassword', ZATCADeviceOnboarding."Secret Key");
        if EnvironmentInformation.IsSandbox() then
            JsonObject.Add('mode', 1)
        else
            JsonObject.Add('mode', 2);
        JsonObject.Add('XMLFilePath', 'C:\\ZATCAConfiguration\\BF-ZATCA-INPUT-DATAFILE.xml');
        JsonObject.Add('SignXMLFilePath', 'C:\\ZATCAConfiguration\\BF-ZATCA-OUTPUT-DATAFILE.xml');
        JsonObject.Add('isRequestResponseInline', 'true');
        JsonObject.Add('InputXMLString', InputXMLString);
        JsonObject.WriteTo(JsonBody);
        //  Message(JsonBody);
        exit(JsonBody);
    end;

    local procedure CreateAccountingSupplierParty(): XmlElement
    var
        XmlAtt: XmlAttribute;
        AccountingParty, Country, Party, PartyIdentification, PostalAddress : xmlElement;
        AdditonalDocReferenceValue, PartyTaxScheme, TaxScheme : xmlElement;
    begin
        AccountingParty := XmlElement.Create('AccountingSupplierParty', CacNamespaceUri);
        Party := XmlElement.Create('Party', CacNamespaceUri);
        PartyIdentification := XmlElement.Create('PartyIdentification', CacNamespaceUri);
        AdditonalDocReferenceValue := XmlElement.Create('ID', CbcNamespaceUri);
        case CompanyInformation."ZATCA Scheme Type" of
            CompanyInformation."ZATCA Scheme Type"::TIN:
                XmlAtt := XmlAttribute.Create('schemeID', 'TIN');
            CompanyInformation."ZATCA Scheme Type"::SAG:
                XmlAtt := XmlAttribute.Create('schemeID', 'SAG');
            CompanyInformation."ZATCA Scheme Type"::PAS:
                XmlAtt := XmlAttribute.Create('schemeID', 'PAS');
            CompanyInformation."ZATCA Scheme Type"::OTH:
                XmlAtt := XmlAttribute.Create('schemeID', 'OTH');
            CompanyInformation."ZATCA Scheme Type"::NAT:
                XmlAtt := XmlAttribute.Create('schemeID', 'NAT');
            CompanyInformation."ZATCA Scheme Type"::MOM:
                XmlAtt := XmlAttribute.Create('schemeID', 'MOM');
            CompanyInformation."ZATCA Scheme Type"::MLS:
                XmlAtt := XmlAttribute.Create('schemeID', 'MLS');
            CompanyInformation."ZATCA Scheme Type"::IQA:
                XmlAtt := XmlAttribute.Create('schemeID', 'IQA');
            CompanyInformation."ZATCA Scheme Type"::GCC:
                XmlAtt := XmlAttribute.Create('schemeID', 'GCC');
            CompanyInformation."ZATCA Scheme Type"::CRN:
                XmlAtt := XmlAttribute.Create('schemeID', 'CRN');
            CompanyInformation."ZATCA Scheme Type"::"700":
                XmlAtt := XmlAttribute.Create('schemeID', '700');
            CompanyInformation."ZATCA Scheme Type"::" ":
                Error('Sheme Type on Company Information cannot be blank');
        end;
        AdditonalDocReferenceValue.Add(XmlAtt);
        CompanyInformation.TestField("ZATCA Scheme ID");
        AdditonalDocReferenceValue.Add(XmlText.Create(CompanyInformation."ZATCA Scheme ID"));
        PartyIdentification.Add(AdditonalDocReferenceValue);
        Party.Add(PartyIdentification);
        PostalAddress := XmlElement.Create('PostalAddress', CacNamespaceUri);
        AdditonalDocReferenceValue := XmlElement.Create('StreetName', CbcNamespaceUri);
        AdditonalDocReferenceValue.Add(XmlText.Create(CompanyInformation."ZATCA Street Name"));
        PostalAddress.Add(AdditonalDocReferenceValue);
        AdditonalDocReferenceValue := XmlElement.Create('BuildingNumber', CbcNamespaceUri);
        AdditonalDocReferenceValue.Add(XmlText.Create(CompanyInformation."ZATCA Building No."));
        PostalAddress.Add(AdditonalDocReferenceValue);
        AdditonalDocReferenceValue := XmlElement.Create('PlotIdentification', CbcNamespaceUri);
        AdditonalDocReferenceValue.Add(XmlText.Create(CompanyInformation."ZATCA Plot Identification"));
        PostalAddress.Add(AdditonalDocReferenceValue);
        AdditonalDocReferenceValue := XmlElement.Create('CitySubdivisionName', CbcNamespaceUri);
        AdditonalDocReferenceValue.Add(XmlText.Create(CompanyInformation.City));
        PostalAddress.Add(AdditonalDocReferenceValue);
        AdditonalDocReferenceValue := XmlElement.Create('CityName', CbcNamespaceUri);
        AdditonalDocReferenceValue.Add(XmlText.Create(CompanyInformation.City));
        PostalAddress.Add(AdditonalDocReferenceValue);
        AdditonalDocReferenceValue := XmlElement.Create('PostalZone', CbcNamespaceUri);
        AdditonalDocReferenceValue.Add(XmlText.Create(CompanyInformation."Post Code"));
        PostalAddress.Add(AdditonalDocReferenceValue);
        AdditonalDocReferenceValue := XmlElement.Create('CountrySubentity', CbcNamespaceUri);
        AdditonalDocReferenceValue.Add(XmlText.Create(CompanyInformation."Country/Region Code"));
        PostalAddress.Add(AdditonalDocReferenceValue);
        Country := XmlElement.Create('Country', CacNamespaceUri);
        AdditonalDocReferenceValue := XmlElement.Create('IdentificationCode', CbcNamespaceUri);
        AdditonalDocReferenceValue.Add(XmlText.Create(CompanyInformation."Country/Region Code"));
        Country.Add(AdditonalDocReferenceValue);
        PostalAddress.Add(Country);
        Party.Add(PostalAddress);
        PartyTaxScheme := XmlElement.Create('PartyTaxScheme', CacNamespaceUri);
        AdditonalDocReferenceValue := XmlElement.Create('CompanyID', CbcNamespaceUri);
        AdditonalDocReferenceValue.Add(XmlText.Create(CompanyInformation."VAT Registration No."));
        PartyTaxScheme.Add(AdditonalDocReferenceValue);
        TaxScheme := XmlElement.Create('TaxScheme', CacNamespaceUri);
        AdditonalDocReferenceValue := XmlElement.Create('ID', CbcNamespaceUri);
        AdditonalDocReferenceValue.Add(XmlText.Create('VAT'));
        TaxScheme.Add(AdditonalDocReferenceValue);
        PartyTaxScheme.Add(TaxScheme);
        Party.Add(PartyTaxScheme);
        PartyTaxScheme := XmlElement.Create('PartyLegalEntity', CacNamespaceUri);
        AdditonalDocReferenceValue := XmlElement.Create('RegistrationName', CbcNamespaceUri);
        AdditonalDocReferenceValue.Add(XmlText.Create(CompanyInformation.Name));
        PartyTaxScheme.Add(AdditonalDocReferenceValue);
        Party.Add(PartyTaxScheme);
        AccountingParty.Add(Party);
        exit(AccountingParty);
    end;

    local procedure CreateAccountingCustomerParty(): XmlElement
    var
        XmlAtt: XmlAttribute;
        AccountingParty, Country, Party, PartyIdentification, PostalAddress : xmlElement;
        AdditonalDocReferenceValue, PartyTaxScheme, TaxScheme : xmlElement;
    begin
        AccountingParty := XmlElement.Create('AccountingCustomerParty', CacNamespaceUri);
        Party := XmlElement.Create('Party', CacNamespaceUri);
        PartyIdentification := XmlElement.Create('PartyIdentification', CacNamespaceUri);
        AdditonalDocReferenceValue := XmlElement.Create('ID', CbcNamespaceUri);
        case Customer."ZATCA Scheme Type" of
            Customer."ZATCA Scheme Type"::TIN:
                XmlAtt := XmlAttribute.Create('schemeID', 'TIN');
            Customer."ZATCA Scheme Type"::SAG:
                XmlAtt := XmlAttribute.Create('schemeID', 'SAG');
            Customer."ZATCA Scheme Type"::PAS:
                XmlAtt := XmlAttribute.Create('schemeID', 'PAS');
            Customer."ZATCA Scheme Type"::OTH:
                XmlAtt := XmlAttribute.Create('schemeID', 'OTH');
            Customer."ZATCA Scheme Type"::NAT:
                XmlAtt := XmlAttribute.Create('schemeID', 'NAT');
            Customer."ZATCA Scheme Type"::MOM:
                XmlAtt := XmlAttribute.Create('schemeID', 'MOM');
            Customer."ZATCA Scheme Type"::MLS:
                XmlAtt := XmlAttribute.Create('schemeID', 'MLS');
            Customer."ZATCA Scheme Type"::IQA:
                XmlAtt := XmlAttribute.Create('schemeID', 'IQA');
            Customer."ZATCA Scheme Type"::GCC:
                XmlAtt := XmlAttribute.Create('schemeID', 'GCC');
            Customer."ZATCA Scheme Type"::CRN:
                XmlAtt := XmlAttribute.Create('schemeID', 'CRN');
            Customer."ZATCA Scheme Type"::"700":
                XmlAtt := XmlAttribute.Create('schemeID', '700');
            Customer."ZATCA Scheme Type"::" ":
                Error('Sheme Type on customer cannot be blank');
        end;
        AdditonalDocReferenceValue.Add(XmlAtt);
        AdditonalDocReferenceValue.Add(XmlText.Create(Customer."ZATCA Scheme ID"));
        PartyIdentification.Add(AdditonalDocReferenceValue);
        Party.Add(PartyIdentification);
        PostalAddress := XmlElement.Create('PostalAddress', CacNamespaceUri);
        AdditonalDocReferenceValue := XmlElement.Create('StreetName', CbcNamespaceUri);
        AdditonalDocReferenceValue.Add(XmlText.Create(Customer."ZATCA Street Name"));
        PostalAddress.Add(AdditonalDocReferenceValue);
        AdditonalDocReferenceValue := XmlElement.Create('BuildingNumber', CbcNamespaceUri);
        AdditonalDocReferenceValue.Add(XmlText.Create(Customer."ZATCA Building No."));
        PostalAddress.Add(AdditonalDocReferenceValue);
        AdditonalDocReferenceValue := XmlElement.Create('PlotIdentification', CbcNamespaceUri);
        AdditonalDocReferenceValue.Add(XmlText.Create(Customer."ZATCA Plot Identification"));
        PostalAddress.Add(AdditonalDocReferenceValue);
        AdditonalDocReferenceValue := XmlElement.Create('CitySubdivisionName', CbcNamespaceUri);
        AdditonalDocReferenceValue.Add(XmlText.Create(Customer.City));
        PostalAddress.Add(AdditonalDocReferenceValue);
        AdditonalDocReferenceValue := XmlElement.Create('CityName', CbcNamespaceUri);
        AdditonalDocReferenceValue.Add(XmlText.Create(Customer.City));
        PostalAddress.Add(AdditonalDocReferenceValue);
        AdditonalDocReferenceValue := XmlElement.Create('PostalZone', CbcNamespaceUri);
        AdditonalDocReferenceValue.Add(XmlText.Create(Customer."Post Code"));
        PostalAddress.Add(AdditonalDocReferenceValue);
        AdditonalDocReferenceValue := XmlElement.Create('CountrySubentity', CbcNamespaceUri);
        AdditonalDocReferenceValue.Add(XmlText.Create(Customer."Country/Region Code"));
        PostalAddress.Add(AdditonalDocReferenceValue);
        Country := XmlElement.Create('Country', CacNamespaceUri);
        AdditonalDocReferenceValue := XmlElement.Create('IdentificationCode', CbcNamespaceUri);
        AdditonalDocReferenceValue.Add(XmlText.Create(Customer."Country/Region Code"));
        Country.Add(AdditonalDocReferenceValue);
        PostalAddress.Add(Country);
        Party.Add(PostalAddress);
        PartyTaxScheme := XmlElement.Create('PartyTaxScheme', CacNamespaceUri);
        AdditonalDocReferenceValue := XmlElement.Create('CompanyID', CbcNamespaceUri);
        AdditonalDocReferenceValue.Add(XmlText.Create(Customer."VAT Registration No."));
        PartyTaxScheme.Add(AdditonalDocReferenceValue);
        TaxScheme := XmlElement.Create('TaxScheme', CacNamespaceUri);
        AdditonalDocReferenceValue := XmlElement.Create('ID', CbcNamespaceUri);
        AdditonalDocReferenceValue.Add(XmlText.Create('VAT'));
        TaxScheme.Add(AdditonalDocReferenceValue);
        PartyTaxScheme.Add(TaxScheme);
        Party.Add(PartyTaxScheme);
        PartyTaxScheme := XmlElement.Create('PartyLegalEntity', CacNamespaceUri);
        AdditonalDocReferenceValue := XmlElement.Create('RegistrationName', CbcNamespaceUri);
        AdditonalDocReferenceValue.Add(XmlText.Create(Customer.Name));
        PartyTaxScheme.Add(AdditonalDocReferenceValue);
        Party.Add(PartyTaxScheme);
        AccountingParty.Add(Party);
        exit(AccountingParty);
    end;

    local procedure CreatePIH(): XmlElement
    var
        ZATCAHash: Record "ZATCA Hash";
        XmlAtt: XmlAttribute;
        AdditonalDocReferenceValue, Attachment, InvoiceHeaderElement : XmlElement;
    begin
        InvoiceHeaderElement := XmlElement.Create('AdditionalDocumentReference', CacNamespaceUri);
        AdditonalDocReferenceValue := XmlElement.Create('ID', CbcNamespaceUri);
        AdditonalDocReferenceValue.Add(XmlText.Create('PIH'));
        InvoiceHeaderElement.Add(AdditonalDocReferenceValue);
        Attachment := XmlElement.Create('Attachment', CacNamespaceUri);
        AdditonalDocReferenceValue := XmlElement.Create('EmbeddedDocumentBinaryObject', CbcNamespaceUri);
        XmlAtt := XmlAttribute.Create('mimeCode', 'text/plain');
        AdditonalDocReferenceValue.Add(XmlAtt);
        ZATCAHash.SetAscending(ID, true);
        if not ZATCAHash.FindLast() then begin
            ZATCADeviceOnboarding.Get();
            AdditonalDocReferenceValue.Add(XmlText.Create(ZATCADeviceOnboarding."First Invoice Hash"))
        end
        else
            AdditonalDocReferenceValue.Add(XmlText.Create(ZATCAHash."Previous Invoice Hash"));
        Attachment.Add(AdditonalDocReferenceValue);
        InvoiceHeaderElement.Add(Attachment);
        exit(InvoiceHeaderElement);
    end;

    local procedure CreateICV(): XmlElement
    var
        ZATCAHash: Record "ZATCA Hash";
        AdditonalDocReferenceValue, InvoiceHeaderElement : XmlElement;
    begin
        InvoiceHeaderElement := XmlElement.Create('AdditionalDocumentReference', CacNamespaceUri);
        AdditonalDocReferenceValue := XmlElement.Create('ID', CbcNamespaceUri);
        AdditonalDocReferenceValue.Add(XmlText.Create('ICV'));
        InvoiceHeaderElement.Add(AdditonalDocReferenceValue);
        AdditonalDocReferenceValue := XmlElement.Create('UUID', CbcNamespaceUri);
        ZATCAHash.SetAscending(ID, true);
        if ZATCAHash.FindLast() then;
        AdditonalDocReferenceValue.Add(XmlText.Create(Format(ZATCAHash."Invoice Counter Value" + 1)));
        InvoiceHeaderElement.Add(AdditonalDocReferenceValue);
        exit(InvoiceHeaderElement);
    end;

    local procedure SetPaymentMethodCode(PaymentMethodCode: Code[10]): Text
    var
        Code: Text;
    begin
        case PaymentMethodCode of
            'CHECK':
                Code := '20';
            'CASH':
                Code := '10';
            'CREDITCARD':
                Code := '54';
            'DEBIT CARD':
                Code := '55';
            'PAYPAL', 'ONLINE':
                Code := '68';
            'BANK', '':
                Code := '42';
            else
                Code := '42';
        end;
        exit(Code);
    end;

    [TryFunction]
    internal procedure SalesInvoiceInvoiceXML(SalesInvoiceHeader: Record "Sales Invoice Header"; var XmlDoc: XmlDocument; var InvoiceId: Text; var IsB2B: Boolean)
    var
        SalesInvoiceLine: Record "Sales Invoice Line";
        VATPostingSetup: Record "VAT Posting Setup";
        TaxableAmount, LineTaxAmount, TotalAmountExVAT, TotalTaxAmount, VATPercentage : Decimal;
        LineCount: Integer;
        CurrencyCode, ExemptedTaxCode, ExtemptedTax, OptionalTax, ZeroTax, ZeroTaxCode : Text;
        ExemptionReason, ValidationMsg, ZeroTaxDescription : Text;
        XmlAtt: XmlAttribute;
        Declaration: XmlDeclaration;
        AdditonalDocReferenceValue, InvoiceElement, InvoiceHeaderElement : XmlElement;
        AllowanceCharge, HeaderTaxTotal, InvoiceLine, Item, Price : XmlElement;
        PostalAddress, TaxCategory, TaxScheme, TaxTotal : xmlElement;
        SalesInvHeader: Record "Sales Header";
        MonitorValue: Decimal;
        FIleTest: OutStream;
        TempBlob: Codeunit "Temp Blob";
        OutStr: OutStream;
        InStr: InStream;
        FileName: Text;
        LineAmountExclVat: Decimal;
        LineAmountInclVat: Decimal;
    begin
        ValidateCompanyInformation();
        if Customer.Get(SalesInvoiceHeader."Sell-to Customer No.") then ValidateCustomerInfo();
        if ValidateSupplierAddressError(ValidationMsg) then Error(ValidationMsg);
        Clear(SalesInvoiceLine);
        Clear(TaxableAmount);
        LineCount := 0;
        SalesInvoiceLine.SetRange("Document No.", SalesInvoiceHeader."No.");
        if SalesInvoiceLine.FindSet() then
            repeat
                if SalesInvoiceLine.Type <> SalesInvoiceLine.Type::" " then begin
                    LineCount += 1;
                    // if SalesInvoiceLine."VAT %" <> 0 then   // this line is added by CIS-Alaa
                    VATPercentage := SalesInvoiceLine."VAT %";

                    // Recalculate line amount and tax amount +
                    LineAmountExclVat := GetInvoiceLineAmountExclVat(SalesInvoiceLine);
                    // LineTaxAmount := LineAmountInclVat - LineAmountExclVat;
                    LineTaxAmount := CalcLineTaxAmount(SalesInvoiceLine."VAT %", LineAmountExclVat);
                    LineAmountInclVat := GetInvoiceLineAmountInclVat(LineAmountExclVat, LineTaxAmount);
                    // LineTaxAmount := Round(LineAmountExclVat * (SalesInvoiceLine."VAT %" / 100), 0.01);
                    // Recalculate line amount and tax amount -

                    // TaxAmount := SalesInvoiceLine.GetLineAmountInclVAT() - SalesInvoiceLine.GetLineAmountExclVAT();
                    TotalTaxAmount += LineTaxAmount;
                    TotalAmountExVAT += Round(LineAmountExclVat, 0.01);

                    VATPostingSetup.SetRange("VAT Bus. Posting Group", SalesInvoiceLine."VAT Bus. Posting Group");
                    VATPostingSetup.SetRange("VAT Prod. Posting Group", SalesInvoiceLine."VAT Prod. Posting Group");
                    VATPostingSetup.SetRange("VAT %", SalesInvoiceLine."VAT %");
                    if VATPostingSetup.FindFirst() then
                        case VATPostingSetup."Tax Category" of
                            'Z':
                                begin
                                    ZeroTax := 'Z';
                                    ZeroTaxCode := VATPostingSetup."ZATCA VAT Exemption Code";
                                    ZeroTaxDescription := VATPostingSetup."ZATCA VAT Description";
                                end;
                            'E':
                                begin
                                    ExtemptedTax := 'E';
                                    ExemptedTaxCode := VATPostingSetup."ZATCA VAT Exemption Code";
                                    ExemptionReason := VATPostingSetup."ZATCA VAT Description";
                                end;
                            'O':
                                OptionalTax := 'O';
                        end;
                end;
            until SalesInvoiceLine.Next() = 0;
        XmlDoc := XmlDocument.Create();
        Declaration := XmlDeclaration.Create('1.0', 'utf-8', 'no');
        XmlDoc.SetDeclaration(Declaration);
        CacNamespacePrefix := 'cac';
        ExtNamespacePrefix := 'ext';
        ExtNamespaceUri := 'urn:oasis:names:specification:ubl:schema:xsd:CommonExtensionComponents-2';
        CacNamespaceUri := 'urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2';
        CbcNameSpacePrefix := 'cbc';
        CbcNamespaceUri := 'urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2';
        NamespaceUri := 'urn:oasis:names:specification:ubl:schema:xsd:Invoice-2';
        InvoiceElement := XmlElement.Create('Invoice', NamespaceUri);
        XmlAtt := XmlAttribute.CreateNamespaceDeclaration(CacNamespacePrefix, CacNamespaceUri);
        InvoiceElement.Add(XmlAtt);
        XmlAtt := XmlAttribute.CreateNamespaceDeclaration(CbcNameSpacePrefix, CbcNamespaceUri);
        InvoiceElement.Add(XmlAtt);
        XmlAtt := XmlAttribute.CreateNamespaceDeclaration(ExtNamespacePrefix, ExtNamespaceUri);
        InvoiceElement.Add(XmlAtt);
        InvoiceHeaderElement := XmlElement.Create('ProfileID', CbcNamespaceUri);
        InvoiceHeaderElement.Add(XmlText.Create('reporting:1.0'));
        InvoiceElement.Add(InvoiceHeaderElement);
        InvoiceHeaderElement := XmlElement.Create('ID', CbcNamespaceUri);
        InvoiceHeaderElement.Add(XmlText.Create(SalesInvoiceHeader."No."));
        InvoiceElement.Add(InvoiceHeaderElement);
        InvoiceHeaderElement := XmlElement.Create('UUID', CbcNamespaceUri);
        InvoiceId := CreateGuid();
        InvoiceId := InvoiceId.Replace('{', '').Replace('}', '');
        InvoiceHeaderElement.Add(XmlText.Create(InvoiceId));
        InvoiceElement.Add(InvoiceHeaderElement);
        InvoiceHeaderElement := XmlElement.Create('IssueDate', CbcNamespaceUri);
        InvoiceHeaderElement.Add(XmlText.Create(Format(SalesInvoiceHeader."Posting Date", 0, 9)));
        InvoiceElement.Add(InvoiceHeaderElement);
        InvoiceHeaderElement := XmlElement.Create('IssueTime', CbcNamespaceUri);
        InvoiceHeaderElement.Add(XmlText.Create(FormatTime()));
        InvoiceElement.Add(InvoiceHeaderElement);
        InvoiceHeaderElement := XmlElement.Create('InvoiceTypeCode', CbcNamespaceUri);
        if Customer."Is B2B" then
            XmlAtt := XmlAttribute.Create('name', '0100000')
        else if Customer."Is B2C" then XmlAtt := XmlAttribute.Create('name', '0200000');
        IsB2B := customer."Is B2B";
        InvoiceHeaderElement.Add(XmlAtt);
        InvoiceHeaderElement.Add(XmlText.Create('388'));
        InvoiceElement.Add(InvoiceHeaderElement);
        InvoiceHeaderElement := XmlElement.Create('DocumentCurrencyCode', CbcNamespaceUri);
        if SalesInvoiceHeader."Currency Code" <> '' then
            CurrencyCode := SalesInvoiceHeader."Currency Code"
        else
            CurrencyCode := 'SAR';
        InvoiceHeaderElement.Add(XmlText.Create(CurrencyCode));
        InvoiceElement.Add(InvoiceHeaderElement);
        InvoiceHeaderElement := XmlElement.Create('TaxCurrencyCode', CbcNamespaceUri);
        InvoiceHeaderElement.Add(XmlText.Create('SAR'));
        InvoiceElement.Add(InvoiceHeaderElement);
        AdditonalDocReferenceValue := XmlElement.Create('LineCountNumeric', CbcNamespaceUri);
        AdditonalDocReferenceValue.Add(XmlText.Create(Format(LineCount)));
        InvoiceElement.Add(AdditonalDocReferenceValue);
        //ICV
        InvoiceElement.Add(CreateICV());
        //PIH
        InvoiceElement.Add(CreatePIH());
        //Supplier Party
        InvoiceElement.Add(CreateAccountingSupplierParty());
        //Customer Party
        InvoiceElement.Add(CreateAccountingCustomerParty());
        //Delivery
        PostalAddress := XmlElement.Create('Delivery', CacNamespaceUri);
        AdditonalDocReferenceValue := XmlElement.Create('ActualDeliveryDate', CbcNamespaceUri);
        AdditonalDocReferenceValue.Add(XmlText.Create(Format(SalesInvoiceHeader."Shipment Date", 0, 9)));
        PostalAddress.Add(AdditonalDocReferenceValue);
        InvoiceElement.Add(PostalAddress);
        //
        PostalAddress := XmlElement.Create('PaymentMeans', CacNamespaceUri);
        AdditonalDocReferenceValue := XmlElement.Create('PaymentMeansCode', CbcNamespaceUri);
        //SetPaymentMethodCode
        AdditonalDocReferenceValue.Add(XmlText.Create(SetPaymentMethodCode((SalesInvoiceHeader."Payment Method Code"))));
        PostalAddress.Add(AdditonalDocReferenceValue);
        InvoiceElement.Add(PostalAddress);
        // Allowance Charge
        if SalesInvoiceHeader."Invoice Discount Amount" > 0 then begin
            AllowanceCharge := XmlElement.Create('AllowanceCharge', CacNamespaceUri);
            AdditonalDocReferenceValue := XmlElement.Create('ChargeIndicator', CbcNamespaceUri);
            AdditonalDocReferenceValue.Add(XmlText.Create('true'));
            AllowanceCharge.Add(AdditonalDocReferenceValue);
            AdditonalDocReferenceValue := XmlElement.Create('AllowanceChargeReason', CbcNamespaceUri);
            AdditonalDocReferenceValue.Add(XmlText.Create('discount'));
            AllowanceCharge.Add(AdditonalDocReferenceValue);
            AdditonalDocReferenceValue := XmlElement.Create('Amount', CbcNamespaceUri);
            XmlAtt := XmlAttribute.Create('currencyID', CurrencyCode);
            AdditonalDocReferenceValue.Add(XmlAtt);
            AdditonalDocReferenceValue.Add(XmlText.Create(Format(SalesInvoiceHeader."Invoice Discount Amount")));
            AllowanceCharge.Add(AdditonalDocReferenceValue);
            TaxCategory := XmlElement.Create('TaxCategory', CacNamespaceUri);
            AdditonalDocReferenceValue := XmlElement.Create('ID', CbcNamespaceUri);
            AdditonalDocReferenceValue.Add(XmlText.Create('S'));
            TaxCategory.Add(AdditonalDocReferenceValue);
            AdditonalDocReferenceValue := XmlElement.Create('Percent', CbcNamespaceUri);
            AdditonalDocReferenceValue.Add(XmlText.Create(Format(VATPercentage)));
            TaxCategory.Add(AdditonalDocReferenceValue);
            TaxScheme := XmlElement.Create('TaxScheme', CacNamespaceUri);
            AdditonalDocReferenceValue := XmlElement.Create('ID', CbcNamespaceUri);
            AdditonalDocReferenceValue.Add(XmlText.Create('VAT'));
            TaxScheme.Add(AdditonalDocReferenceValue);
            TaxCategory.Add(TaxScheme);
            AllowanceCharge.Add(TaxCategory);
            InvoiceElement.Add(AllowanceCharge);
        end;
        // Tax Total with Sub Totals
        HeaderTaxTotal := XmlElement.Create('TaxTotal', CacNamespaceUri);
        AdditonalDocReferenceValue := XmlElement.Create('TaxAmount', CbcNamespaceUri);
        XmlAtt := XmlAttribute.Create('currencyID', CurrencyCode);
        AdditonalDocReferenceValue.Add(XmlAtt);
        AdditonalDocReferenceValue.Add(XmlText.Create(Format(TotalTaxAmount).Replace(',', '')));
        HeaderTaxTotal.Add(AdditonalDocReferenceValue);
        if TotalTaxAmount > 0 then HeaderTaxTotal.Add(HeaderTaxSubTotalXml('S', CurrencyCode, TotalAmountExVAT, TotalTaxAmount, '', VATPercentage, ''));
        if ZeroTax = 'Z' then HeaderTaxTotal.Add(HeaderTaxSubTotalXml(ZeroTax, CurrencyCode, TotalAmountExVAT, 0.00, ZeroTaxCode, 0.00, ZeroTaxDescription));
        if ExtemptedTax = 'E' then HeaderTaxTotal.Add(HeaderTaxSubTotalXml(ExtemptedTax, CurrencyCode, TotalAmountExVAT, 0.00, ExemptedTaxCode, 0.00, ExemptionReason));
        if OptionalTax = 'O' then HeaderTaxTotal.Add(HeaderTaxSubTotalXml(OptionalTax, CurrencyCode, TotalAmountExVAT, 0.00, '', 0.00, ''));
        InvoiceElement.Add(HeaderTaxTotal);
        // TaxTotal
        TaxTotal := XmlElement.Create('TaxTotal', CacNamespaceUri);
        AdditonalDocReferenceValue := XmlElement.Create('TaxAmount', CbcNamespaceUri);
        XmlAtt := XmlAttribute.Create('currencyID', CurrencyCode);
        AdditonalDocReferenceValue.Add(XmlAtt);
        AdditonalDocReferenceValue.Add(XmlText.Create(Format(TotalTaxAmount).Replace(',', '')));
        TaxTotal.Add(AdditonalDocReferenceValue);
        InvoiceElement.Add(TaxTotal);
        // Legal Monetory Total
        InvoiceElement.Add(CreateLegalMonetoryTotal(TotalAmountExVAT, TotalTaxAmount, CurrencyCode, SalesInvoiceHeader."Invoice Discount Amount"));
        // Invoice Lines
        Clear(SalesInvoiceLine);
        Clear(TaxableAmount);
        LineCount := 0;
        HeaderTaxTotal := XmlElement.Create('TaxTotal', CacNamespaceUri);
        SalesInvoiceLine.SetRange("Document No.", SalesInvoiceHeader."No.");
        if SalesInvoiceLine.FindSet() then
            repeat
                LineCount += 1;
                if SalesInvoiceLine.Type <> SalesInvoiceLine.Type::" " then begin
                    InvoiceLine := XmlElement.Create('InvoiceLine', CacNamespaceUri);
                    AdditonalDocReferenceValue := XmlElement.Create('ID', CbcNamespaceUri);
                    AdditonalDocReferenceValue.Add(XmlText.Create(Format(LineCount)));
                    InvoiceLine.Add(AdditonalDocReferenceValue);
                    AdditonalDocReferenceValue := XmlElement.Create('InvoicedQuantity', CbcNamespaceUri);
                    XmlAtt := XmlAttribute.Create('unitCode', SalesInvoiceLine."Unit of Measure Code");
                    AdditonalDocReferenceValue.Add(XmlAtt);
                    AdditonalDocReferenceValue.Add(XmlText.Create(Format(SalesInvoiceLine.Quantity).Replace(',', '')));
                    InvoiceLine.Add(AdditonalDocReferenceValue);
                    AdditonalDocReferenceValue := XmlElement.Create('LineExtensionAmount', CbcNamespaceUri);
                    XmlAtt := XmlAttribute.Create('currencyID', CurrencyCode);
                    AdditonalDocReferenceValue.Add(XmlAtt);

                    // Recalculate line amount and tax amount +
                    LineAmountExclVat := GetInvoiceLineAmountExclVat(SalesInvoiceLine);
                    // LineTaxAmount := CalcTaxAmount(LineAmountExclVat,SalesInvoiceLine."VAT %");
                    LineTaxAmount := CalcLineTaxAmount(SalesInvoiceLine."VAT %", LineAmountExclVat);
                    LineAmountInclVat := GetInvoiceLineAmountInclVat(LineAmountExclVat, LineTaxAmount);
                    // Recalculate line amount and tax amount -

                    AdditonalDocReferenceValue.Add(XmlText.Create(Format(LineAmountExclVat).Replace(',', '')));
                    InvoiceLine.Add(AdditonalDocReferenceValue);
                    TaxTotal := XmlElement.Create('TaxTotal', CacNamespaceUri);
                    AdditonalDocReferenceValue := XmlElement.Create('TaxAmount', CbcNamespaceUri);
                    XmlAtt := XmlAttribute.Create('currencyID', CurrencyCode);
                    AdditonalDocReferenceValue.Add(XmlAtt);
                    AdditonalDocReferenceValue.Add(XmlText.Create(Format(LineTaxAmount).Replace(',', '')));
                    // AdditonalDocReferenceValue.Add(XmlText.Create(Format(Round(SalesInvoiceLine.GetLineAmountInclVAT() * 0.15, 0.01)).Replace(',', '')));
                    TaxTotal.Add(AdditonalDocReferenceValue);
                    AdditonalDocReferenceValue := XmlElement.Create('RoundingAmount', CbcNamespaceUri);
                    XmlAtt := XmlAttribute.Create('currencyID', CurrencyCode);
                    AdditonalDocReferenceValue.Add(XmlAtt);
                    AdditonalDocReferenceValue.Add(XmlText.Create(Format(LineAmountInclVat).Replace(',', '')));
                    // AdditonalDocReferenceValue.Add(XmlText.Create(Format(SalesInvoiceLine.GetLineAmountInclVAT()).Replace(',', '')));
                    TaxTotal.Add(AdditonalDocReferenceValue);
                    InvoiceLine.Add(TaxTotal);
                    Item := XmlElement.Create('Item', CacNamespaceUri);
                    AdditonalDocReferenceValue := XmlElement.Create('Name', CbcNamespaceUri);
                    AdditonalDocReferenceValue.Add(XmlText.Create(SalesInvoiceLine.Description));
                    Item.Add(AdditonalDocReferenceValue);
                    TaxCategory := XmlElement.Create('ClassifiedTaxCategory', CacNamespaceUri);
                    VATPostingSetup.SetRange("VAT Bus. Posting Group", SalesInvoiceLine."VAT Bus. Posting Group");
                    VATPostingSetup.SetRange("VAT Prod. Posting Group", SalesInvoiceLine."VAT Prod. Posting Group");
                    VATPostingSetup.SetRange("VAT %", SalesInvoiceLine."VAT %");
                    if VATPostingSetup.FindFirst() then begin
                        AdditonalDocReferenceValue := XmlElement.Create('ID', CbcNamespaceUri);
                        AdditonalDocReferenceValue.Add(XmlText.Create(VATPostingSetup."Tax Category"));
                        TaxCategory.Add(AdditonalDocReferenceValue);
                        AdditonalDocReferenceValue := XmlElement.Create('Percent', CbcNamespaceUri);
                        AdditonalDocReferenceValue.Add(XmlText.Create(Format(SalesInvoiceLine."VAT %").Replace(',', '')));
                        TaxCategory.Add(AdditonalDocReferenceValue);
                        TaxScheme := XmlElement.Create('TaxScheme', CacNamespaceUri);
                        AdditonalDocReferenceValue := XmlElement.Create('ID', CbcNamespaceUri);
                        AdditonalDocReferenceValue.Add(XmlText.Create('VAT'));
                        TaxScheme.Add(AdditonalDocReferenceValue);
                        TaxCategory.Add(TaxScheme);
                    end;
                    Item.Add(TaxCategory);
                    //
                    InvoiceLine.Add(Item);
                    Price := XmlElement.Create('Price', CacNamespaceUri);
                    AdditonalDocReferenceValue := XmlElement.Create('PriceAmount', CbcNamespaceUri);
                    XmlAtt := XmlAttribute.Create('currencyID', CurrencyCode);
                    AdditonalDocReferenceValue.Add(XmlAtt);
                    // Modify calculations to exclude vat from amount

                    AdditonalDocReferenceValue.Add(XmlText.Create(Format(Round(LineAmountExclVat / SalesInvoiceLine.Quantity, 0.0001)).Replace(',', '')));

                    // if SalesInvoiceHeader."Prices Including VAT" then
                    // AdditonalDocReferenceValue.Add(XmlText.Create(Format(Round(LineAmountExclVat / SalesInvoiceLine.Quantity, 0.0001)).Replace(',', '')));
                    // AdditonalDocReferenceValue.Add(XmlText.Create(Format(Round((SalesInvoiceLine."Unit Price" - ((SalesInvoiceLine."Line Discount %" / 100) * SalesInvoiceLine."Unit Price")) / ((1 + (SalesInvoiceLine."VAT %" / 100))), 0.01)).Replace(',', ''))) 
                    // else
                    // AdditonalDocReferenceValue.Add(XmlText.Create(Format(Round(LineAmountExclVat/SalesInvoiceLine.Quantity,0.0001)).Replace(',', '')));

                    Price.Add(AdditonalDocReferenceValue);


                    // Removed by customer's request, discount is not required in the XML
                    // Allowance Charge
                    // if SalesInvoiceLine."Line Discount Amount" > 0 then begin
                    //     AllowanceCharge := XmlElement.Create('AllowanceCharge', CacNamespaceUri);
                    //     AdditonalDocReferenceValue := XmlElement.Create('ChargeIndicator', CbcNamespaceUri);
                    //     AdditonalDocReferenceValue.Add(XmlText.Create('false'));
                    //     AllowanceCharge.Add(AdditonalDocReferenceValue);
                    //     AdditonalDocReferenceValue := XmlElement.Create('AllowanceChargeReason', CbcNamespaceUri);
                    //     AdditonalDocReferenceValue.Add(XmlText.Create('discount'));
                    //     AllowanceCharge.Add(AdditonalDocReferenceValue);
                    //     AdditonalDocReferenceValue := XmlElement.Create('Amount', CbcNamespaceUri);
                    //     XmlAtt := XmlAttribute.Create('currencyID', CurrencyCode);
                    //     AdditonalDocReferenceValue.Add(XmlAtt);
                    //     // Modify calculations to exclude vat from amount
                    //     if SalesInvoiceHeader."Prices Including VAT" then
                    //         AdditonalDocReferenceValue.Add(XmlText.Create(Format(((SalesInvoiceLine."Line Discount %" / 100) * (SalesInvoiceLine."Unit Price")) / ((1 + (SalesInvoiceLine."VAT %" / 100)))).Replace(',', '')))
                    //     else
                    //         AdditonalDocReferenceValue.Add(XmlText.Create(Format((SalesInvoiceLine."Line Discount %" / 100) * (SalesInvoiceLine."Unit Price")).Replace(',', '')));

                    //     AllowanceCharge.Add(AdditonalDocReferenceValue);
                    //     AdditonalDocReferenceValue := XmlElement.Create('BaseAmount', CbcNamespaceUri);
                    //     XmlAtt := XmlAttribute.Create('currencyID', CurrencyCode);
                    //     AdditonalDocReferenceValue.Add(XmlAtt);
                    //     // Modify calculations to exclude vat from amount
                    //     if SalesInvoiceHeader."Prices Including VAT" then
                    //         AdditonalDocReferenceValue.Add(XmlText.Create(Format((SalesInvoiceLine."Unit Price" / ((1 + SalesInvoiceLine."VAT %") / 100)) / ((1 + (SalesInvoiceLine."VAT %" / 100)))).Replace(',', '')))
                    //     else
                    //         AdditonalDocReferenceValue.Add(XmlText.Create(Format(SalesInvoiceLine."Unit Price" / ((1 + SalesInvoiceLine."VAT %") / 100)).Replace(',', '')));
                    //     AllowanceCharge.Add(AdditonalDocReferenceValue);
                    //     Price.Add(AllowanceCharge);
                    // end;

                    InvoiceLine.Add(Price);
                    InvoiceElement.Add(InvoiceLine);
                end;
            until SalesInvoiceLine.Next() = 0;
        XmlDoc.Add(InvoiceElement);
        // XmlDoc.WriteTo(FileName);
        // FileName:=XmlDoc.;
        // TempBlob.CreateInStream(InStr, TextEncoding::UTF8);
        // FileName := 'debug.xml';
        // DownloadFromStream(InStr, 'Debug', '', '', FileName);
    end;

    // local procedure CalcLineTaxAmount(LineAmountExclVat:Decimal;VatPerc:Decimal) :Decimal
    // begin
    //     exit(Round(LineAmountExclVat * (VatPerc / 100), 0.01));
    // end;
    local procedure CalcLineTaxAmount(Vat: Decimal; LineAmountExclVat: Decimal): Decimal
    begin
        exit(Round(LineAmountExclVat * (Vat / 100), 0.01));
    end;

    // local procedure GetInvoiceLineAmountInclVat(var Rec: Record "Sales Invoice Line"): Decimal
    // var
    // begin
    //     // exit(Round(Round(Rec."Unit Price" / ((Rec."VAT %" / 100) + 1), 0.01) * Rec.Quantity, 0.01));
    //     exit(Rec."Amount Including VAT");
    // end;

    local procedure GetInvoiceLineAmountInclVat(LineAmountExclVat: Decimal; TaxAmount: Decimal): Decimal
    var
    begin
        // exit(Round(Round(Rec."Unit Price" / ((Rec."VAT %" / 100) + 1), 0.01) * Rec.Quantity, 0.01));
        exit(LineAmountExclVat + TaxAmount);
    end;

    local procedure GetInvoiceLineAmountExclVat(var Rec: Record "Sales Invoice Line"): Decimal
    var
    begin
        exit(Round(Round(Rec."Unit Price" / ((Rec."VAT %" / 100) + 1), 0.0001) * Rec.Quantity, 0.01));
        // exit(Round(Rec."Amount Including VAT"/((Rec."VAT %" / 100) + 1),0.01));
    end;

    local procedure GetCRMemoLineAmountInclVat(LineAmountExclVat: Decimal; TaxAmount: Decimal): Decimal
    var
    begin
        // exit(Round(Round(Rec."Unit Price" / ((Rec."VAT %" / 100) + 1), 0.01) * Rec.Quantity, 0.01));
        exit(LineAmountExclVat + TaxAmount);
    end;

    local procedure GetCRMemoLineAmountExclVat(var Rec: Record "Sales Cr.Memo Line"): Decimal
    var
    begin
        exit(Round(Round(Rec."Unit Price" / ((Rec."VAT %" / 100) + 1), 0.0001) * Rec.Quantity, 0.01));
        // exit(Round(Round(Rec."Unit Price" / ((Rec."VAT %" / 100) + 1), 0.01) * Rec.Quantity, 0.01));
        // exit(Rec.Amount);
    end;

    local procedure GetInvoiceCRMemoLineAmountExclVat(var Rec: Record "Sales Cr.Memo Line"): Decimal
    var
    begin
        exit(Round(Round(Rec."Unit Price" / ((Rec."VAT %" / 100) + 1), 0.01) * Rec.Quantity, 0.01));
    end;

    [TryFunction]
    internal procedure SalesCreditMemoXML(SalesCrMemoHeader: Record "Sales Cr.Memo Header"; var XmlDoc: XmlDocument; var InvoiceId: Text; var IsB2B: Boolean)
    var
        SalesCrMemoLine: Record "Sales Cr.Memo Line";
        VATPostingSetup: Record "VAT Posting Setup";
        TaxableAmount, TaxAmount, TotalAmountExVAT, TotalTaxAmount, VATPercentage : Decimal;
        LineCount: Integer;
        CurrencyCode, ExemptedTaxCode, ExtemptedTax, OptionalTax, ZeroTax, ZeroTaxCode : Text;
        ExemptionReason, ValidationMsg, ZeroTaxDescription : Text;
        XmlAtt: XmlAttribute;
        Declaration: XmlDeclaration;
        AdditonalDocReferenceValue, InvoiceElement, InvoiceHeaderElement : XmlElement;
        AllowanceCharge, HeaderTaxTotal, InvoiceDocumentReference, InvoiceLine, Item, Price : xmlElement;
        PostalAddress, TaxCategory, TaxScheme, TaxTotal : xmlElement;
        TestDate: Text;
        LineAmountExclVat: Decimal;
        LineAmountInclVat: Decimal;
        LineTaxAmount: Decimal;
    begin
        ValidateCompanyInformation();
        if Customer.Get(SalesCrMemoHeader."Sell-to Customer No.") then ValidateCustomerInfo();
        if ValidateSupplierAddressError(ValidationMsg) then Error(ValidationMsg);
        Clear(SalesCrMemoLine);
        Clear(TaxableAmount);
        SalesCrMemoLine.SetRange("Document No.", SalesCrMemoHeader."No.");
        if SalesCrMemoLine.FindSet() then
            repeat
                if SalesCrMemoLine.Type <> SalesCrMemoLine.Type::" " then begin
                    LineCount += 1;
                    VATPercentage := SalesCrMemoLine."VAT %";

                    // Recalculate line amount and tax amount +
                    LineAmountExclVat := GetCRMemoLineAmountExclVat(SalesCrMemoLine);
                    LineTaxAmount := CalcLineTaxAmount(SalesCrMemoLine."VAT %", LineAmountExclVat);
                    LineAmountInclVat := GetCRMemoLineAmountInclVat(LineAmountExclVat,LineTaxAmount);
                    // LineTaxAmount := Round(LineAmountExclVat * (SalesCrMemoLine."VAT %" / 100), 0.01);
                    // LineTaxAmount := LineAmountInclVat - LineAmountExclVat;
                    // LineTaxAmount := Round(LineAmountExclVat * (SalesCrMemoLine."VAT %" / 100), 0.01);
                    // Recalculate line amount and tax amount -

                    // TaxAmount := SalesCrMemoLine.GetLineAmountInclVAT() - SalesCrMemoLine.GetLineAmountExclVAT();
                    // TotalTaxAmount += TaxAmount;
                    // TotalAmountExVAT += SalesCrMemoLine.GetLineAmountExclVAT();

                    TotalTaxAmount += LineTaxAmount;
                    TotalAmountExVAT += Round(LineAmountExclVat, 0.01);

                    VATPostingSetup.SetRange("VAT Bus. Posting Group", SalesCrMemoLine."VAT Bus. Posting Group");
                    VATPostingSetup.SetRange("VAT Prod. Posting Group", SalesCrMemoLine."VAT Prod. Posting Group");
                    VATPostingSetup.SetRange("VAT %", SalesCrMemoLine."VAT %");
                    if VATPostingSetup.FindFirst() then
                        case VATPostingSetup."Tax Category" of
                            'Z':
                                begin
                                    ZeroTax := 'Z';
                                    ZeroTaxCode := VATPostingSetup."ZATCA VAT Exemption Code";
                                    ZeroTaxDescription := VATPostingSetup."ZATCA VAT Description";
                                end;
                            'E':
                                begin
                                    ExtemptedTax := 'E';
                                    ExemptedTaxCode := VATPostingSetup."ZATCA VAT Exemption Code";
                                    ExemptionReason := VATPostingSetup."ZATCA VAT Description";
                                end;
                            'O':
                                OptionalTax := 'O';
                        end;
                end;
            until SalesCrMemoLine.Next() = 0;
        XmlDoc := XmlDocument.Create();
        Declaration := XmlDeclaration.Create('1.0', 'utf-8', 'no');
        XmlDoc.SetDeclaration(Declaration);
        CacNamespacePrefix := 'cac';
        ExtNamespacePrefix := 'ext';
        ExtNamespaceUri := 'urn:oasis:names:specification:ubl:schema:xsd:CommonExtensionComponents-2';
        CacNamespaceUri := 'urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2';
        CbcNameSpacePrefix := 'cbc';
        CbcNamespaceUri := 'urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2';
        NamespaceUri := 'urn:oasis:names:specification:ubl:schema:xsd:Invoice-2';
        InvoiceElement := XmlElement.Create('Invoice', NamespaceUri);
        XmlAtt := XmlAttribute.CreateNamespaceDeclaration(CacNamespacePrefix, CacNamespaceUri);
        InvoiceElement.Add(XmlAtt);
        XmlAtt := XmlAttribute.CreateNamespaceDeclaration(CbcNameSpacePrefix, CbcNamespaceUri);
        InvoiceElement.Add(XmlAtt);
        XmlAtt := XmlAttribute.CreateNamespaceDeclaration(ExtNamespacePrefix, ExtNamespaceUri);
        InvoiceElement.Add(XmlAtt);
        InvoiceHeaderElement := XmlElement.Create('ProfileID', CbcNamespaceUri);
        InvoiceHeaderElement.Add(XmlText.Create('reporting:1.0'));
        InvoiceElement.Add(InvoiceHeaderElement);
        InvoiceHeaderElement := XmlElement.Create('ID', CbcNamespaceUri);
        InvoiceHeaderElement.Add(XmlText.Create(SalesCrMemoHeader."No."));
        InvoiceElement.Add(InvoiceHeaderElement);
        InvoiceHeaderElement := XmlElement.Create('UUID', CbcNamespaceUri);
        InvoiceId := CreateGuid();
        InvoiceId := InvoiceId.Replace('{', '').Replace('}', '');
        InvoiceHeaderElement.Add(XmlText.Create(InvoiceId));
        InvoiceElement.Add(InvoiceHeaderElement);
        InvoiceHeaderElement := XmlElement.Create('IssueDate', CbcNamespaceUri);
        TestDate := Format(SalesCrMemoHeader."Posting Date", 0, 9);
        InvoiceHeaderElement.Add(XmlText.Create(Format(SalesCrMemoHeader."Posting Date", 0, 9)));
        InvoiceElement.Add(InvoiceHeaderElement);
        InvoiceHeaderElement := XmlElement.Create('IssueTime', CbcNamespaceUri);
        InvoiceHeaderElement.Add(XmlText.Create(FormatTime()));
        InvoiceElement.Add(InvoiceHeaderElement);
        InvoiceHeaderElement := XmlElement.Create('InvoiceTypeCode', CbcNamespaceUri);
        if Customer."Is B2B" then
            XmlAtt := XmlAttribute.Create('name', '0100000')
        else if Customer."Is B2C" then XmlAtt := XmlAttribute.Create('name', '0200000');
        IsB2B := customer."Is B2B";
        InvoiceHeaderElement.Add(XmlAtt);
        InvoiceHeaderElement.Add(XmlText.Create('381'));
        InvoiceElement.Add(InvoiceHeaderElement);
        InvoiceHeaderElement := XmlElement.Create('DocumentCurrencyCode', CbcNamespaceUri);
        if SalesCrMemoHeader."Currency Code" <> '' then
            CurrencyCode := SalesCrMemoHeader."Currency Code"
        else
            CurrencyCode := 'SAR';
        InvoiceHeaderElement.Add(XmlText.Create(CurrencyCode));
        InvoiceElement.Add(InvoiceHeaderElement);
        InvoiceHeaderElement := XmlElement.Create('TaxCurrencyCode', CbcNamespaceUri);
        InvoiceHeaderElement.Add(XmlText.Create('SAR'));
        InvoiceElement.Add(InvoiceHeaderElement);
        //Billing Reference
        InvoiceHeaderElement := XmlElement.Create('BillingReference', CacNamespaceUri);
        InvoiceDocumentReference := XmlElement.Create('InvoiceDocumentReference', CacNamespaceUri);
        AdditonalDocReferenceValue := XmlElement.Create('ID', CbcNamespaceUri);
        SalesCrMemoHeader.TestField("Applies-to Doc. No.");
        AdditonalDocReferenceValue.Add(XmlText.Create(SalesCrMemoHeader."Applies-to Doc. No."));
        InvoiceDocumentReference.Add(AdditonalDocReferenceValue);
        InvoiceHeaderElement.Add(InvoiceDocumentReference);
        InvoiceElement.Add(InvoiceHeaderElement);
        //ICV
        InvoiceElement.Add(CreateICV());
        //PIH
        InvoiceElement.Add(CreatePIH());
        //Supplier Party
        InvoiceElement.Add(CreateAccountingSupplierParty());
        //Customer Party
        InvoiceElement.Add(CreateAccountingCustomerParty());
        //Delivery
        PostalAddress := XmlElement.Create('Delivery', CacNamespaceUri);
        AdditonalDocReferenceValue := XmlElement.Create('ActualDeliveryDate', CbcNamespaceUri);
        AdditonalDocReferenceValue.Add(XmlText.Create(Format(SalesCrMemoHeader."Shipment Date", 0, 9)));
        PostalAddress.Add(AdditonalDocReferenceValue);
        InvoiceElement.Add(PostalAddress);
        //PaymentMeans
        PostalAddress := XmlElement.Create('PaymentMeans', CacNamespaceUri);
        //SetPaymentMethodCode
        AdditonalDocReferenceValue := XmlElement.Create('PaymentMeansCode', CbcNamespaceUri);
        AdditonalDocReferenceValue.Add(XmlText.Create(SetPaymentMethodCode((SalesCrMemoHeader."Payment Method Code"))));
        PostalAddress.Add(AdditonalDocReferenceValue);
        //InstructionNote
        AdditonalDocReferenceValue := XmlElement.Create('InstructionNote', CbcNamespaceUri);
        ZATCADeviceOnboarding.Get();
        AdditonalDocReferenceValue.Add(XmlText.Create(ZATCADeviceOnboarding."Instruction Note"));
        PostalAddress.Add(AdditonalDocReferenceValue);
        InvoiceElement.Add(PostalAddress);
        // Allowance Charge
        if SalesCrMemoHeader."Invoice Discount Amount" > 0 then begin
            AllowanceCharge := XmlElement.Create('AllowanceCharge', CacNamespaceUri);
            AdditonalDocReferenceValue := XmlElement.Create('ChargeIndicator', CbcNamespaceUri);
            AdditonalDocReferenceValue.Add(XmlText.Create('true'));
            AllowanceCharge.Add(AdditonalDocReferenceValue);
            AdditonalDocReferenceValue := XmlElement.Create('AllowanceChargeReason', CbcNamespaceUri);
            AdditonalDocReferenceValue.Add(XmlText.Create('discount'));
            AllowanceCharge.Add(AdditonalDocReferenceValue);
            AdditonalDocReferenceValue := XmlElement.Create('Amount', CbcNamespaceUri);
            XmlAtt := XmlAttribute.Create('currencyID', CurrencyCode);
            AdditonalDocReferenceValue.Add(XmlAtt);
            AdditonalDocReferenceValue.Add(XmlText.Create(Format(SalesCrMemoHeader."Invoice Discount Amount").Replace(',', '')));
            AllowanceCharge.Add(AdditonalDocReferenceValue);
            TaxCategory := XmlElement.Create('TaxCategory', CacNamespaceUri);
            AdditonalDocReferenceValue := XmlElement.Create('ID', CbcNamespaceUri);
            AdditonalDocReferenceValue.Add(XmlText.Create('S'));
            TaxCategory.Add(AdditonalDocReferenceValue);
            AdditonalDocReferenceValue := XmlElement.Create('Percent', CbcNamespaceUri);
            AdditonalDocReferenceValue.Add(XmlText.Create(Format(VATPercentage).Replace(',', '')));
            TaxCategory.Add(AdditonalDocReferenceValue);
            TaxScheme := XmlElement.Create('TaxScheme', CacNamespaceUri);
            AdditonalDocReferenceValue := XmlElement.Create('ID', CbcNamespaceUri);
            AdditonalDocReferenceValue.Add(XmlText.Create('VAT'));
            TaxScheme.Add(AdditonalDocReferenceValue);
            TaxCategory.Add(TaxScheme);
            AllowanceCharge.Add(TaxCategory);
            InvoiceElement.Add(AllowanceCharge);
        end;
        // TaxTotal
        TaxTotal := XmlElement.Create('TaxTotal', CacNamespaceUri);
        AdditonalDocReferenceValue := XmlElement.Create('TaxAmount', CbcNamespaceUri);
        XmlAtt := XmlAttribute.Create('currencyID', CurrencyCode);
        AdditonalDocReferenceValue.Add(XmlAtt);
        AdditonalDocReferenceValue.Add(XmlText.Create(Format(TotalTaxAmount).Replace(',', '')));
        TaxTotal.Add(AdditonalDocReferenceValue);
        InvoiceElement.Add(TaxTotal);
        // Tax Total with Sub Totals
        HeaderTaxTotal := XmlElement.Create('TaxTotal', CacNamespaceUri);
        AdditonalDocReferenceValue := XmlElement.Create('TaxAmount', CbcNamespaceUri);
        XmlAtt := XmlAttribute.Create('currencyID', CurrencyCode);
        AdditonalDocReferenceValue.Add(XmlAtt);
        AdditonalDocReferenceValue.Add(XmlText.Create(Format(TotalTaxAmount).Replace(',', '')));
        HeaderTaxTotal.Add(AdditonalDocReferenceValue);
        if TotalTaxAmount > 0 then HeaderTaxTotal.Add(HeaderTaxSubTotalXml('S', CurrencyCode, TotalAmountExVAT, TotalTaxAmount, '', VATPercentage, ''));
        if ZeroTax = 'Z' then HeaderTaxTotal.Add(HeaderTaxSubTotalXml(ZeroTax, CurrencyCode, TotalAmountExVAT, 0.00, ZeroTaxCode, 0.00, ZeroTaxDescription));
        if ExtemptedTax = 'E' then HeaderTaxTotal.Add(HeaderTaxSubTotalXml(ExtemptedTax, CurrencyCode, TotalAmountExVAT, 0.00, ExemptedTaxCode, 0.00, ExemptionReason));
        if OptionalTax = 'O' then HeaderTaxTotal.Add(HeaderTaxSubTotalXml(OptionalTax, CurrencyCode, TotalAmountExVAT, 0.00, '', 0.00, ''));
        InvoiceElement.Add(HeaderTaxTotal);
        // Legal Monetory Total
        // InvoiceElement.Add(CreateLegalMonetoryTotal(TotalAmountExVAT, TotalTaxAmount, CurrencyCode, SalesInvoiceHeader."Invoice Discount Amount"));
        InvoiceElement.Add(CreateLegalMonetoryTotal(TotalAmountExVAT, TotalTaxAmount, CurrencyCode, SalesCrMemoHeader."Invoice Discount Amount"));
        // Invoice Lines
        Clear(SalesCrMemoLine);
        Clear(TaxableAmount);
        LineCount := 0;
        HeaderTaxTotal := XmlElement.Create('TaxTotal', CacNamespaceUri);
        SalesCrMemoLine.SetRange("Document No.", SalesCrMemoHeader."No.");
        if SalesCrMemoLine.FindSet() then
            repeat
                if SalesCrMemoLine.Type <> SalesCrMemoLine.Type::" " then begin
                    LineCount += 1;
                    InvoiceLine := XmlElement.Create('InvoiceLine', CacNamespaceUri);
                    AdditonalDocReferenceValue := XmlElement.Create('ID', CbcNamespaceUri);
                    AdditonalDocReferenceValue.Add(XmlText.Create(Format(LineCount)));
                    InvoiceLine.Add(AdditonalDocReferenceValue);
                    AdditonalDocReferenceValue := XmlElement.Create('InvoicedQuantity', CbcNamespaceUri);
                    XmlAtt := XmlAttribute.Create('unitCode', SalesCrMemoLine."Unit of Measure Code");
                    AdditonalDocReferenceValue.Add(XmlAtt);
                    AdditonalDocReferenceValue.Add(XmlText.Create(Format(SalesCrMemoLine.Quantity).Replace(',', '')));
                    InvoiceLine.Add(AdditonalDocReferenceValue);
                    AdditonalDocReferenceValue := XmlElement.Create('LineExtensionAmount', CbcNamespaceUri);
                    XmlAtt := XmlAttribute.Create('currencyID', CurrencyCode);

                    // Recalculate line amount and tax amount +
                    LineAmountExclVat := GetCRMemoLineAmountExclVat(SalesCrMemoLine);
                    LineTaxAmount := CalcLineTaxAmount(SalesCrMemoLine."VAT %", LineAmountExclVat);
                    LineAmountInclVat := GetCRMemoLineAmountInclVat(LineAmountExclVat,LineTaxAmount);
                    // LineTaxAmount := Round(LineAmountExclVat * (SalesCrMemoLine."VAT %" / 100), 0.01);
                    // Recalculate line amount and tax amount -

                    AdditonalDocReferenceValue.Add(XmlAtt);
                    AdditonalDocReferenceValue.Add(XmlText.Create(Format(LineAmountExclVat).Replace(',', '')));
                    // AdditonalDocReferenceValue.Add(XmlText.Create(Format(SalesCrMemoLine.GetLineAmountExclVAT()).Replace(',', '')));
                    InvoiceLine.Add(AdditonalDocReferenceValue);
                    TaxTotal := XmlElement.Create('TaxTotal', CacNamespaceUri);
                    AdditonalDocReferenceValue := XmlElement.Create('TaxAmount', CbcNamespaceUri);
                    XmlAtt := XmlAttribute.Create('currencyID', CurrencyCode);
                    AdditonalDocReferenceValue.Add(XmlAtt);
                    AdditonalDocReferenceValue.Add(XmlText.Create(Format(LineTaxAmount).Replace(',', '')));
                    // AdditonalDocReferenceValue.Add(XmlText.Create(Format(SalesCrMemoLine.GetLineAmountInclVAT() - SalesCrMemoLine.GetLineAmountExclVAT()).Replace(',', '')));
                    TaxTotal.Add(AdditonalDocReferenceValue);
                    AdditonalDocReferenceValue := XmlElement.Create('RoundingAmount', CbcNamespaceUri);
                    XmlAtt := XmlAttribute.Create('currencyID', CurrencyCode);
                    AdditonalDocReferenceValue.Add(XmlAtt);
                    AdditonalDocReferenceValue.Add(XmlText.Create(Format(LineAmountInclVat).Replace(',', '')));
                    // AdditonalDocReferenceValue.Add(XmlText.Create(Format(SalesCrMemoLine.GetLineAmountInclVAT()).Replace(',', '')));
                    TaxTotal.Add(AdditonalDocReferenceValue);
                    InvoiceLine.Add(TaxTotal);
                    Item := XmlElement.Create('Item', CacNamespaceUri);
                    AdditonalDocReferenceValue := XmlElement.Create('Name', CbcNamespaceUri);
                    AdditonalDocReferenceValue.Add(XmlText.Create(SalesCrMemoLine.Description));
                    Item.Add(AdditonalDocReferenceValue);
                    TaxCategory := XmlElement.Create('ClassifiedTaxCategory', CacNamespaceUri);
                    VATPostingSetup.SetRange("VAT Bus. Posting Group", SalesCrMemoLine."VAT Bus. Posting Group");
                    VATPostingSetup.SetRange("VAT Prod. Posting Group", SalesCrMemoLine."VAT Prod. Posting Group");
                    VATPostingSetup.SetRange("VAT %", SalesCrMemoLine."VAT %");
                    if VATPostingSetup.FindFirst() then begin
                        AdditonalDocReferenceValue := XmlElement.Create('ID', CbcNamespaceUri);
                        AdditonalDocReferenceValue.Add(XmlText.Create(VATPostingSetup."Tax Category"));
                        TaxCategory.Add(AdditonalDocReferenceValue);
                        AdditonalDocReferenceValue := XmlElement.Create('Percent', CbcNamespaceUri);
                        AdditonalDocReferenceValue.Add(XmlText.Create(Format(SalesCrMemoLine."VAT %").Replace(',', '')));
                        TaxCategory.Add(AdditonalDocReferenceValue);
                        TaxScheme := XmlElement.Create('TaxScheme', CacNamespaceUri);
                        AdditonalDocReferenceValue := XmlElement.Create('ID', CbcNamespaceUri);
                        AdditonalDocReferenceValue.Add(XmlText.Create('VAT'));
                        TaxScheme.Add(AdditonalDocReferenceValue);
                        TaxCategory.Add(TaxScheme);
                    end;
                    Item.Add(TaxCategory);
                    //
                    InvoiceLine.Add(Item);
                    Price := XmlElement.Create('Price', CacNamespaceUri);
                    AdditonalDocReferenceValue := XmlElement.Create('PriceAmount', CbcNamespaceUri);
                    XmlAtt := XmlAttribute.Create('currencyID', CurrencyCode);
                    AdditonalDocReferenceValue.Add(XmlAtt);
                    // if SalesCrMemoHeader."Prices Including VAT" then
                    AdditonalDocReferenceValue.Add(XmlText.Create(Format(Round(LineAmountExclVat / SalesCrMemoLine.Quantity, 0.0001)).Replace(',', '')));

                    // AdditonalDocReferenceValue.Add(XmlText.Create(Format(Round((SalesCrMemoLine."Unit Price" - ((SalesCrMemoLine."Line Discount %" / 100) * SalesCrMemoLine."Unit Price")) / ((1 + (SalesCrMemoLine."VAT %" / 100))), 0.01)).Replace(',', '')));
                    // AdditonalDocReferenceValue.Add(XmlText.Create(Format((SalesCrMemoLine."Unit Price" - ((SalesCrMemoLine."Line Discount %" / 100) * SalesCrMemoLine."Unit Price")) / ((1 + (SalesCrMemoLine."VAT %" / 100)))).Replace(',', '')))
                    // else
                    //     AdditonalDocReferenceValue.Add(XmlText.Create(Format(Round(SalesCrMemoLine."Unit Price" - ((SalesCrMemoLine."Line Discount %" / 100) * SalesCrMemoLine."Unit Price"), 0.01)).Replace(',', '')));
                    // AdditonalDocReferenceValue.Add(XmlText.Create(Format(SalesCrMemoLine."Unit Price" - ((SalesCrMemoLine."Line Discount %" / 100) * SalesCrMemoLine."Unit Price")).Replace(',', '')));

                    // AdditonalDocReferenceValue.Add(XmlText.Create(Format(SalesCrMemoLine."Unit Price" - (SalesCrMemoLine."Line Discount %" / 100) * SalesCrMemoLine."Unit Price").Replace(',', '')));
                    Price.Add(AdditonalDocReferenceValue);

                    // Removed by customer's request, discount is not required in the XML
                    // Allowance Charge
                    // if SalesCrMemoLine."Line Discount Amount" > 0 then begin
                    //     AllowanceCharge := XmlElement.Create('AllowanceCharge', CacNamespaceUri);
                    //     AdditonalDocReferenceValue := XmlElement.Create('ChargeIndicator', CbcNamespaceUri);
                    //     AdditonalDocReferenceValue.Add(XmlText.Create('true'));
                    //     AllowanceCharge.Add(AdditonalDocReferenceValue);
                    //     AdditonalDocReferenceValue := XmlElement.Create('AllowanceChargeReason', CbcNamespaceUri);
                    //     AdditonalDocReferenceValue.Add(XmlText.Create('discount'));
                    //     AllowanceCharge.Add(AdditonalDocReferenceValue);
                    //     AdditonalDocReferenceValue := XmlElement.Create('Amount', CbcNamespaceUri);
                    //     XmlAtt := XmlAttribute.Create('currencyID', CurrencyCode);
                    //     AdditonalDocReferenceValue.Add(XmlAtt);
                    //     AdditonalDocReferenceValue.Add(XmlText.Create(Format((SalesCrMemoLine."Line Discount %" / 100) * SalesCrMemoLine."Unit Price").Replace(',', '')));
                    //     AllowanceCharge.Add(AdditonalDocReferenceValue);
                    //     AdditonalDocReferenceValue := XmlElement.Create('BaseAmount', CbcNamespaceUri);
                    //     XmlAtt := XmlAttribute.Create('currencyID', CurrencyCode);
                    //     AdditonalDocReferenceValue.Add(XmlAtt);
                    //     AdditonalDocReferenceValue.Add(XmlText.Create(Format(SalesCrMemoLine."Unit Price").Replace(',', '')));
                    //     AllowanceCharge.Add(AdditonalDocReferenceValue);
                    //     Price.Add(AllowanceCharge);
                    // end;
                    InvoiceLine.Add(Price);
                    InvoiceElement.Add(InvoiceLine);
                end;
            until SalesCrMemoLine.Next() = 0;
        XmlDoc.Add(InvoiceElement);

    end;

    local procedure CreateLegalMonetoryTotal(TotalAmountExVAT: Decimal; TotalTaxAmount: Decimal; CurrencyCode: Text; AllowanceTotalAmount: Decimal): XmlElement
    var
        XmlAtt: XmlAttribute;
        AdditonalDocReferenceValue: XmlElement;
        LegalMonetaryTotal: xmlElement;
    begin
        LegalMonetaryTotal := XmlElement.Create('LegalMonetaryTotal', CacNamespaceUri);
        AdditonalDocReferenceValue := XmlElement.Create('LineExtensionAmount', CbcNamespaceUri);
        XmlAtt := XmlAttribute.Create('currencyID', CurrencyCode);

        AdditonalDocReferenceValue.Add(XmlAtt);
        AdditonalDocReferenceValue.Add(XmlText.Create(Format(TotalAmountExVAT).Replace(',', '')));
        LegalMonetaryTotal.Add(AdditonalDocReferenceValue);
        AdditonalDocReferenceValue := XmlElement.Create('TaxExclusiveAmount', CbcNamespaceUri);
        XmlAtt := XmlAttribute.Create('currencyID', CurrencyCode);
        AdditonalDocReferenceValue.Add(XmlAtt);
        AdditonalDocReferenceValue.Add(XmlText.Create(Format(TotalAmountExVAT).Replace(',', '')));
        LegalMonetaryTotal.Add(AdditonalDocReferenceValue);
        AdditonalDocReferenceValue := XmlElement.Create('TaxInclusiveAmount', CbcNamespaceUri);
        XmlAtt := XmlAttribute.Create('currencyID', CurrencyCode);
        AdditonalDocReferenceValue.Add(XmlAtt);
        AdditonalDocReferenceValue.Add(XmlText.Create(Format(TotalAmountExVAT + TotalTaxAmount).Replace(',', '')));
        LegalMonetaryTotal.Add(AdditonalDocReferenceValue);
        AdditonalDocReferenceValue := XmlElement.Create('AllowanceTotalAmount', CbcNamespaceUri);
        XmlAtt := XmlAttribute.Create('currencyID', CurrencyCode);
        AdditonalDocReferenceValue.Add(XmlAtt);
        AdditonalDocReferenceValue.Add(XmlText.Create(Format(AllowanceTotalAmount).Replace(',', '')));
        LegalMonetaryTotal.Add(AdditonalDocReferenceValue);
        AdditonalDocReferenceValue := XmlElement.Create('PrepaidAmount', CbcNamespaceUri);
        XmlAtt := XmlAttribute.Create('currencyID', CurrencyCode);
        AdditonalDocReferenceValue.Add(XmlAtt);
        AdditonalDocReferenceValue.Add(XmlText.Create('0'));
        LegalMonetaryTotal.Add(AdditonalDocReferenceValue);
        AdditonalDocReferenceValue := XmlElement.Create('PayableRoundingAmount', CbcNamespaceUri);
        XmlAtt := XmlAttribute.Create('currencyID', CurrencyCode);
        AdditonalDocReferenceValue.Add(XmlAtt);
        AdditonalDocReferenceValue.Add(XmlText.Create('0'));
        LegalMonetaryTotal.Add(AdditonalDocReferenceValue);
        AdditonalDocReferenceValue := XmlElement.Create('PayableAmount', CbcNamespaceUri);
        XmlAtt := XmlAttribute.Create('currencyID', CurrencyCode);
        AdditonalDocReferenceValue.Add(XmlAtt);
        AdditonalDocReferenceValue.Add(XmlText.Create(Format(TotalAmountExVAT + TotalTaxAmount).Replace(',', '')));
        LegalMonetaryTotal.Add(AdditonalDocReferenceValue);
        exit(LegalMonetaryTotal);
    end;

    local procedure HeaderTaxSubTotalXml(TaxtType: Text; CurrencyCode: Text; TotalAmountExVAT: Decimal; TotalTaxAmount: Decimal; ExemptionResonCode: Text; VATPercentage: Decimal; ExemptionReason: Text): XmlElement
    var
        XmlAtt: XmlAttribute;
        AdditonalDocReferenceValue, TaxCategory, TaxScheme, TaxSubtotal : xmlElement;
    begin
        TaxSubtotal := XmlElement.Create('TaxSubtotal', CacNamespaceUri);
        AdditonalDocReferenceValue := XmlElement.Create('TaxableAmount', CbcNamespaceUri);
        XmlAtt := XmlAttribute.Create('currencyID', CurrencyCode);
        AdditonalDocReferenceValue.Add(XmlAtt);
        AdditonalDocReferenceValue.Add(XmlText.Create(Format(TotalAmountExVAT).Replace(',', '')));
        TaxSubtotal.Add(AdditonalDocReferenceValue);
        AdditonalDocReferenceValue := XmlElement.Create('TaxAmount', CbcNamespaceUri);
        XmlAtt := XmlAttribute.Create('currencyID', CurrencyCode);
        AdditonalDocReferenceValue.Add(XmlAtt);
        AdditonalDocReferenceValue.Add(XmlText.Create(Format(TotalTaxAmount).Replace(',', '')));
        TaxSubtotal.Add(AdditonalDocReferenceValue);
        TaxCategory := XmlElement.Create('TaxCategory', CacNamespaceUri);
        AdditonalDocReferenceValue := XmlElement.Create('ID', CbcNamespaceUri);
        AdditonalDocReferenceValue.Add(XmlText.Create(TaxtType));
        TaxCategory.Add(AdditonalDocReferenceValue);
        AdditonalDocReferenceValue := XmlElement.Create('Percent', CbcNamespaceUri);
        AdditonalDocReferenceValue.Add(XmlText.Create(Format(VATPercentage).Replace(',', '')));
        TaxCategory.Add(AdditonalDocReferenceValue);
        if (TaxtType = 'Z') or (TaxtType = 'E') then begin
            AdditonalDocReferenceValue := XmlElement.Create('TaxExemptionReasonCode', CbcNamespaceUri);
            AdditonalDocReferenceValue.Add(XmlText.Create(ExemptionResonCode));
            TaxCategory.Add(AdditonalDocReferenceValue);
            AdditonalDocReferenceValue := XmlElement.Create('TaxExemptionReason', CbcNamespaceUri);
            AdditonalDocReferenceValue.Add(XmlText.Create(Format(ExemptionReason)));
            TaxCategory.Add(AdditonalDocReferenceValue);
        end;
        TaxScheme := XmlElement.Create('TaxScheme', CacNamespaceUri);
        AdditonalDocReferenceValue := XmlElement.Create('ID', CbcNamespaceUri);
        AdditonalDocReferenceValue.Add(XmlText.Create('VAT'));
        TaxScheme.Add(AdditonalDocReferenceValue);
        TaxCategory.Add(TaxScheme);
        TaxSubtotal.Add(TaxCategory);
        exit(TaxSubtotal);
    end;

    local procedure FormatTime(): Text;
    var
        EHours, EMinutes : integer;
        TimeArray: list of [Text];
        FormattedTime, Hours, Minutes, Seconds, Time : Text;
    begin
        EHours := 0;
        Eminutes := 0;
        Time := Format(System.Time, 0, '<Hours24,2>:<Minutes,2>:<Seconds,2>');
        TimeArray := Time.Split(':');
        Hours := TimeArray.Get(1).Replace(' ', '');
        Minutes := TimeArray.Get(2).Replace(' ', '');
        evaluate(EMinutes, Minutes);

        if (EMinutes >= 0) or (EMinutes <= 5) then begin
            evaluate(ehours, Hours);
            Ehours := Ehours - 1;
            Hours := Format(EHours);
        end;
        EMinutes := 55;
        EMinutes := 60 - EMinutes;
        Minutes := Format(eminutes);
        // if EMinutes < 10 then
        //     Minutes := '0' + Minutes;
        Seconds := TimeArray.Get(3).Replace(' ', '');
        if StrLen(Hours) = 1 then Hours := '0' + Hours;
        if StrLen(Minutes) = 1 then Minutes := '0' + Minutes;
        FormattedTime := Hours + ':' + Minutes + ':' + Seconds + 'Z';
        exit(FormattedTime);
    end;

    var
        CompanyInformation: Record "Company Information";
        Customer: Record Customer;
        ZATCADeviceOnboarding: Record "ZATCA Device Onboarding";
        EnvironmentInformation: Codeunit "Environment Information";
        CacNamespacePrefix, CacNamespaceUri, CbcNameSpacePrefix, CbcNamespaceUri, ExtNamespacePrefix, ExtNamespaceUri, NamespaceUri : Text;
}
