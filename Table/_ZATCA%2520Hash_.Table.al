table 60103 "ZATCA Hash"
{
    Caption = 'ZATCA Hash';
    DataClassification = CustomerContent;

    fields
    {
        field(1; ID; Integer)
        {
            AutoIncrement = true;
            Caption = 'ID';
            DataClassification = CustomerContent;
        }
        field(2; "Previous Invoice Hash"; Text[500])
        {
            Caption = 'Invoice Hash';
            DataClassification = CustomerContent;
        }
        field(3; "Invoice Counter Value"; Integer)
        {
            Caption = 'ICV';
            DataClassification = CustomerContent;
        }
        field(4; "BC Invoice Number"; Code[20])
        {
            Caption = 'BC Document Number';
            DataClassification = CustomerContent;
        }
        field(5; "ZATCA ID"; Text[50])
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
