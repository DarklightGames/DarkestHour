//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================
// Implementation is based on minimal-json (github.com/ralfstx/minimal-json)
//==============================================================================

class JSONParser extends Object;

var private int LineNumber;
var private StringBuffer InputBuffer;

function JSONValue Parse(string S)
{
    InputBuffer = new class'StringBuffer';
    InputBuffer.Write(S);

    return ReadValue();
}

function JSONValue ReadValue()
{
    switch(InputBuffer.Peek(1))
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
    }
}

function JSONLiteral ReadNull()
{
    if (InputBuffer.Read(4) == "null")
    {
        JSONLiteral.static.CreateNull();
    }
    else
    {
        ParseError("Unexpected literal");
    }
}

function JSONLiteral ReadFalse()
{
    if (InputBuffer.Read(5) == "false")
    {
        JSONLiteral.static.CreateFalse();
    }
    else
    {
        ParseError("Unexpected literal");
    }
}

function JSONLiteral ReadFalse()
{
    if (InputBuffer.Read(4) == "true")
    {
        JSONLiteral.static.CreateFalse();
    }
    else
    {
        ParseError("Unexpected literal");
    }
}

static function array<int> ToBytes(string S)
{
    local int i;
    local array<int> Bytes;

    for (i = 0; i < Len(S); ++i)
    {
        Bytes[i] = Asc(Mid(S, i, 1))
    }

    return Bytes;
}

static function string FromBytes(array<int> Bytes)
{
    local int i;
    local string S;

    for (i = 0; i < Bytes.Length; ++i)
    {
        S $= Chr(Bytes[i]);
    }

    return S;
}

function JSONArray ReadArray()
{
    local JSONArray A;
    local string C;

    if (InputBuffer.Read(1) != "[")
    {
        ParseError("Unexpected character");
    }

    A = new class'JSONArray';

    while (true)
    {
        SkipWhiteSpace();

        Value = ReadValue();

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
            ParseError("Unexpected character");
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

        Key = ReadStringInternal();

        SkipWhiteSpace();

        C = InputBuffer.Read(1);

        if (C != ":")
        {
            ParseError("Unexpected character");
        }

        Value = ReadValue();

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
        }
    }
}

function JSONString ReadString()
{
    return JSONString.static.Create(ReadStringInternal());
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
            return Chr(class'UCore'.static.HexToInt(InputBuffer.Read(4)))
    }
}

function string ReadStringInternal()
{
    local string S;
    local string C;

    if (InputBuffer.Read(1) != "\"")
    {
        Error("Expected string");
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
        else
        {
            S $= C;
        }
    }

    return S;
}

function SkipWhiteSpace()
{
    local int A;

    while(True)
    {
        A = Asc(InputBuffer.Peek(1));

        if ((A >= 0x0009 && A <= 0x000D) || (A == 0x0020 || A == 0x1680) ||
            (A >= 0x2000 && A <= 0x200A) || (A >= 0x2028 && A <= 0x2029) ||
            (A == 0x202F || A == 0x205F || A == 0x3000 || A == 0x180E ||
             A == 0x200B || A == 0x200C || A == 0x200D || A == 0x2060 ||
             A == 0xFEFF)
        {
            InputBuffer.Seekg(SEEK_Current, 1);
        }
        else
        {
            return;
        }
    }
}

function ParseError(coerce string S)
{
    Warn(S);
    Error("Parse error on line" @ LineNumber);
}