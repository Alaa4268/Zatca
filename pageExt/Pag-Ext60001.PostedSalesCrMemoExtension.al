pageextension 60001 PostedSalesCrMemoExtension extends "Posted Sales Credit Memo"
{
    layout
    {
        addafter("Your Reference")
        {
            field("QR Code"; Rec."QR Code")
            {
                ApplicationArea = All;
                Visible = false;
            }
            
            field("B/L-MAWB#"; Rec."B/L-MAWB#") { ApplicationArea = All; }
            field("ZAT Bayan No."; Rec."ZAT Bayan No.") { ApplicationArea = All; }
            field("Zatca Consignee"; Rec."Zatca Consignee") { ApplicationArea = All; }
            field("Zatca ETD"; Rec."Zatca ETD") { ApplicationArea = All; }
            field("Zatca CNTE.#"; Rec."Zatca CNTE.#") { ApplicationArea = All; }
            field("Port L."; Rec."Port L.") { ApplicationArea = All; }
            field("Port D."; Rec."Port D.") { ApplicationArea = All; }
            field("Zatca Shippper"; Rec."Zatca Shippper") { ApplicationArea = All; }
            field(Commodity; Rec.Commodity) { ApplicationArea = All; }
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
                    L_SalesCrMemoHeader: Record "Sales Cr.Memo Header";
                begin
                    L_SalesCrMemoHeader := Rec;
                    CurrPage.SetSelectionFilter(L_SalesCrMemoHeader);
                    ToRecordID := L_SalesCrMemoHeader.RecordId;
                    QRCode := QRCodeGenerator.GenerateQRCode(ToRecordID);
                    currpage.Update();
                end;
            }
            action(PrintZatcaReport)
            {
                ApplicationArea = All;
                Promoted = true;
                PromotedCategory = Report;
                Caption = 'Print Zatca Sales Credit Memo';
                trigger OnAction()
                var
                    L_SalesCrMemoHeader: Record "Sales Cr.Memo Header";
                begin

                    L_SalesCrMemoHeader := Rec;
                    CurrPage.SetSelectionFilter(L_SalesCrMemoHeader);
                    L_SalesCrMemoHeader.SetRecFilter();
                    Report.Run(60001, true, true, L_SalesCrMemoHeader);
                end;
            }

        }
    }

    var
        QRCode: Text;
}
