tableextension 50200 "Dimension Value Ext" extends "Dimension Value"
{
    fields
    {
        field(50200; "Report layout"; Integer)
        {
            Caption = 'Report layout';
            DataClassification = ToBeClassified;
            TableRelation = "Report Layout List";

            trigger OnLookup()
            var
                ReportLayoutRec: Record "Report Layout List";
                ReportLayoutsPage: Page "Report Layouts";
            begin
                if page.RunModal(Page::"Report Layouts", ReportLayoutRec) = Action::LookupOK then begin
                    Validate("Report layout", ReportLayoutRec."Report ID");
                    Validate("Report Name", ReportLayoutRec.Name);
                    // Validate("Runtime Package ID",ReportLayoutRec."Runtime Package ID");
                end;
            end;
        }
        field(50201; "Report Name"; Text[250])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        // field(50202; "Runtime Package ID"; Guid)
        // {
        //     DataClassification = ToBeClassified;
        //     Editable=false;
        // }
    }
}
