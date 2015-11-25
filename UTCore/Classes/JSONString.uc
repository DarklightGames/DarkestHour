//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================
// Implementation is based on minimal-json (github.com/ralfstx/minimal-json)
//==============================================================================

class JSONString extends JSONValue
    abstract;

var string String

function bool IsString()
{
    return true;
}

function string AsString()
{
    return String;
}

