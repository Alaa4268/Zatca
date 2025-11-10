page 50202 "ZATCA Error And Warnings"
{
    ApplicationArea = All;
    Caption = 'ZATCA Errors';
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = "ZATCA Error Log";
    UsageCategory = None;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Type"; Rec."Type")
                {
                    ToolTip = 'Specifies the value of the Type field.';
                }
                field("Code"; Rec."Code")
                {
                    ToolTip = 'Specifies the value of the Code field.';
                }
                field(Category; Rec.Category)
                {
                    ToolTip = 'Specifies the value of the Category field.';
                }
                field(Message; Rec.Message)
                {
                    ToolTip = 'Specifies the value of the Message field.';
                }
                field(Status; Rec.Status)
                {
                    ToolTip = 'Status';
                }
                field("Document No."; Rec."Document No.")
                {
                    ToolTip = 'Document No.';
                }
            }
        }
    }
}
