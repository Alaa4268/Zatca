tableextension 50002 "General Ledger Setup" extends "General Ledger Setup"
{
    fields
    {
        field(50000; "Brand Dimension Code"; Code[20])
        {
            Caption = 'Brand Dimension Code';
            DataClassification = ToBeClassified;
            TableRelation=Dimension;
        }
        field(50001; "Marada Dim. Value"; Code[50])
        {
            DataClassification = ToBeClassified;
            TableRelation="Dimension Value".Code where("Dimension Code"=field("Brand Dimension Code"));
        }
    }
}
