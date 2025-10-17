table 60102 "ZATCA Error Log"
{
    Caption = 'ZATCA Error Log';

    fields
    {
        field(1; ID; Integer)
        {
            AutoIncrement = true;
            Caption = 'Error ID';
            DataClassification = CustomerContent;
        }
        field(2; Type; Text[200])
        {
            Caption = 'Type';
            DataClassification = CustomerContent;
        }
        field(3; "Document No."; Code[20])
        {
            Caption = 'Document No.';
            DataClassification = CustomerContent;
        }
        field(4; Status; Text[100])
        {
            Caption = 'Status';
            DataClassification = CustomerContent;
        }
        field(5; Code; Text[200])
        {
            Caption = 'Code';
            DataClassification = CustomerContent;
        }
        field(6; Category; Text[200])
        {
            Caption = 'Category';
            DataClassification = CustomerContent;
        }
        field(7; Message; Text[1000])
        {
            Caption = 'Message';
            DataClassification = CustomerContent;
        }
    }
    keys
    {
        key(PK; ID)
        {
            Clustered = true;
        }
    }
    var RecordHasBeenRead: Boolean;
    procedure GetRecordOnce()
    begin
        if RecordHasBeenRead then exit;
        Get();
        RecordHasBeenRead:=true;
    end;
    procedure InsertIfNotExists()
    begin
        Reset();
        if not Get()then begin
            Init();
            Insert(true);
        end;
    end;
}
