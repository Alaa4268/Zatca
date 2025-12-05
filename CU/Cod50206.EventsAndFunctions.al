codeunit 50206 EventsAndFunctions
{
    [EventSubscriber(ObjectType::Table, Database::Item, OnAfterValidateEvent, Description, false, false)]
    local procedure OnAfterValidateDescriptionEvent(var Rec: Record Item)
    var
        RegEx: Codeunit "RegEx";
        IsMatch: Boolean;
    begin
        // Allow: A–Z, a–z, 0–9, space
        RegEx.Regex('^[A-Za-z0-9 ]*$');
        // RegEx.
        IsMatch := RegEx.IsMatch(Rec.Description);

        if not IsMatch then
            Error('Description must not contain special characters.');

    end;

}
