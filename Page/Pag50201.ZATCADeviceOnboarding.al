page 50201 "ZATCA Device Onboarding"
{
    ApplicationArea = Basic, Suite;
    Caption = 'ZATCA Onboarding Setup';
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = Card;
    SourceTable = "ZATCA Device Onboarding";
    UsageCategory = Administration;

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'Activation';

                field(IsActive; Rec.IsActive)
                {
                    ApplicationArea = All;
                    Caption = 'Activate';
                    ToolTip = 'This will Activate Zenegy Payroll app.';
                }
            }
            group("Device Information")
            {
                Caption = 'Device Onboarding Information';
                Visible = Rec.IsActive;

                field(OTP; Rec.OTP)
                {
                    ApplicationArea = All;
                    ShowMandatory = true;
                    ToolTip = 'Specifies the value of Base URL used for sending API request.';
                }
                field("Device Id"; Rec."Device Id")
                {
                    ApplicationArea = All;
                    ShowMandatory = true;
                    ToolTip = 'Specifies the value of Client ID used to get Acess token.';
                }
                field("Serial Number"; Rec."Serial Number")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies tha value of Serial Number field.';
                }
                field("Already Onboarded"; Rec."Already Onboarded")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies if you were already onboarded then fill in below information in next section.';
                }
                field("Serial Code"; Rec."Serial Code") { ApplicationArea = All; }
            }
            group("Onborading Information")
            {
                Visible = Rec.IsActive;

                field(CSID; Rec.CSID)
                {
                    ApplicationArea = All;
                    Editable = Rec."Already Onboarded";
                    ShowMandatory = true;
                    ToolTip = 'Specifies the value of CSID.';
                }
                field("Private Key"; Rec."Private Key")
                {
                    ApplicationArea = All;
                    Editable = Rec."Already Onboarded";
                    ShowMandatory = true;
                    ToolTip = 'Specifies the value of Private Key.';
                }
                field("Secret Key"; Rec."Secret Key")
                {
                    ApplicationArea = All;
                    Editable = Rec."Already Onboarded";
                    ShowMandatory = true;
                    ToolTip = 'Specifies the value of Secret Key.';
                }
                field("Last Onboarding Date"; Rec."Last Onboarding Date")
                {
                    ApplicationArea = All;
                    Editable = Rec."Already Onboarded";
                    ShowMandatory = true;
                    ToolTip = 'Specifies the date when you onboard';
                }
                group(ErrorMessage)
                {
                    ShowCaption = false;
                    Visible = Rec."Has Error";

                    field("Error Message"; Rec."Error Message")
                    {
                        ApplicationArea = All;
                        ToolTip = 'Error Message';
                    }
                }
            }
            group("Document Approval Setup")
            {
                Caption = 'Document Approval Setup';
                Visible = Rec.IsActive;

                field("On Document Posting"; Rec."On Document Posting")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies if you want to clear/report your document while posting it';
                }
                field("On Posted Documents"; Rec."On Posted Documents")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies if you want to clear/report your document after it has been posted';
                }
                field("Auto Sync"; Rec."Auto Sync")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies when this field is turned on, a job queue entry is created to get approval of Posted Sales Invoice and Posted Sales Cr. Memos from ZATCA.';
                }
                field("Instruction Note"; Rec."Instruction Note")
                {
                    ApplicationArea = All;
                    ShowMandatory = true;
                    ToolTip = 'Specifies the instrcution note that is must provided when approving posted Sales Cr. Memo from ZATCA';
                }
            }
            group("API URL Setup")
            {
                Caption = 'API URL Setup';
                Visible = Rec.IsActive and ShowAPICallSetup;

                field("Base URL"; Rec."Base URL")
                {
                    ApplicationArea = All;
                    Editable = EditEndpoints;
                    ToolTip = 'Base URL';
                }
                field("Onboarding Endpoint"; Rec."Onboarding Endpoint")
                {
                    ApplicationArea = All;
                    Editable = EditEndpoints;
                    ToolTip = 'Onboarding Endpoint';
                }
                field("Submit Document Endpoint"; Rec."Submit Document Endpoint")
                {
                    ApplicationArea = All;
                    Editable = EditEndpoints;
                    ToolTip = 'Submit Document Endpoint';
                }
                field("First Invoice Hash"; Rec."First Invoice Hash")
                {
                    ApplicationArea = All;
                    Editable = EditEndpoints;
                    ToolTip = 'First Invoice Hash';
                }
            }
        }
    }
    actions
    {
        area(Promoted)
        {
            group("ZATCA Onboarding")
            {
                Caption = 'ZATCA Onboarding';

                actionref(DeviceOnboarding; "Device Onboarding")
                {
                }
            }
            group(Navigate)
            {
                Caption = 'Navigate';

                actionref(JobQueueEntry; "Job Queue Entry")
                {
                }
                actionref(ShowAPISetting; ShowAPISettings)
                {
                }
                actionref(Endpoints; EditEndpoint)
                {
                }
                actionref(InvoicesinError; "Invoices in Error")
                {
                }
                actionref(SalesCrMemoinError; "Sales Cr Memo in Error")
                {
                }
                actionref(APILogs; APILog)
                {
                }
                actionref(ZATCAHelp; "Help")
                {
                }
            }
        }
        area(Processing)
        {
            action("Device Onboarding")
            {
                ApplicationArea = All;
                Caption = 'Device Onboarding';
                Image = Register;
                ToolTip = 'Device Onboarding';

                trigger OnAction()
                var
                    ZATCAAPIProcessing: Codeunit "ZATCA API Processing";
                begin
                    if Rec.CSID <> '' then
                        ZATCAAPIProcessing.ZATCADeviceOnboardingProc(OldDeviceId)
                    else if Confirm('You have already onboarded. Do you want to onboard again?') then ZATCAAPIProcessing.ZATCADeviceOnboardingProc(OldDeviceId)
                end;
            }
        }
        area(Navigation)
        {
            action("Job Queue Entry")
            {
                ApplicationArea = All;
                Caption = 'Job Queue Entry';
                Image = Navigate;
                ToolTip = 'Opens the setup page for Job Invoicing module.';
                Visible = Rec.CSID <> '';

                trigger OnAction()
                var
                    JobQueueEntry: Record "Job Queue Entry";
                begin
                    if JobQueueEntry.Get(Rec."Job Queue Entry ID") then Page.Run(Page::"Job Queue Entry Card", JobQueueEntry);
                end;
            }
            action(ShowAPISettings)
            {
                ApplicationArea = All;
                Caption = 'Show/Hide API Settings';
                Image = ShowSelected;
                ToolTip = 'Show/Hide API URL Setup';

                trigger OnAction()
                begin
                    if ShowAPICallSetup then
                        ShowAPICallSetup := false
                    else
                        ShowAPICallSetup := true;
                end;
            }
            action(EditEndpoint)
            {
                ApplicationArea = All;
                Caption = 'Edit API Settings';
                Image = Edit;
                ToolTip = 'Edit API URL Setup';
                Visible = ShowAPICallSetup;

                trigger OnAction()
                begin
                    if EditEndpoints then
                        EditEndpoints := false
                    else if Confirm('Do you want to edit API Settings? It cannot be changed back to previous settings.') then EditEndpoints := true;
                end;
            }
            action("Invoices in Error")
            {
                ApplicationArea = All;
                Caption = 'Invoices in Error';
                Image = Navigate;
                ToolTip = 'Opens the Invoices in Error.';
                Visible = Rec.CSID <> '';

                trigger OnAction()
                var
                    SalesInvocieHeader: Record "Sales Invoice Header";
                begin
                    SalesInvocieHeader.SetFilter(Status, '=%1', SalesInvocieHeader.Status::Error);
                    if SalesInvocieHeader.FindSet() then Page.Run(Page::"Posted Sales Invoices", SalesInvocieHeader);
                end;
            }
            action("Sales Cr Memo in Error")
            {
                ApplicationArea = All;
                Caption = 'Sales Cr Memo in Error';
                Image = Navigate;
                ToolTip = 'Opens Sales Cr Memo in Error.';
                Visible = Rec.CSID <> '';

                trigger OnAction()
                var
                    SalesCrMemoHeader: Record "Sales Cr.Memo Header";
                begin
                    SalesCrMemoHeader.SetFilter(Status, '=%1', SalesCrMemoHeader.Status::Error);
                    if SalesCrMemoHeader.FindSet() then Page.Run(Page::"Posted Sales Credit Memos", SalesCrMemoHeader);
                end;
            }
            action(APILog)
            {
                ApplicationArea = All;
                Caption = 'API Logs';
                Image = Log;
                RunObject = Page "ZATCA API Logs";
                ToolTip = 'Opens API Logs page';
            }
            action("Help")
            {
                ApplicationArea = All;
                Caption = 'Help';
                Enabled = ShowAPICallSetup;
                Image = Help;
                ToolTip = 'This will navigate to ZATCA Government Portal';
                Visible = ShowAPICallSetup;

                trigger OnAction()
                begin
                    System.Hyperlink('https://zatca.gov.sa/ar/pages/default.aspx');
                end;
            }
        }
    }
    trigger OnInit()
    begin
        if Rec.IsEmpty then Rec.Insert();
        Rec."Xml File Path" := 'C:\\ZATCAConfiguration\\BF-ZATCA-INPUT-DATAFILE.xml';
    end;

    trigger OnOpenPage()
    begin
        OldDeviceId := Rec."Device Id";
    end;

    trigger OnQueryClosePage(CloseAction: Action): Boolean
    begin
        if Rec."Already Onboarded" then begin
            Rec."Already Onboarded" := false;
            Rec.Modify();
        end
    end;

    var
        EditEndpoints, ShowAPICallSetup : Boolean;
        OldDeviceId: Text;
}
