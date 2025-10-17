tableextension 60001 SalesCrMemoHeaderExt extends "Sales Cr.Memo Header"
{
    fields
    {
        // Add changes to table fields here
        field(60000; "QR Code"; Text[2048])
        {
            DataClassification = ToBeClassified;
        }

        field(60001; "QR Code Generated"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(60002; "QR code Generation Error"; Text[2048])
        {
            DataClassification = ToBeClassified;
        }
    }

    var
        myInt: Integer;
}