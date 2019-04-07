//==============================================================================
// Darklight Games (c) 2008-2019
//==============================================================================

class JSONString extends JSONValue;

var string String;

function bool IsString()
{
    return true;
}

function string AsString()
{
    return String;
}

function int AsInteger()
{
    return int(String);
}

function string Encode()
{
    return "\"" $ String $ "\"";
}

function bool AsBoolean()
{
    if (String ~= "true")
    {
        return true;
    }

    return false;
}

static function JSONString Create(string Value)
{
    local JSONString S;

    S = new class'JSONString';
    S.String = Value;

    return S;
}
