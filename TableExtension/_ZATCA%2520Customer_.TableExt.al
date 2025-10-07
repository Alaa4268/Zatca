tableextension 60101 "ZATCA Customer" extends Customer
{
    fields
    {
        field(60100; "Is B2B"; Boolean) // 01 standard
        {
            Caption = 'Is B2B';
            DataClassification = CustomerContent;
            InitValue = true;

            trigger OnValidate()
            begin
                if Rec."Is B2B" then Rec."Is B2C":=false
                else
                    Rec."Is B2C":=true;
            end;
        }
        field(60101; "ZATCA Scheme Type";Enum "ZATCA Scheme Type")
        {
            Caption = 'Scheme Type';
            DataClassification = CustomerContent;
        }
        field(60102; "ZATCA Scheme ID"; Text[50])
        {
            Caption = 'Scheme ID';
            DataClassification = CustomerContent;
        }
        field(60103; "ZATCA Building No."; Text[4])
        {
            Caption = 'Building No.';
            DataClassification = CustomerContent;
        }
        field(60104; "ZATCA Street Name"; Text[100])
        {
            Caption = 'Street Name';
            DataClassification = CustomerContent;
        }
        field(60105; "ZATCA Plot Identification"; Text[200])
        {
            Caption = 'Plot Identification';
            DataClassification = CustomerContent;
        }
        field(60106; "Is B2C"; Boolean)
        {
            Caption = 'Is B2C';
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                if Rec."Is B2C" then Rec."Is B2B":=false
                else
                    Rec."Is B2B":=true;
            end;
        }
    }
}
