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
                    Report.Run(60000, true, true, SalesInvHeader);
                end;
            }

        }
    }

    var
        QRCode: Text;
}
