table 50200 "ZATCA API Log"
{
    Caption = 'API Log';
    DataClassification = CustomerContent;
    DataPerCompany = true;
    PasteIsValid = false;

    fields
    {
        field(50200; "No."; Integer)
        {
            AutoIncrement = true;
            Caption = 'No.';
            DataClassification = CustomerContent;
        }
        field(50201; "Request Date"; Date)
        {
            Caption = 'Request Date';
            DataClassification = CustomerContent;
        }
        field(50202; "Request Time"; Time)
        {
            Caption = 'Request Time';
            DataClassification = CustomerContent;
        }
        field(50203; "User"; Text[150])
        {
            Caption = 'User';
            DataClassification = CustomerContent;
        }
        field(50204; "Request URL"; Text[1024])
        {
            Caption = 'Request URL';
            DataClassification = CustomerContent;
            ExtendedDatatype = URL;
        }
        field(50205; "Request Method";Enum "Http Request Type")
        {
            Caption = 'Request Method';
            DataClassification = CustomerContent;
        }
        field(50206; "Request Body"; Blob)
        {
            Caption = 'Request Body';
            DataClassification = CustomerContent;
            Subtype = Json;
        }
        field(50207; "Response Code"; Integer)
        {
            Caption = 'Response Code';
            DataClassification = CustomerContent;
        }
        field(50208; "Response Phrase"; Text[1024])
        {
            Caption = 'Response Phrase';
            DataClassification = CustomerContent;
        }
        field(50209; "Response Message"; Blob)
        {
            Caption = 'Response Message';
            DataClassification = CustomerContent;
            Subtype = Json;
        }
        field(50210; "Execution Time"; Duration)
        {
            Caption = 'Execution Time';
            DataClassification = CustomerContent;
        }
        field(50211; "Is Success"; Boolean)
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
