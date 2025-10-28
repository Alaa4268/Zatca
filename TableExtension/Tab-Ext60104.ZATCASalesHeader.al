tableextension 60104 "ZATCA Sales Header" extends "Sales Header"
{
    fields
    {
        field(60103; "ZATCA Status"; Enum "ZATCA Status")
        {
            Caption = 'Status';
            DataClassification = CustomerContent;
        }
        field(60106; "ZATCA Message"; Text[500])
        {
            Caption = 'Message';
            DataClassification = CustomerContent;
        }
        field(60107; "Zat Cr No."; Code[50])
        {
            Caption = 'Cr No.';
            DataClassification = ToBeClassified;
        }
        field(60108; "B/L-MAWB#"; Code[25])
        {
            ToolTip = 'this field refers to either the Bill of Lading number (if by sea) or Master Air Waybill number (if by air).';
            DataClassification = ToBeClassified;
        }
        field(60109; "ZAT Bayan No."; Code[20])
        {
            Caption = 'Bayan No.';
            DataClassification = ToBeClassified;
        }
        field(60110; "Zatca Consignee"; Text[100])
        {
            Caption = 'Consignee';
            DataClassification = ToBeClassified;
        }
        field(60111; "Zatca ETD"; Date)
        {
            Caption = 'ETD';
            ToolTip = 'This field specifies the estimated time of departure';
            DataClassification = ToBeClassified;
        }
        field(60112; "Zatca CNTE.#"; Code[20])
        {
            Caption = 'CNTE.#';
            ToolTip = 'This field specifies the containor number';
            DataClassification = ToBeClassified;
        }
        field(60113; "Port L."; Code[20])
        {
            ToolTip = 'This field specifies the port of loading';
            DataClassification = ToBeClassified;
        }
        field(60114; "Port D."; Code[20])
        {
            ToolTip = 'This field specifies the port of Discharge';
            DataClassification = ToBeClassified;
        }
        field(60115; "Zatca Shippper"; Text[100])
        {
            Caption = 'Shipper';
            DataClassification = ToBeClassified;
        }
        field(60116; Commodity; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(60117; "Foreign Currency Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Currency;
        }
    }
}
