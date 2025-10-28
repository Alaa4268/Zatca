pageextension 60111 "Sales Invoice Ext" extends "Sales Invoice"
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
                field("Foreign Currency Code"; Rec."Foreign Currency Code") { ApplicationArea = All; }
            }
        }
    }


    trigger OnAfterGetCurrRecord()
    begin
        DimIsMarda := ZatcaEventMgt.DimIsMarda(Rec.RecordId);
    end;




    var
        DimIsMarda: Boolean;
        GLSetup: Record "General Ledger Setup";
        ZatcaEventMgt: Codeunit "ZATCA Event Mgt";
}
