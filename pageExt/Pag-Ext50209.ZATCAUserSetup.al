pageextension 50209 "ZATCA User Setup" extends "User Setup"
{
    layout
    {
        addafter(PhoneNo)
        {
            field("Allow ZATCA Configuration"; Rec."Allow ZATCA Configuration")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies if user has permission to setup ZATCA';
            }
        }
    }
}
