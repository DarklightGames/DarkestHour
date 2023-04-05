//==============================================================================
// Darklight Games (c) 2008-2023
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
    return "\"" $ GetSanitizedString(String) $ "\"";
}

function bool AsBoolean()
{
    if (String ~= "true")
    {
        return true;
    }

    return false;
}

static function JSONString Create(coerce string Value)
{
    local JSONString S;

    S = new class'JSONString';
    S.String = Value;

    return S;
}
