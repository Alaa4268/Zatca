enum 60101 "ZATCA Status"
{
    Caption = 'ZATCA Status';
    Extensible = true;

    value(0; " ")
    {
    Caption = '-';
    }
    value(1; Reported)
    {
    Caption = 'Reported';
    }
    value(2; Error)
    {
    Caption = 'Error';
    }
    value(3; Cleared)
    {
    Caption = 'Cleared';
    }
}
