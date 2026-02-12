pageextension 50213 "Sales Invoice Subform Ext" extends "Sales Invoice Subform"
{
    layout
    {
        movelast(Control1; "Shortcut Dimension 2 Code")

        addlast(Control1)
        {
            // field("is Retention"; Rec."is Retention") { ApplicationArea = All; }
        }
    }
}
