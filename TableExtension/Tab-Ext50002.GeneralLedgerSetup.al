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
    }
}
