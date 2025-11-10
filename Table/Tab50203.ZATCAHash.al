table 50203 "ZATCA Hash"
{
    Caption = 'ZATCA Hash';
    DataClassification = CustomerContent;

    fields
    {
        field(50200; ID; Integer)
        {
            AutoIncrement = true;
            Caption = 'ID';
            DataClassification = CustomerContent;
        }
        field(50201; "Previous Invoice Hash"; Text[500])
        {
            Caption = 'Invoice Hash';
            DataClassification = CustomerContent;
        }
        field(50202; "Invoice Counter Value"; Integer)
        {
            Caption = 'ICV';
            DataClassification = CustomerContent;
        }
        field(50203; "BC Invoice Number"; Code[20])
        {
            Caption = 'BC Document Number';
            DataClassification = CustomerContent;
        }
        field(50204; "ZATCA ID"; Text[50])
        {
            Caption = 'ZATCA ID';
            DataClassification = CustomerContent;
        }
    }
    keys
    {
        key(Key1; ID)
        {
            Clustered = true;
        }
    }
}
