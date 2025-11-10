codeunit 50201 "ZATCA Activation Mgt."
{
    Access = Internal;

    internal procedure IsZATCAIntegrationModuleActive(): Boolean var
        ZATCADeviceOnboarding: Record "ZATCA Device Onboarding";
    begin
        if ZATCADeviceOnboarding.Get() and ZATCADeviceOnboarding.IsActive then exit(true);
    end;
    internal procedure CreateJobQueueEntry()
    var
        JobQueueEntry: Record "Job Queue Entry";
        ZATCADeviceOnboarding: Record "ZATCA Device Onboarding";
    begin
        if not IsZATCAIntegrationModuleActive()then exit;
        if ZATCADeviceOnboarding.Get()then;
        JobQueueEntry.SetRange("Object Type to Run", JobQueueEntry."Object Type to Run"::Codeunit);
        JobQueueEntry.SetRange("Object ID to Run", Codeunit::"ZATCA Sync Posted Documents");
        JobQueueEntry.SetRange(ID, ZATCADeviceOnboarding."Job Queue Entry ID");
        if not JobQueueEntry.FindFirst()then begin
            JobQueueEntry.InitRecurringJob(1440);
            JobQueueEntry.ID:=CreateGuid();
            JobQueueEntry.Status:=JobQueueEntry.Status::Ready;
            JobQueueEntry."Object ID to Run":=Codeunit::"ZATCA Sync Posted Documents";
            JobQueueEntry."Object Type to Run":=JobQueueEntry."Object Type to Run"::Codeunit;
            JobQueueEntry."Earliest Start Date/Time":=CreateDateTime(Today, System.Time);
            JobQueueEntry."User ID":=CopyStr(UserId, 1, MaxStrLen(JobQueueEntry."User ID"));
            if JobQueueEntry.Insert()then begin
                ZATCADeviceOnboarding."Job Queue Entry ID":=JobQueueEntry.ID;
                ZATCADeviceOnboarding.Modify();
            end;
        end;
    end;
}
