pageextension 60000 PostedSalesInvoiceExtension extends "Posted Sales Invoice"
{
    layout
    {
        addafter(Closed)
        {
            field("QR Code"; Rec."QR Code")
            {
                ApplicationArea = All;
                Visible = false;
            }
        }
    }
    actions
    {
        addfirst(processing)
        {
            action(GenerateQRCode)
            {
                ApplicationArea = All;
                Promoted = true;
                PromotedCategory = Process;
                trigger OnAction()
                var
                    QRCodeGenerator: Codeunit "QR Code Generator1";
                    ToRecordID: RecordId;
                begin
                    SalesInvHeader := Rec;
                    CurrPage.SetSelectionFilter(SalesInvHeader);
                    ToRecordID := SalesInvHeader.RecordId;
                    QRCode := QRCodeGenerator.GenerateQRCode(ToRecordID);
                    currpage.Update();
                end;
            }
            action(PrintZatcaReport)
            {
                ApplicationArea = All;
                Promoted = true;
                PromotedCategory = Report;
                Caption = 'Print Zatca Sales Invoice';
                trigger OnAction()
                begin
                    SalesInvHeader := Rec;
                    CurrPage.SetSelectionFilter(SalesInvHeader);
                    SalesInvHeader.SetRecFilter();
                    SetLayoutByDim();
                    Report.Run(60000, true, true, SalesInvHeader);
                end;
            }

        }
    }
    local procedure SetLayoutByDim()
    var
        DimensionValue: Record "Dimension Value";
        SalesInvHeader: Record "Sales Invoice Header";
        ReportLayoutRec: Record "Report Layout List";
        ReportLayoutSelection: Record "Report Layout Selection";
        RecRef: RecordRef;
    begin
        // Choose a layout depending on dimension, specified in General Ledger Setup
        GenLedSetup.Get();
        if DimensionValue.Get(GenLedSetup."Global Dimension 1 Code", Rec."Shortcut Dimension 1 Code") then begin
            clear(ReportLayoutRec);
            ReportLayoutRec.SetFilter("Report ID", '=%1', DimensionValue."Report layout");
            ReportLayoutRec.SetFilter(Name, DimensionValue."Report Name");
            if ReportLayoutRec.FindFirst() then
                ReportLayoutSelection.SetTempLayoutSelectedName(ReportLayoutRec.Name);
        end;
    end;

    var
        QRCode: Text;
        GenLedSetup: Record "General Ledger Setup";
}
