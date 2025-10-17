page 60104 "ZATCA VAT Exemption"
{
    ApplicationArea = All;
    Caption = 'ZATCA VAT Exemption';
    PageType = List;
    SourceTable = "ZATCA VAT Exemption";
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Reason Code"; Rec."Reason Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Reason Code field.';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Description field.';
                }
            }
        }
    }
}
