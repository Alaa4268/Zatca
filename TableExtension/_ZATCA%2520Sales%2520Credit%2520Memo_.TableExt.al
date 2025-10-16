tableextension 60103 "ZATCA Sales Credit Memo" extends "Sales Cr.Memo Header"
{
    fields
    {
        field(60100; "ZATCA Id"; Text[100])
        {
            Caption = 'Clearance/Reporting Id';
            DataClassification = CustomerContent;
        }
        field(60101; "Issue Date"; Date)
        {
            Caption = 'Issue Date';
            DataClassification = CustomerContent;
        }
        field(60102; QRCode; Text[2048])
        {
            Caption = 'QR Code';
            DataClassification = CustomerContent;
        }
        field(60103; Status;Enum "ZATCA Status")
        {
            Caption = 'Status';
            DataClassification = CustomerContent;
            InitValue = " ";
        }
        field(60104; "Has QR Code"; Boolean)
        {
            Caption = 'Has QR Code';
            DataClassification = CustomerContent;
        }
        field(60105; "Invoice Hash"; Text[500])
        {
            Caption = 'Invoice Hash';
            DataClassification = CustomerContent;
        }
        field(60106; "ZATCA Message"; Text[500])
        {
            Caption = 'Message';
            DataClassification = CustomerContent;
        }
        field(60107; "Zat Cr No."; Code[50])
        {
            DataClassification = ToBeClassified;
        }
    }
}
