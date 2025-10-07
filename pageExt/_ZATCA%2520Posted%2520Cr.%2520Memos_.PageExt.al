pageextension 60102 "ZATCA Posted Cr. Memos" extends "Posted Sales Credit Memos"
{
    layout
    {
        addafter("No.")
        {
            field(Status; Rec.Status)
            {
                ApplicationArea = All;
                StyleExpr = StyleText;
                ToolTip = 'Specifies the status of ZATCA E-Invoicing';
            }
            field("Has QR Code"; Rec."Has QR Code")
            {
                ApplicationArea = All;
                StyleExpr = StyleText;
                ToolTip = 'Specifies the status of ZATCA E-Invoicing';
            }
        }
    }
    actions
    {
        addfirst(Promoted)
        {
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
                Image = Approval;
                ToolTip = 'ZATCA Clearance/Reporting';
                Visible = ShowAction and ShowField and (Rec."ZATCA Id" = '');

                trigger OnAction()
                var
                    ZATCAAPIProcessing: Codeunit "ZATCA API Processing";
                begin
                    if(Rec.Status in[Rec.Status::Cleared, Rec.Status::Reported])then Message('This document has already been approved by ZATCA.')
                    else
                        ZATCAAPIProcessing.SignAndSubmit(Rec, true)end;
            }
        }
        addafter("&Credit Memo")
        {
            action("ZATCA Error Log")
            {
                ApplicationArea = All;
                Caption = 'ZATCA Error Log';
                Image = ErrorLog;
                ToolTip = 'ZATCA Error Log';
                Visible = (ShowAction) and ShowField and (Rec.Status = Rec.Status::Error);

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
        ZATCAActivationMgt: Codeunit "ZATCA Activation Mgt.";
    begin
        ShowField:=ZATCAActivationMgt.IsZATCAIntegrationModuleActive();
        if ZATCADeviceOnboarding.Get()then ShowAction:=ZATCADeviceOnboarding."On Posted Documents";
        if ZATCAActivationMgt.IsZATCAIntegrationModuleActive()then case Rec.Status of Rec.Status::" ": StyleText:='None';
            Rec.Status::Error: StyleText:='Unfavorable';
            Rec.Status::Cleared, Rec.Status::Reported: StyleText:='Favorable';
            end;
    end;
    var ShowAction, ShowField: Boolean;
    StyleText: Text;
}
