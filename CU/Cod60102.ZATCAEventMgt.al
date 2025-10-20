codeunit 60102 "ZATCA Event Mgt"
{

    Permissions = tabledata "Sales Cr.Memo Header" = RIMD,
    tabledata "Sales Invoice Header" = RIMD;


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


    // Fill Shipment date in sales credit memo upon insert
    [EventSubscriber(ObjectType::Table, Database::"Sales Header", OnAfterInsertEvent, '', false, false)]
    local procedure OnAfterInsertSalesCrMemoHeaderEvent(var Rec: Record "Sales Header")
    begin
        if Rec."Document Type" = Rec."Document Type"::"Credit Memo" then begin
            Rec.Validate("Shipment Date", Today);
            Rec.Modify();
        end;
    end;
    // Fill Shipment date in sales credit memo upon Modifying posting date  
    [EventSubscriber(ObjectType::Table, Database::"Sales Header", OnAfterValidateEvent, "Posting Date", false, false)]
    local procedure OnAfterValidatePostingDateEventInSalesCrMemoHeader(var Rec: Record "Sales Header")
    begin
        if Rec."Document Type" = Rec."Document Type"::"Credit Memo" then begin
            Rec.Validate("Shipment Date", Rec."Posting Date");
        end;
    end;

    // Fill Shipment date in sales credit memo upon filling applied to doc. no. field
    [EventSubscriber(ObjectType::Table, Database::"Sales Header", OnAfterAppliesToDocNoOnLookup, '', false, false)]
    local procedure OnAfterValidateAppliedToDocNoEventInSalesHeader(var SalesHeader: Record "Sales Header")
    var
        SalesInv: Record "Sales Header";
    begin
        if (SalesHeader."Document Type" = SalesHeader."Document Type"::"Credit Memo") and (SalesHeader."Applies-to Doc. Type" = SalesHeader."Applies-to Doc. Type"::Invoice) then
            if SalesInv.Get(SalesInv."Document Type"::Invoice, SalesHeader."Applies-to Doc. No.") then begin
                SalesHeader.Validate("Shipment Date", SalesInv."Posting Date");
                SalesHeader.Modify();
            end;
    end;


    [EventSubscriber(ObjectType::Page, Page::"Sales Invoice Subform", OnInsertRecordEvent, '', false, false)]
    local procedure OnInsertRecordEventInSalesInvoiceSubform(var Rec: Record "Sales Line")
    var
        SalesHeader: Record "Sales Header";
    begin
        SalesHeader.Get(Rec."Document Type"::Invoice, Rec."Document No.");
        SalesHeader.TestField("Shortcut Dimension 2 Code");
    end;


    [EventSubscriber(ObjectType::Table, Database::Customer, OnBeforeValidateEvent, "Is B2B", false, false)]
    local procedure OnBeforeValidateIsB2BEventInSalesInvoice(var Rec: Record Customer)
    var
        SalInv: Record "Sales Header";
        PostedSalInv: Record "Sales Invoice Header";
    begin
        clear(SalInv);
        SalInv.SetFilter("Sell-to Customer No.", '=%1', Rec."No.");
        clear(PostedSalInv);
        PostedSalInv.SetFilter("Sell-to Customer No.", '=%1', Rec."No.");
        if SalInv.FindFirst() or PostedSalInv.FindFirst() then
            Error('This field cannot be changed because a transaction has been made for this Customer!');
    end;

    [EventSubscriber(ObjectType::Table, Database::Customer, OnBeforeValidateEvent, "Is B2C", false, false)]
    local procedure OnBeforeValidateIsB2CEventInSalesInvoice(var Rec: Record Customer)
    var
        SalInv: Record "Sales Header";
        PostedSalInv: Record "Sales Invoice Header";
    begin
        clear(SalInv);
        SalInv.SetFilter("Sell-to Customer No.", '=%1', Rec."No.");
        clear(PostedSalInv);
        PostedSalInv.SetFilter("Sell-to Customer No.", '=%1', Rec."No.");
        if SalInv.FindFirst() or PostedSalInv.FindFirst() then
            Error('This field cannot be changed because a transaction has been made for this Customer!');
    end;



    // =======================================================================================================================================//
    // ============================================================  PROCEDURES  =============================================================//

    procedure SetLayoutByDim(DimensionCode: Code[20])
    var
        DimensionValue: Record "Dimension Value";
        ReportLayoutRec: Record "Report Layout List";
        ReportLayoutSelection: Record "Report Layout Selection";
    begin
        // Choose a layout depending on dimension, specified in General Ledger Setup
        GenLedSetup.Get();
        if DimensionValue.Get(GenLedSetup."Global Dimension 2 Code", DimensionCode) then begin
            clear(ReportLayoutRec);
            ReportLayoutRec.SetFilter("Report ID", '=%1', DimensionValue."Report layout");
            ReportLayoutRec.SetFilter(Name, DimensionValue."Report Name");
            if ReportLayoutRec.FindFirst() then
                ReportLayoutSelection.SetTempLayoutSelectedName(ReportLayoutRec.Name);
        end;
    end;

    var
        ZATCAActivationMgt: Codeunit "ZATCA Activation Mgt.";
        GenLedSetup: Record "General Ledger Setup";

}
