//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================
// Implementation is based on minimal-json (github.com/ralfstx/minimal-json)
//==============================================================================

class JSONNumber extends JSONValue;

var private string Value;

function bool IsNumber()
{
    return true;
}

function JSONNumber AsNumber()
{
    return self;
}

function string AsString()
{
    return Value;
}

function float AsInt()
{
    return int(Value);
}

function float AsFloat()
{
    return float(Value);
}