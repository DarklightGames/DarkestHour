//==============================================================================
// Copyright (c) Darklight Games.  All rights reserved.
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

    S = new Class'JSONString';
    S.String = Value;

    return S;
}
