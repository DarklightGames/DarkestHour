//==============================================================================
// Darklight Games (c) 2008-2015
//==============================================================================

class JSONObject extends JSONValue;

var private TreeMap_string_JSONValue Map;

function bool IsObject()
{
    return true;
}

function JSONObject AsObject()
{
    return self;
}

function JSONValue Get(string Key)
{
    local JSONValue Value;

    if (Map != none)
    {
        Map.Get(Key, Value);
    }

    return Value;
}

function Put(string Key, JSONValue Value)
{
    if (Map == none)
    {
        Map = new class'TreeMap_string_JSONValue';
    }

    Map.Put(Key, Value);
}

function Erase(string Key)
{
    if (Map != none)
    {
        Map.Erase(Key);
    }
}

function array<string> GetKeys()
{
    local array<string> Empty;

    if (Map != none)
    {
        return Map.GetKeys();
    }
    else
    {
        return Empty;
    }
}

function string Encode()
{
    local int i;
    local string S;
    local array<string> Keys;
    local JSONValue V;
    local array<string> Strings;

    S $= "{";

    if (Map != none)
    {
        Keys = Map.GetKeys();

        for (i = 0; i < Keys.Length; ++i)
        {
            Map.Get(Keys[i], V);

            Strings[Strings.Length] = "\"" $ Keys[i] $ "\":" $ V.Encode();
        }

        S $= class'UString'.static.Join(",", Strings);
    }

    S $= "}";

    return S;
}
