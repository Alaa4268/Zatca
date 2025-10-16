tableextension 60104 "ZATCA Sales Header" extends "Sales Header"
{
    fields
    {
        field(60100; "ZATCA Status";Enum "ZATCA Status")
        {
            Caption = 'Status';
            DataClassification = CustomerContent;
        }
        field(60101; "ZATCA Message"; Text[500])
        {
            Caption = 'Message';
            DataClassification = CustomerContent;
        }
        field(60102; "Zat Cr No."; Code[50])
        {
            Caption='Cr No.';
            DataClassification = ToBeClassified;
        }
    }
}
