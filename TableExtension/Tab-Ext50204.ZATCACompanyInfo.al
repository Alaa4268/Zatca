tableextension 50204 "ZATCA Company Info" extends "Company Information"
{
    fields
    {
        field(50200; "ZATCA Scheme Type";Enum "ZATCA Scheme Type")
        {
            Caption = 'Scheme Type';
            DataClassification = CustomerContent;
        }
        field(50201; "ZATCA Scheme ID"; Text[50])
        {
            Caption = 'Scheme ID';
            DataClassification = CustomerContent;
        }
        field(50202; "ZATCA Building No."; Text[4])
        {
            Caption = 'Building No.';
            DataClassification = CustomerContent;
        }
        field(50203; "ZATCA Street Name"; Text[100])
        {
            Caption = 'Street Name';
            DataClassification = CustomerContent;
        }
        field(50204; "ZATCA Plot Identification"; Text[200])
        {
            Caption = 'Plot Identification';
            DataClassification = CustomerContent;
        }
    }
}
