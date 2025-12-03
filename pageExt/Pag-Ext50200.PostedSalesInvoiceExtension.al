pageextension 50200 PostedSalesInvoiceExtension extends "Posted Sales Invoice"
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
            group(Zatca)
            {
                Visible = DimIsMarda;
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
                    ZatcaEventMgt.SetLayoutByDim(Rec."Shortcut Dimension 2 Code");
                    Report.Run(50200, true, true, SalesInvHeader);
                end;
            }

        }
    }
   

    trigger OnAfterGetCurrRecord()
    begin
        DimIsMarda:=ZatcaEventMgt.DimIsMarda(Rec.RecordId);
    end;

    var
        QRCode: Text;
        GenLedSetup: Record "General Ledger Setup";
        ZatcaEventMgt: Codeunit "ZATCA Event Mgt";
        DimIsMarda: Boolean;
}
