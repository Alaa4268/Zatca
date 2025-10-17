table 60101 "ZATCA Device Onboarding"
{
    Caption = 'ZATCA Device Onboarding';
    DataClassification = CustomerContent;
    DrillDownPageId = "ZATCA Device Onboarding";

    fields
    {
        field(1; "Primary Key"; Code[10])
        {
            Caption = 'Primary Key';
            DataClassification = CustomerContent;
        }
        field(2; IsActive; Boolean)
        {
            Caption = 'Activate ZATCA Integration';
            DataClassification = CustomerContent;
        }
        field(3; CSID; Text[2048])
        {
            Caption = 'CSID';
            DataClassification = CustomerContent;
            ExtendedDatatype = Masked;
        }
        field(4; "Private Key"; Text[2048])
        {
            Caption = 'Private Key';
            DataClassification = CustomerContent;
            ExtendedDatatype = Masked;
        }
        field(5; "Secret Key"; Text[2048])
        {
            Caption = 'Secret Key';
            DataClassification = CustomerContent;
            ExtendedDatatype = Masked;
        }
        field(6; OTP; Text[6])
        {
            Caption = 'OTP';
            DataClassification = CustomerContent;
        }
        field(7; "Device Id"; Text[50])
        {
            Caption = 'Device Id';
            DataClassification = CustomerContent;
        }
        field(8; "Invoice Type"; Text[10])
        {
            Caption = 'Invoice Type';
            DataClassification = CustomerContent;
        }
        field(9; "CR No."; Text[50])
        {
            Caption = 'CR No.';
            DataClassification = CustomerContent;
        }
        field(10; "Serial Number"; Integer)
        {
            Caption = 'Serial Number';
            DataClassification = CustomerContent;
        }
        field(11; "Xml File Path"; Text[100])
        {
            Caption = 'Xml file path';
            DataClassification = CustomerContent;
        }
        field(12; "Error Message"; Text[2048])
        {
            Caption = 'Error Message';
            DataClassification = CustomerContent;
        }
        field(13; "Has Error"; Boolean)
        {
            Caption = 'Has Error';
            DataClassification = CustomerContent;
        }
        field(14; "On Document Posting"; Boolean)
        {
            Caption = 'On Document Posting';
            DataClassification = CustomerContent;
        }
        field(15; "On Posted Documents"; Boolean)
        {
            Caption = 'On Posted Documents';
            DataClassification = CustomerContent;
        }
        field(16; "Instruction Note"; Text[200])
        {
            Caption = 'Instruction Note';
            DataClassification = CustomerContent;
        }
        field(17; "Auto Sync"; Boolean)
        {
            Caption = 'Auto Sync';
            DataClassification = CustomerContent;

            trigger OnValidate()
            var
                JobQueueEntry: Record "Job Queue Entry";
            begin
                if Rec."Auto Sync" then
                    CreateJobQueueEntry()
                else if JobQueueEntry.Get(Rec."Job Queue Entry ID") then begin
                    JobQueueEntry.Delete();
                    Clear(Rec."Job Queue Entry ID");
                end;
            end;
        }
        field(18; "Job Queue Entry ID"; Guid)
        {
            Caption = 'Job Queue Entry ID';
            DataClassification = CustomerContent;
        }
        field(19; "Base URL"; Text[200])
        {
            Caption = 'Base URL';
            DataClassification = CustomerContent;
            InitValue = 'http://8.213.81.176/api/';
        }
        field(20; "Submit Document Endpoint"; Text[100])
        {
            Caption = 'Submit Document Endpoint';
            DataClassification = CustomerContent;
            InitValue = 'SignAndSubmitInvoice';
        }
        field(21; "First Invoice Hash"; Text[1024])
        {
            Caption = 'First Invoice Hash';
            DataClassification = CustomerContent;
            InitValue = 'NXZlY2ViNjZmZmM4NmYzOGQ5NTI3ODZjNmQ2OTZjNzljMmRiYzIzOWRkNGU5MWI0NjcyOWQ3M2EyN2ZiNTdlOQ==';
        }
        field(22; "Last Onboarding Date"; Date)
        {
            Caption = 'Last Onboarding Date';
            DataClassification = CustomerContent;
        }
        field(23; "Already Onboarded"; Boolean)
        {
            Caption = 'Already Onboarded';
            DataClassification = CustomerContent;
        }
        field(24; "Onboarding Endpoint"; Text[200])
        {
            DataClassification = CustomerContent;
            InitValue = 'deviceOnboarding';
        }
    }
    keys
    {
        key(PK; "Primary Key")
        {
            Clustered = true;
        }
    }
    internal procedure CreateJobQueueEntry()
    var
        JobQueueEntry: Record "Job Queue Entry";
        ZATCAActivationMgt: Codeunit "ZATCA Activation Mgt.";
    begin
        if not ZATCAActivationMgt.IsZATCAIntegrationModuleActive() then exit;
        JobQueueEntry.SetRange("Object Type to Run", JobQueueEntry."Object Type to Run"::Codeunit);
        JobQueueEntry.SetRange("Object ID to Run", Codeunit::"ZATCA Sync Posted Documents");
        JobQueueEntry.SetRange(ID, Rec."Job Queue Entry ID");
        if not JobQueueEntry.FindFirst() then begin
            JobQueueEntry.InitRecurringJob(1440);
            JobQueueEntry.ID := CreateGuid();
            JobQueueEntry.Status := JobQueueEntry.Status::Ready;
            JobQueueEntry."Object ID to Run" := Codeunit::"ZATCA Sync Posted Documents";
            JobQueueEntry."Object Type to Run" := JobQueueEntry."Object Type to Run"::Codeunit;
            JobQueueEntry."Earliest Start Date/Time" := CreateDateTime(Today, System.Time);
            JobQueueEntry."User ID" := CopyStr(UserId, 1, MaxStrLen(JobQueueEntry."User ID"));
            if JobQueueEntry.Insert() then begin
                Rec."Job Queue Entry ID" := JobQueueEntry.ID;
                Rec.Modify();
            end;
        end;
    end;
}
