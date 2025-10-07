tableextension 60102 "ZATCA Job Queue Entry" extends "Job Queue Entry"
{
    fields
    {
    }
    trigger OnDelete()
    var
        ZATCADeviceOnboarding: Record "ZATCA Device Onboarding";
    begin
        if ZATCADeviceOnboarding.Get() and (ZATCADeviceOnboarding."Job Queue Entry ID" = Rec.ID)then begin
            Clear(ZATCADeviceOnboarding."Job Queue Entry ID");
            ZATCADeviceOnboarding."Auto Sync":=false;
            ZATCADeviceOnboarding.Modify();
        end;
    end;
}
