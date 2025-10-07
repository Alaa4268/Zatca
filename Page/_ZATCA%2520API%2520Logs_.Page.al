page 60100 "ZATCA API Logs"
{
    ApplicationArea = Basic, Suite, Service;
    Caption = 'API Logs';
    DeleteAllowed = true;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    QueryCategory = 'API Call Logs';
    RefreshOnActivate = true;
    SourceTable = "ZATCA API Log";
    SourceTableView = sorting("No.")order(descending);
    UsageCategory = Lists;

    layout
    {
        area(Content)
        {
            repeater(Logs)
            {
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of No.';
                }
                field("Create Date"; Rec."Request Date")
                {
                    ApplicationArea = All;
                    StyleExpr = StyleString;
                    ToolTip = 'Specifies the value of Request Date.';
                }
                field("Create Time"; Rec."Request Time")
                {
                    ApplicationArea = All;
                    StyleExpr = StyleString;
                    ToolTip = 'Specifies the value of Request Time.';
                }
                field(User; Rec.User)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of User id.';
                }
                field("Request URL"; Rec."Request URL")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of Request Url.';
                }
                field("Request Method"; Rec."Request Method")
                {
                    ApplicationArea = All;
                    StyleExpr = StyleString2;
                    ToolTip = 'Specifies the value of Request Method.';
                }
                field("Request Body"; Body)
                {
                    ApplicationArea = All;
                    Caption = 'Request Body';
                    Editable = false;
                    ToolTip = 'Specifies the value of Request Body.';
                }
                field("Response Code"; Rec."Response Code")
                {
                    ApplicationArea = All;
                    StyleExpr = StyleString;
                    ToolTip = 'Specifies the value of Response Code.';
                }
                field("Response Phrase"; Rec."Response Phrase")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of Response phrase.';
                }
                field("Response Message"; Message)
                {
                    ApplicationArea = All;
                    Caption = 'Response Message';
                    Editable = false;
                    ToolTip = 'Specifies the value of Response message.';
                }
                field("Execution Time"; Rec."Execution Time")
                {
                    ApplicationArea = All;
                    Caption = 'Execution Time';
                    Editable = false;
                    ToolTip = 'Specifies the value of Response Execution Time.';
                }
                field("Is Success"; Rec."Is Success")
                {
                    ApplicationArea = All;
                    Caption = 'Is Success';
                    Editable = false;
                    ToolTip = 'Specifies that call was successful or not.';
                    Visible = false;
                }
            }
        }
    }
    trigger OnAfterGetRecord()
    begin
        Body:=Rec.GetRequestBody();
        Message:=Rec.GetResponseMessage();
        if Rec."Is Success" = false then StyleString:='Attention'
        else
            StyleString:='None';
        case Rec."Request Method" of Rec."Request Method"::GET: StyleString2:='AttentionAccent';
        Rec."Request Method"::POST: StyleString2:='Strong';
        Rec."Request Method"::DELETE: StyleString2:='StrongAccent';
        Rec."Request Method"::PATCH: StyleString2:='Ambiguous'
        else
            StyleString2:='None';
        end;
    end;
    var Body, Message, StyleString, StyleString2: Text;
}
