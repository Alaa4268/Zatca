tableextension 60100 "ZATCA Company Info" extends "Company Information"
{
    fields
    {
        field(60100; "ZATCA Scheme Type";Enum "ZATCA Scheme Type")
        {
            Caption = 'Scheme Type';
            DataClassification = CustomerContent;
        }
        field(60101; "ZATCA Scheme ID"; Text[50])
        {
            Caption = 'Scheme ID';
            DataClassification = CustomerContent;
        }
        field(60102; "ZATCA Building No."; Text[4])
        {
            Caption = 'Building No.';
            DataClassification = CustomerContent;
        }
        field(60103; "ZATCA Street Name"; Text[100])
        {
            Caption = 'Street Name';
            DataClassification = CustomerContent;
        }
        field(60104; "ZATCA Plot Identification"; Text[200])
        {
            Caption = 'Plot Identification';
            DataClassification = CustomerContent;
        }
    }
}
