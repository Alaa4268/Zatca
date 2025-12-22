pageextension 50216 "Sales & Receivables Setup Ext" extends "Sales & Receivables Setup"
{
    layout
    {
        addlast(General)
        {
            field("Validate Customer B2B/C"; Rec."Validate Customer B2B/C") { ApplicationArea = All; }
        }
    }
}
