reportextension 60101 "ZATCA Sales Invoice" extends "ZATCA Sales - Invoice"
{
    //RDLCLayout = 'Src\Report Extensions\Layouts\ZATCA Sales_Invoice.rdl';
    dataset
    {
        add(Header)
        {
            column(ZATCAQRCode; DecodeBarCode)
            {
            }
            column(HasZATCAQRCode; "Has QR Code")
            {
            }
        }
        modify(Header)
        {
            trigger OnAfterAfterGetRecord()
            var
                BarcodeSymbology2D: Enum "Barcode Symbology 2D";
                BarcodeFontProvider2D: Interface "Barcode Font Provider 2D";
            begin
                BarcodeFontProvider2D := Enum::"Barcode Font Provider 2D"::IDAutomation2D;
                BarcodeSymbology2D := Enum::"Barcode Symbology 2D"::"QR-Code";
                DecodeBarCode := BarcodeFontProvider2D.EncodeFont(Header.QRCode, BarcodeSymbology2D);
            end;
        }
    }
    var
        TenantMedia: Record "Tenant Media";
        DecodeBarCode: Text;
}
