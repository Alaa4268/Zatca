pageextension 60100 "ZATCA Company Info" extends "Company Information"
{
    layout
    {
        addafter(General)
        {
            group(ZATCA)
            {
                Caption = 'ZATCA';

                field("ZATCA Scheme Type"; Rec."ZATCA Scheme Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'ZATCA Sheme Type';
                }
                field("ZATCA Scheme ID"; Rec."ZATCA Scheme ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'ZATCA Scheme ID';
                }
                field("ZATCA Street Name"; Rec."ZATCA Street Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'ZATCA Street Name';
                }
                field("ZATCA Building No."; Rec."ZATCA Building No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'ZATCA Building No.';
                }
                field("ZATCA Plot Identification"; Rec."ZATCA Plot Identification")
                {
                    ApplicationArea = All;
                    ToolTip = 'Plot Identification';
                }
            }
        }
    }
}
