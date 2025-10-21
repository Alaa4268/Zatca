pageextension 60112 "SalesSales Credit Memo Ext" extends "Sales Credit Memo"
{
    layout
    {
        moveafter("Sell-to Customer Name"; "Shortcut Dimension 2 Code")

        addlast(General)
        {
            group(Zatca)
            {
                Visible = DimIsMarda;
                field("Zat Cr No."; Rec."Zat Cr No.") { ApplicationArea = All; }
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

    trigger OnAfterGetCurrRecord()
    begin
        DimIsMarda := ZatcaEventMgt.DimIsMarda(Rec.RecordId);
    end;


    var
        ZatcaEventMgt: Codeunit "ZATCA Event Mgt";
        DimIsMarda: Boolean;

}


