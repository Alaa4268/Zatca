tableextension 50209 "ZATCA Sales Inv. Header" extends "Sales Invoice Header"
{
    fields
    {
        field(50200; "ZATCA Id"; Text[100])
        {
            Caption = 'Clearance/Reporting Id';
            DataClassification = CustomerContent;
        }
        field(50201; "Issue Date"; Date)
        {
            Caption = 'Issue Date';
            DataClassification = CustomerContent;
        }
        field(50202; QRCode; Text[2048])
        {
            Caption = 'QR Code';
            DataClassification = CustomerContent;
        }
        field(50203; Status; Enum "ZATCA Status")
        {
            Caption = 'Status';
            DataClassification = CustomerContent;
            InitValue = " ";
        }
        field(50204; "Has QR Code"; Boolean)
        {
            Caption = 'Has QR Code';
            DataClassification = CustomerContent;
        }
        field(50205; "Invoice Hash"; Text[500])
        {
            Caption = 'Invoice Hash';
            DataClassification = CustomerContent;
        }
        field(50206; "ZATCA Message"; Text[500])
        {
            Caption = 'Message';
            DataClassification = CustomerContent;
        }
        field(50207; "Zat Cr No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(50208; "B/L-MAWB#"; Code[25])
        {
            ToolTip = 'this field refersto either the Bill of Lading number (if by sea) or Master Air Waybill number (if by air).';
            DataClassification = ToBeClassified;
        }
        field(50209; "ZAT Bayan No."; Code[20])
        {
            Caption = 'Bayan No.';
            DataClassification = ToBeClassified;
        }
        field(50210; "Zatca Consignee"; Text[100])
        {
            Caption = 'Consignee';
            DataClassification = ToBeClassified;
        }
        field(50211; "Zatca ETD"; Date)
        {
            Caption = 'ETD';
            ToolTip = 'This field specifies the estimated time of departure';
            DataClassification = ToBeClassified;
        }
        field(50212; "Zatca CNTE.#"; Code[20])
        {
            Caption = 'CNTE.#';
            ToolTip = 'This field specifies the containor number';
            DataClassification = ToBeClassified;
        }
        field(50213; "Port L."; Code[20])
        {
            ToolTip = 'This field specifies the port of loading';
            DataClassification = ToBeClassified;
        }
        field(50214; "Port D."; Code[20])
        {
            ToolTip = 'This field specifies the port of Discharge';
            DataClassification = ToBeClassified;
        }
        field(50215; "Zatca Shippper"; Text[100])
        {
            Caption = 'Shipper';
            DataClassification = ToBeClassified;
        }
        field(50216; Commodity; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(50217; "Foreign Currency Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Currency;
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
