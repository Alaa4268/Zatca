pageextension 60101 "ZATCA Customer" extends "Customer Card"
{
    layout
    {
        addafter(General)
        {
            group(ZATCA)
            {
                Caption = 'ZATCA';

                field("Is B2B"; Rec."Is B2B")
                {
                    ApplicationArea = All;
                    Editable = EditableField;
                    ToolTip = 'Specifies this customer is B2B';
                }
                field("Is B2C"; Rec."Is B2C")
                {
                    ApplicationArea = All;
                    Editable = EditableField;
                    ToolTip = 'Specifies this customer is B2C';
                }
                field("ZATCA Scheme Type"; Rec."ZATCA Scheme Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the scheme type used for party_identification on ZATCA';
                }
                field("ZATCA Scheme ID"; Rec."ZATCA Scheme ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of scheme Id.';
                }
                field("ZATCA Street Name"; Rec."ZATCA Street Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of Street Name.';
                }
                field("ZATCA Building No."; Rec."ZATCA Building No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of Building No.';
                }
                field("ZATCA Plot Identification"; Rec."ZATCA Plot Identification")
                {
                    ApplicationArea = All;
                    ToolTip = 'Plot Identification';
                }
            }
        }
    }
    trigger OnAfterGetRecord()
    var
        UserSetup: Record "User Setup";
    begin
        EditableField:=UserSetup.Get(UserId()) and (UserSetup."Allow ZATCA Configuration");
    end;
    var EditableField: Boolean;
}
