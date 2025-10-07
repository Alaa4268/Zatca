pageextension 60104 "ZATCA Posted Sales Invoice" extends "Posted Sales Invoice"
{
    layout
    {
        addlast("Invoice Details")
        {
            group("ZATCA Clearance")
            {
                Caption = 'ZATCA';
                Visible = ShowField;

                field(Cleared; Rec.Status)
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies that this invoice has got clearance from ZATCA';
                }
                group("Error Message")
                {
                    ShowCaption = false;
                    Visible = Rec.Status = Rec.Status::Error;

                    field("ZATCA Message"; Rec."ZATCA Message")
                    {
                        ApplicationArea = All;
                        ToolTip = 'Specifies the message we get from ZATCA';
                    }
                }
                field("Issue Date"; Rec."Issue Date")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the issue date of an invoice';
                }
                field("ZATCA Id"; Rec."ZATCA Id")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the id recieved from ZATCA after invoice clearance or invoice reporting';
                }
                group(ZATCAQRCode)
                {
                    ShowCaption = false;
                    Visible = Rec."Has QR Code";

                    field(QRCode; Rec.QRCode)
                    {
                        ApplicationArea = All;
                        Editable = false;
                        MultiLine = true;
                        ToolTip = 'Specifies the value of QR Code got from ZATCA';
                    }
                }
            }
        }
    }
    actions
    {
        addfirst(Promoted)
        {
            actionref(ZATCAClearanceReporting; "ZATCA Clearance/Reporting")
            {
            }
            actionref(ZATCAErrorLog; "ZATCA Error Log")
            {
            }
        }
        addlast(processing)
        {
            action("ZATCA Clearance/Reporting")
            {
                ApplicationArea = All;
                Caption = 'ZATCA Clearance/Reporting';
                Image = ErrorLog;
                ToolTip = 'ZATCA Clearance/Reporting';
                Visible = ShowAction and (Rec."ZATCA Id" = '');

                trigger OnAction()
                var
                    ZATCAAPIProcessing: Codeunit "ZATCA API Processing";
                begin
                    if(Rec.Status in[Rec.Status::Cleared, Rec.Status::Reported])then Message('This document has already been approved by ZATCA.')
                    else
                        ZATCAAPIProcessing.SignAndSubmit(Rec, true)end;
            }
        }
        addafter("&Invoice")
        {
            action("ZATCA Error Log")
            {
                ApplicationArea = All;
                Caption = 'ZATCA Error Log';
                Image = ErrorLog;
                ToolTip = 'ZATCA Error Log';
                Visible = (ShowAction) and (ShowField) and (Rec.Status = Rec.Status::Error);

                trigger OnAction()
                var
                    ZATCAErrorLog: Record "ZATCA Error Log";
                begin
                    ZATCAErrorLog.SetRange("Document No.", Rec."No.");
                    Page.Run(Page::"ZATCA Error And Warnings", ZATCAErrorLog);
                end;
            }
        }
    }
    trigger OnAfterGetRecord()
    var
        ZATCADeviceOnboarding: Record "ZATCA Device Onboarding";
    begin
        ShowField:=ZATCAActivationMgt.IsZATCAIntegrationModuleActive();
        if ZATCADeviceOnboarding.Get()then ShowAction:=ZATCADeviceOnboarding."On Posted Documents";
    end;
    var ZATCAActivationMgt: Codeunit "ZATCA Activation Mgt.";
    ShowAction, ShowField: Boolean;
}
