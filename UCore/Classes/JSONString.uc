//==============================================================================
// Darklight Games (c) 2008-2016
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

function string Encode()
{
    return "\"" $ String $ "\"";
}

static function JSONString Create(string Value)
{
    local JSONString S;

    S = new class'JSONString';
    S.String = Value;

    return S;
}
