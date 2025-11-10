table 50202 "ZATCA Error Log"
{
    Caption = 'ZATCA Error Log';

    fields
    {
        field(50200; ID; Integer)
        {
            AutoIncrement = true;
            Caption = 'Error ID';
            DataClassification = CustomerContent;
        }
        field(50201; Type; Text[200])
        {
            Caption = 'Type';
            DataClassification = CustomerContent;
        }
        field(50202; "Document No."; Code[20])
        {
            Caption = 'Document No.';
            DataClassification = CustomerContent;
        }
        field(50203; Status; Text[100])
        {
            Caption = 'Status';
            DataClassification = CustomerContent;
        }
        field(50204; Code; Text[200])
        {
            Caption = 'Code';
            DataClassification = CustomerContent;
        }
        field(50205; Category; Text[200])
        {
            Caption = 'Category';
            DataClassification = CustomerContent;
        }
        field(50206; Message; Text[1000])
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
