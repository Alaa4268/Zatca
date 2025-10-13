pageextension 60108 "General Ledger Setup Ext" extends "General Ledger Setup"
{

    layout
    {
        addlast(Control1900309501)
        {
            field("Brand Dimension Code"; Rec."Brand Dimension Code") { ApplicationArea = All; }
        }
    }
}
