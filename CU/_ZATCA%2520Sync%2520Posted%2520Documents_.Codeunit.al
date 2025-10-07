codeunit 60104 "ZATCA Sync Posted Documents"
{
    Permissions = tabledata "Sales Cr.Memo Header"=RM,
        tabledata "Sales Invoice Header"=RM;

    trigger OnRun()
    var
        SalesCrMemoHeader: Record "Sales Cr.Memo Header";
        SalesInvoiceHeader: Record "Sales Invoice Header";
        ZATCADeviceOnboarding: Record "ZATCA Device Onboarding";
        ZATCAActivationMgt: Codeunit "ZATCA Activation Mgt.";
        ZATCAAPIProcessing: Codeunit "ZATCA API Processing";
    begin
        if not ZATCAActivationMgt.IsZATCAIntegrationModuleActive()then exit;
        if ZATCADeviceOnboarding.Get() and ZATCADeviceOnboarding."Auto Sync" and ZATCADeviceOnboarding."On Posted Documents" then SalesInvoiceHeader.SetFilter(Status, '<>%1|<>%2', SalesInvoiceHeader.Status::Cleared, SalesInvoiceHeader.Status::Reported);
        if SalesInvoiceHeader.FindSet()then repeat if not ZATCAAPIProcessing.SignAndSubmit(SalesInvoiceHeader, true)then if SalesInvoiceHeader.Status = SalesInvoiceHeader.Status::Error then SalesInvoiceHeader.Modify()
                    else
                    begin
                        SalesInvoiceHeader.Status:=SalesInvoiceHeader.Status::Error;
                        SalesInvoiceHeader."ZATCA Message":=CopyStr(GetLastErrorText(), 1, MaxStrLen(SalesInvoiceHeader."ZATCA Message"));
                        SalesInvoiceHeader.Modify();
                    end;
            until SalesInvoiceHeader.Next() = 0;
        SalesCrMemoHeader.SetFilter(Status, '<>%1|<>%2', SalesCrMemoHeader.Status::Cleared, SalesCrMemoHeader.Status::Reported);
        if SalesCrMemoHeader.FindSet()then repeat if not ZATCAAPIProcessing.SignAndSubmit(SalesCrMemoHeader, true)then if SalesCrMemoHeader.Status = SalesCrMemoHeader.Status::Error then SalesCrMemoHeader.Modify()
                    else
                    begin
                        SalesCrMemoHeader.Status:=SalesCrMemoHeader.Status::Error;
                        SalesCrMemoHeader."ZATCA Message":=CopyStr(GetLastErrorText(), 1, MaxStrLen(SalesCrMemoHeader."ZATCA Message"));
                        SalesCrMemoHeader.Modify();
                    end;
            until SalesCrMemoHeader.Next() = 0;
    end;
}
