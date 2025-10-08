codeunit 60102 "ZATCA Event Mgt"
{
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnAfterFinalizePostingOnBeforeCommit', '', true, true)]
    local procedure OnAfterFinalizePostingOnBeforeCommit(var SalesHeader: Record "Sales Header"; var SalesCrMemoHeader: Record "Sales Cr.Memo Header"; var SalesInvoiceHeader: Record "Sales Invoice Header"; var PreviewMode: Boolean; var ReturnReceiptHeader: Record "Return Receipt Header"; var SalesShipmentHeader: Record "Sales Shipment Header")
    var
        ZATCADeviceOnboarding: Record "ZATCA Device Onboarding";
        ZATCAAPIProcessing: Codeunit "ZATCA API Processing";
    begin
        if ZATCAActivationMgt.IsZATCAIntegrationModuleActive() then
            if not PreviewMode then
                if ZATCADeviceOnboarding.Get() and ZATCADeviceOnboarding."On Document Posting" then
                    if SalesHeader."Document Type" in [SalesHeader."Document Type"::Invoice, SalesHeader."Document Type"::Order] then
                        ZATCAAPIProcessing.SignAndSubmit(SalesInvoiceHeader, false)
                    else if SalesHeader."Document Type" = SalesHeader."Document Type"::"Credit Memo" then ZATCAAPIProcessing.SignAndSubmit(SalesCrMemoHeader, false)
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Invoice Header", 'OnBeforePrintRecords', '', true, true)]
    local procedure OnBeforePrintRecords(var SalesInvoiceHeader: Record "Sales Invoice Header")
    begin
        if ZATCAActivationMgt.IsZATCAIntegrationModuleActive() then if SalesInvoiceHeader.QRCode = '' then Error('Invoice is missing QR Code');
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Invoice Header", 'OnBeforeEmailRecords', '', true, true)]
    local procedure OnBeforeEmailRecords(var SalesInvoiceHeader: Record "Sales Invoice Header")
    begin
        if ZATCAActivationMgt.IsZATCAIntegrationModuleActive() then if SalesInvoiceHeader.QRCode = '' then Error('Invoice is missing QR Code');
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Invoice Header", 'OnBeforeDoPrintToDocumentAttachment', '', true, true)]
    local procedure OnBeforeDoPrintToDocumentAttachment(var SalesInvoiceHeader: Record "Sales Invoice Header")
    begin
        if ZATCAActivationMgt.IsZATCAIntegrationModuleActive() then if SalesInvoiceHeader.QRCode = '' then Error('Invoice is missing QR Code');
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Cr.Memo Header", 'OnBeforePrintRecords', '', true, true)]
    local procedure OnBeforePrintCreditMemoRecords(var SalesCrMemoHeader: Record "Sales Cr.Memo Header")
    begin
        if ZATCAActivationMgt.IsZATCAIntegrationModuleActive() then if SalesCrMemoHeader.QRCode = '' then Error('Invoice is missing QR Code');
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Cr.Memo Header", 'OnBeforeEmailRecords', '', true, true)]
    local procedure OnBeforeEmailCreditMemoRecords(var SalesCrMemoHeader: Record "Sales Cr.Memo Header")
    begin
        if ZATCAActivationMgt.IsZATCAIntegrationModuleActive() then if SalesCrMemoHeader.QRCode = '' then Error('Invoice is missing QR Code');
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Cr.Memo Header", 'OnBeforeDoPrintToDocumentAttachment', '', true, true)]
    local procedure OnBeforeDoPrintCreditMemoToDocumentAttachment(var SalesCrMemoHeader: Record "Sales Cr.Memo Header")
    begin
        if ZATCAActivationMgt.IsZATCAIntegrationModuleActive() then if SalesCrMemoHeader.QRCode = '' then Error('Invoice is missing QR Code');
    end;



    // CIS

    [EventSubscriber(ObjectType::Table, Database::"Report Selections", OnBeforePrintDocument, '', false, false)]
    local procedure OnBeforePrintDocument(TempReportSelections: Record "Report Selections" temporary; var RecVarToPrint: Variant)
    var
        DimensionValue: Record "Dimension Value";
        SalesInvHeader: Record "Sales Invoice Header";
        ReportLayoutRec: Record "Report Layout List";
        ReportLayoutSelection: Record "Report Layout Selection";
        RecRef: RecordRef;
    begin
        // Choose a layout depending on dimension, specified in General Ledger Setup
        GenLedSetup.Get();

        RecRef.GetTable(RecVarToPrint);
        if RecRef.Number = Database::"Sales Invoice Header" then begin
            SalesInvHeader := RecVarToPrint;
            if SalesInvHeader.Get(SalesInvHeader."No.") and DimensionValue.Get(GenLedSetup."Global Dimension 1 Code", SalesInvHeader."Shortcut Dimension 1 Code") and (ReportLayoutRec.Get(DimensionValue."Report layout", DimensionValue."Report Name", DimensionValue."Runtime Package ID")) then begin
                ReportLayoutSelection.SetTempLayoutSelectedName(ReportLayoutRec.Name);
            end;
        end;
    end;





    var
        ZATCAActivationMgt: Codeunit "ZATCA Activation Mgt.";
        GenLedSetup: Record "General Ledger Setup";
}
