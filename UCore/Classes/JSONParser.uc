//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================
// Implementation is based on minimal-json (github.com/ralfstx/minimal-json)
//==============================================================================

class JSONParser extends Object;

var private StringBuffer InputBuffer;

function JSONValue Parse(string S)
{
    InputBuffer = new class'StringBuffer';
    InputBuffer.Write(S);

    return ReadValue();
}

function JSONArray ParseArray(string S)
{
    local JSONValue ParseValue;

    ParseValue = Parse(S);

    if (ParseValue != none)
    {
        return ParseValue.AsArray();
    }

    return none;
}

function JSONObject ParseObject(string S)
{
    local JSONValue ParseValue;

    ParseValue = Parse(S);

    if (ParseValue != none)
    {
        return ParseValue.AsObject();
    }

    return none;
}

function JSONValue ReadValue()
{
    switch (InputBuffer.Peek(1))
    {
        case "n":
            return ReadNull();
        case "f":
            return ReadFalse();
        case "t":
            return ReadTrue();
        case "{":
            return ReadObject();
        case "[":
            return ReadArray();
        case "\"":
            return ReadString();
        case "-":
        case "0":
        case "1":
        case "2":
        case "3":
        case "4":
        case "5":
        case "6":
        case "7":
        case "8":
        case "9":
            return ReadNumber();
        default:
            return none;
    }
}

function JSONLiteral ReadNull()
{
    if (InputBuffer.Read(4) == "null")
    {
        return class'JSONLiteral'.static.Create("null");
    }
    else
    {
        ParseError("Unexpected literal");

        return none;
    }
}

function JSONLiteral ReadFalse()
{
    if (InputBuffer.Read(5) == "false")
    {
        return class'JSONLiteral'.static.Create("false");
    }
    else
    {
        ParseError("Unexpected literal");

        return none;
    }
}

function JSONLiteral ReadTrue()
{
    if (InputBuffer.Read(4) == "true")
    {
        return class'JSONLiteral'.static.Create("true");
    }
    else
    {
        ParseError("Unexpected literal");

        return none;
    }
}

//BUGS:
// [3,] - invalid array, but parsed as valid
function JSONArray ReadArray()
{
    local JSONArray A;
    local JSONValue Value;
    local string C;

    if (InputBuffer.Read(1) != "[")
    {
        ParseError("Unexpected character");

        return none;
    }

    A = new class'JSONArray';
    A.Values = new class'ArrayList_JSONValue';

    while (true)
    {
        SkipWhiteSpace();

        C = InputBuffer.Peek(1);

        if (C == "]")
        {
            InputBuffer.Seekg(SEEK_Current, 1);

            break;
        }

        Value = ReadValue();

        if (Value == none)
        {
            return none;
        }

        A.Add(Value);

        SkipWhiteSpace();

        C = InputBuffer.Read(1);

        if (C == ",")
        {
            continue;
        }
        else if (C == "]")
        {
            break;
        }
        else
        {
            ParseError("Unexpected character '" $ C $ "'");

            return none;
        }
    }

    return A;
}

function JSONObject ReadObject()
{
    local string C;
    local string Key;
    local JSONValue Value;
    local JSONObject O;

    if (InputBuffer.Read(1) != "{")
    {
        ParseError("Unexpected character");

        return none;
    }

    O = new class'JSONObject';

    if (InputBuffer.Peek(1) == "}")
    {
        InputBuffer.Seekg(SEEK_Current, 1);

        return O;
    }

    while (true)
    {
        SkipWhiteSpace();

        if (ReadStringInternal(Key) == -1)
        {
            return none;
        }

        SkipWhiteSpace();

        C = InputBuffer.Read(1);

        if (C != ":")
        {
            ParseError("Unexpected character");

            return none;
        }

        SkipWhiteSpace();

        Value = ReadValue();

        if (Value == none)
        {
            return none;
        }

        O.Put(Key, Value);

        SkipWhiteSpace();

        C = InputBuffer.Read(1);

        if (C == ",")
        {
            continue;
        }
        else if (C == "}")
        {
            break;
        }
        else
        {
            ParseError("Unexpected character");

            return none;
        }
    }

    return O;
}

function JSONString ReadString()
{
    local string S;

    if (ReadStringInternal(S) == -1)
    {
        return none;
    }

    return class'JSONString'.static.Create(S);
}

function string ReadEscape()
{
    local string C;

    C = InputBuffer.Read(1);

    switch (C)
    {
        case "\"":
        case "/":
        case "\\":
            return C;
        case "b":   // Backspace
            return Chr(0x08);
        case "f":   // Form feed
            return Chr(0x0C);
        case "n":   // Line feed
            return Chr(0x0A);
        case "r":   // Carriage return
            return Chr(0x0D);
        case "t":   // Tab
            return Chr(0x09);
        case "u":   // Unicode character (eg. \u0820)
            return Chr(class'UInteger'.static.FromHex(InputBuffer.Read(4)));
    }
}

function int ReadStringInternal(out string S)
{
    local string C;

    S = "";

    if (InputBuffer.Read(1) != "\"")
    {
        return -1;
    }

    while (true)
    {
        C = InputBuffer.Read(1);

        if (C == "\"")
        {
            break;
        }
        else if (C == "\\")
        {
            S $= ReadEscape();
        }
        else if (C == "")
        {
            // EOF
            return -1;
        }
        else
        {
            S $= C;
        }
    }

    return Len(S);
}

private function SkipWhiteSpace()
{
    while (true)
    {
        if (class'UString'.static.IsWhitespace(InputBuffer.Peek(1)))
        {
            InputBuffer.Seekg(SEEK_Current, 1);
        }
        else
        {
            return;
        }
    }
}

private function JSONNumber ReadNumber()
{
    local string S;
    local string T;

    // Peek negative sign?
    T = InputBuffer.Peek(1);

    if (T == "-")
    {
        InputBuffer.Seekg(SEEK_Current, 1);

        S $= T;
    }

    // Read digits
    T = ReadDigits();

    if (Len(T) == 0)
    {
        ParseError("Expected digits");

        return none;
    }

    S $= T;

    T = InputBuffer.Peek(1);

    switch (T)
    {
        case ".":
            InputBuffer.Seekg(SEEK_Current, 1);
            S $= T $ ReadDigits();
            break;
        case "e":
        case "E":
            //TODO: fill this in
            break;
        default:
            break;
    }

    return class'JSONNumber'.static.Create(S);
}

private function string ReadDigits()
{
    local string S;
    local string T;

    // Read digits
    while (true)
    {
        T = InputBuffer.Peek(1);

        if (IsDigit(T))
        {
            S $= T;

            InputBuffer.Read(1);
        }
        else
        {
            break;
        }
    }

    return S;
}

private static function bool IsDigit(string S)
{
    local int A;

    A = Asc(S);

    return A >= 0x30 && A <= 0x39;
}

function ParseError(coerce string S)
{
    Warn(S @ "(" $ InputBuffer.Tellg() $ ")");
}
