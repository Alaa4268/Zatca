permissionset 60100 "ZATCA EInvoicing"
{
    Assignable = true;
    Caption = 'ZATCA EInvoicing', MaxLength = 30;
    Permissions = table "ZATCA Device Onboarding"=X,
        tabledata "ZATCA Device Onboarding"=RIMD,
        table "ZATCA API Log"=X,
        tabledata "ZATCA API Log"=RIMD,
        table "ZATCA VAT Exemption"=X,
        tabledata "ZATCA VAT Exemption"=RIMD,
        table "ZATCA Error Log"=X,
        tabledata "ZATCA Error Log"=RIMD,
        table "ZATCA Hash"=X,
        tabledata "ZATCA Hash"=RIMD,
        page "ZATCA Device Onboarding"=X,
        page "ZATCA API Logs"=X,
        page "ZATCA Invoice Log"=,
        page "ZATCA VAT Exemption"=X,
        page "ZATCA Error And Warnings"=X,
        codeunit "ZATCA Activation Mgt."=X,
        codeunit "ZATCA API Processing"=X,
        codeunit "ZATCA Event Mgt"=X,
        codeunit "ZATCA Payload Mgt."=X,
        codeunit "ZATCA Sync Posted Documents"=X;
}
