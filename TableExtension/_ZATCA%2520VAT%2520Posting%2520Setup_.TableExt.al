tableextension 60107 "ZATCA VAT Posting Setup" extends "VAT Posting Setup"
{
    fields
    {
        field(60100; "ZATCA VAT Exemption Code"; Text[50])
        {
            Caption = 'ZATCA VAT Exemption Code';
            DataClassification = CustomerContent;
            TableRelation = "ZATCA VAT Exemption"."Reason Code";

            trigger OnValidate()
            var
                ZATCAVATExemption: Record "ZATCA VAT Exemption";
            begin
                if ZATCAVATExemption.Get(Rec."ZATCA VAT Exemption Code")then begin
                    Rec."ZATCA VAT Description":=ZATCAVATExemption.Description;
                    Rec.Modify();
                end;
            end;
        }
        field(60101; "ZATCA VAT Description"; Text[200])
        {
            Caption = 'ZATCA VAT Description';
            DataClassification = CustomerContent;
        }
    }
}
