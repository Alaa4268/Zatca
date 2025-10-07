page 60103 "ZATCA Invoice Log"
{
    ApplicationArea = All;
    Caption = 'ZATCA Invoice Log';
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = "ZATCA Hash";
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field(ID; Rec.ID)
                {
                    ToolTip = 'Specifies the value of the ID field.';
                }
                field("BC Invoice Number"; Rec."BC Invoice Number")
                {
                    ToolTip = 'Specifies the value of the BC Invoice Number field.';
                }
                field("ZATCA ID"; Rec."ZATCA ID")
                {
                    ToolTip = 'Specifies the value of the ID Sent to ZATCA field.';
                }
                field("Invoice Counter Value"; Rec."Invoice Counter Value")
                {
                    ToolTip = 'Specifies the value of the Invoice Counter Value field.';
                }
                field("Previous Invoice Hash"; Rec."Previous Invoice Hash")
                {
                    ToolTip = 'Specifies the value of the Previous Invoice Hash field.';
                }
                field(SystemCreatedAt; Rec.SystemCreatedAt)
                {
                    Caption = 'Log Created At';
                    ToolTip = 'Specifies the value of the SystemCreatedAt field.';
                }
                field(SystemCreatedBy; Rec.SystemCreatedBy)
                {
                    Caption = 'Created By';
                    ToolTip = 'Specifies the value of the SystemCreatedBy field.';
                }
            }
        }
    }
}
