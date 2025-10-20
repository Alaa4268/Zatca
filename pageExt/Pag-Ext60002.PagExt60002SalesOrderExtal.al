pageextension 60002 "Pag-Ext60002.SalesOrderExt.al" extends "Sales Order"
{

    layout
    {
        modify("Shortcut Dimension 2 Code")
        {
            ShowMandatory=true;
        }
    }
    actions
    {
        addfirst(processing)
        {
            action(PrintSalesInvoicePreviewReport)
            {
                ApplicationArea = All;
                Promoted = true;
                PromotedCategory = Report;
                Caption = 'Print Sales Invoice Preview';
                trigger OnAction()
                var
                    SalesHeader: Record "Sales Header";
                begin

                    SalesHeader := Rec;
                    CurrPage.SetSelectionFilter(SalesHeader);
                    SalesHeader.SetRecFilter();
                    Report.Run(60002, true, true, SalesHeader);
                end;
            }

        }
    }
}

