table 50204 "ZATCA VAT Exemption"
{
    Caption = 'ZATCA VAT Exemption';
    DataClassification = CustomerContent;

    fields
    {
        field(50200; "Reason Code"; Code[20])
        {
            Caption = 'Reason Code';
            DataClassification = CustomerContent;
        }
        field(50201; Description; Text[200])
        {
            Caption = 'Description';
            DataClassification = CustomerContent;
        }
    }
    keys
    {
        key(Key1; "Reason Code")
        {
            Clustered = true;
        }
    }
    fieldgroups
    {
        fieldgroup(DropDown; "Reason Code", Description)
        {
        }
    }
}
