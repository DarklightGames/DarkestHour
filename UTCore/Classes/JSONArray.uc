//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================
// Implementation is based on minimal-json (github.com/ralfstx/minimal-json)
//==============================================================================

class JSONArray extends JSONValue;

var private array<JSONValue> Values;

function bool IsArray()
{
    return true;
}

function JSONArray AsArray()
{
    return self;
}

function JSONValue At(int Index)
{
    return Values[Index];
}

function Add(JSONValue Value)
{
    Values[Values.Length] = Value;
}

function Remove(int Index)
{
    Values.Remove(Index, 1)
}

function Clear()
{
    Values.Length = 0;
}

function int Length()
{
    return Values.Length;
}