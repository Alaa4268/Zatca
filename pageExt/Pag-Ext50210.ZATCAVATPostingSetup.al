pageextension 50210 "ZATCA VAT Posting Setup" extends "VAT Posting Setup"
{
    layout
    {
        addafter(Description)
        {
            field("ZATCA VAT Exemption Code"; Rec."ZATCA VAT Exemption Code")
            {
                ApplicationArea = All;
                ToolTip = 'Tax Exemption Reason Code';
            }
            field("ZATCA VAT Description"; Rec."ZATCA VAT Description")
            {
                ApplicationArea = All;
                ToolTip = 'ZATCA VAT Description';
            }
        }
    }
}
