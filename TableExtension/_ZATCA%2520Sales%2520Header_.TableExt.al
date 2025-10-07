tableextension 60104 "ZATCA Sales Header" extends "Sales Header"
{
    fields
    {
        field(60103; "ZATCA Status";Enum "ZATCA Status")
        {
            Caption = 'Status';
            DataClassification = CustomerContent;
        }
        field(60106; "ZATCA Message"; Text[500])
        {
            Caption = 'Message';
            DataClassification = CustomerContent;
        }
    }
}
