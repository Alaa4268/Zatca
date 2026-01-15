tableextension 50207 "ZATCA Sales Credit Memo" extends "Sales Cr.Memo Header"
{
    fields
    {
        field(50200; Status; Enum "ZATCA Status")
        {
            Caption = 'Status';
            DataClassification = CustomerContent;
            InitValue = " ";
        }
        field(50201; "ZATCA Message"; Text[500])
        {
            Caption = 'Message';
            DataClassification = CustomerContent;
        }
        field(50202; "Zat Cr No."; Code[50])
        {
            DataClassification = ToBeClassified;
        }
        field(50203; "B/L-MAWB#"; Code[25])
        {
            ToolTip = 'this field refersto either the Bill of Lading number (if by sea) or Master Air Waybill number (if by air).';
            DataClassification = ToBeClassified;
        }
        field(50204; "ZAT Bayan No."; Code[20])
        {
            Caption = 'Bayan No.';
            DataClassification = ToBeClassified;
        }
        field(50205; "Zatca Consignee"; Text[100])
        {
            Caption = 'Consignee';
            DataClassification = ToBeClassified;
        }
        field(50206; "Zatca ETD"; Date)
        {
            Caption = 'ETD';
            ToolTip = 'This field specifies the estimated time of departure';
            DataClassification = ToBeClassified;
        }
        field(50207; "Zatca CNTE.#"; Code[20])
        {
            Caption = 'CNTE.#';
            ToolTip = 'This field specifies the containor number';
            DataClassification = ToBeClassified;
        }
        field(50208; "Port L."; Code[20])
        {
            ToolTip = 'This field specifies the port of loading';
            DataClassification = ToBeClassified;
        }
        field(50209; "Port D."; Code[20])
        {
            ToolTip = 'This field specifies the port of Discharge';
            DataClassification = ToBeClassified;
        }
        field(50210; "Zatca Shippper"; Text[100])
        {
            Caption = 'Shipper';
            DataClassification = ToBeClassified;
        }
        field(50211; Commodity; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(50212; "Foreign Currency Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Currency;
        }
        field(50213; "ZATCA Id"; Text[100])
        {
            Caption = 'Clearance/Reporting Id';
            DataClassification = CustomerContent;
        }
        field(50214; "Issue Date"; Date)
        {
            Caption = 'Issue Date';
            DataClassification = CustomerContent;
        }
        field(50215; QRCode; Text[2048])
        {
            Caption = 'QR Code';
            DataClassification = CustomerContent;
        }
        field(50216; "Has QR Code"; Boolean)
        {
            Caption = 'Has QR Code';
            DataClassification = CustomerContent;
        }
        field(50217; "Invoice Hash"; Text[500])
        {
            Caption = 'Invoice Hash';
            DataClassification = CustomerContent;
        }
        field(50218; "QR Code"; Text[2048])
        {
            DataClassification = ToBeClassified;
        }
        field(50219; "QR Code Generated"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50220; "QR code Generation Error"; Text[2048])
        {
            DataClassification = ToBeClassified;
        }
    }
}
