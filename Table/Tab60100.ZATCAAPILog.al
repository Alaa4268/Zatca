table 60100 "ZATCA API Log"
{
    Caption = 'API Log';
    DataClassification = CustomerContent;
    DataPerCompany = true;
    PasteIsValid = false;

    fields
    {
        field(1; "No."; Integer)
        {
            AutoIncrement = true;
            Caption = 'No.';
            DataClassification = CustomerContent;
        }
        field(2; "Request Date"; Date)
        {
            Caption = 'Request Date';
            DataClassification = CustomerContent;
        }
        field(3; "Request Time"; Time)
        {
            Caption = 'Request Time';
            DataClassification = CustomerContent;
        }
        field(4; "User"; Text[150])
        {
            Caption = 'User';
            DataClassification = CustomerContent;
        }
        field(5; "Request URL"; Text[1024])
        {
            Caption = 'Request URL';
            DataClassification = CustomerContent;
            ExtendedDatatype = URL;
        }
        field(6; "Request Method";Enum "Http Request Type")
        {
            Caption = 'Request Method';
            DataClassification = CustomerContent;
        }
        field(7; "Request Body"; Blob)
        {
            Caption = 'Request Body';
            DataClassification = CustomerContent;
            Subtype = Json;
        }
        field(8; "Response Code"; Integer)
        {
            Caption = 'Response Code';
            DataClassification = CustomerContent;
        }
        field(9; "Response Phrase"; Text[1024])
        {
            Caption = 'Response Phrase';
            DataClassification = CustomerContent;
        }
        field(10; "Response Message"; Blob)
        {
            Caption = 'Response Message';
            DataClassification = CustomerContent;
            Subtype = Json;
        }
        field(11; "Execution Time"; Duration)
        {
            Caption = 'Execution Time';
            DataClassification = CustomerContent;
        }
        field(12; "Is Success"; Boolean)
        {
            Caption = 'Is Success';
            DataClassification = CustomerContent;
        }
    }
    keys
    {
        key(Key1; "No.")
        {
            Clustered = true;
        }
    }
    procedure SetRequestBody(value: Text)
    var
        OutStream: OutStream;
    begin
        Rec."Request Body".CreateOutStream(OutStream);
        OutStream.WriteText(value);
    end;
    procedure GetRequestBody()BodyTxt: Text var
        InStream: InStream;
    begin
        Clear(BodyTxt);
        Calcfields("Request Body");
        if "Request Body".HasValue()then begin
            "Request Body".CreateInStream(InStream);
            InStream.Read(BodyTxt);
        end;
    end;
    procedure SetResponseMessage(value: Text)
    var
        OutStream: OutStream;
    begin
        Rec."Response Message".CreateOutStream(OutStream);
        OutStream.WriteText(value);
    end;
    procedure GetResponseMessage()BodyTxt: Text var
        InStream: InStream;
    begin
        Clear(BodyTxt);
        Calcfields("Response Message");
        if "Response Message".HasValue()then begin
            "Response Message".CreateInStream(InStream);
            InStream.Read(BodyTxt);
        end;
    end;
}
