//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================
// Implementation is based on minimal-json (github.com/ralfstx/minimal-json)
//==============================================================================

class JSONObject extends JSONValue;

var private Dictionary<string, JSONValue> Values;

function bool IsString()
{
    return true;
}

function string AsString()
{
    return String;
}

function JSONValue Get(string Key)
{
    return Values.Get(Key);
}

function Put(string Key, JSONValue)
{
    return Values.Put(Key, Value);
}

function AddString(string Key, string Value)
{
    Values.Add(Key, JSONString.static.Create(Value));
}

function AddInt(string Key, int Value)
{
    Values.Add(Key, JSONNumber.static.CreateInt(Value));
}

function AddFloat(string Key, float Value)
{
    Values.Add(Key, JSONNumber.static.CreateFloat(Value));
}

function AddValue(string Key, JSONValue Value)
{
    Values.Add(Key, Value);
}