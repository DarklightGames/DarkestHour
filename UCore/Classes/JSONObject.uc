//==============================================================================
// Darklight Games (c) 2008-2023
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

function JSONObject Put(string Key, JSONValue Value)
{
    if (Value == none)
    {
        return PutNull(Key);
    }

    if (Map == none)
    {
        Map = new class'TreeMap_string_JSONValue';
    }

    Map.Put(Key, Value);

    return self;
}

function JSONObject PutString(string Key, coerce string Value)
{
    return Put(Key, class'JSONString'.static.Create(Value));
}

function JSONObject PutInteger(string Key, int Value)
{
    return Put(Key, class'JSONNumber'.static.Create(string(Value)));
}

function JSONObject PutBoolean(string Key, bool Value)
{
    return Put(Key, class'JSONLiteral'.static.CreateBoolean(Value));
}

function JSONObject PutFloat(string Key, float Value)
{
    return Put(Key, class'JSONNumber'.static.Create(string(Value)));
}

function JSONObject PutVector(string Key, vector Value)
{
    return Put(Key, class'JSONArray'.static.FromVector(Value));
}

function JSONObject PutNull(string Key)
{
    return Put(Key, class'JSONLiteral'.static.CreateNull());
}

function JSONObject PutIVector(string Key, vector Value)
{
    return Put(Key, class'JSONArray'.static.IFromVector(Value));
}

function JSONObject PutArrayValues(string Key, array<JSONValue> Values)
{
    return Put(Key, class'JSONArray'.static.FromValues(Values));
}

function JSONObject PutArraySerializables(string Key, array<JSONSerializable> Serializables)
{
    return Put(Key, class'JSONArray'.static.FromSerializables(Serializables));
}

function JSONObject Erase(string Key)
{
    if (Map != none)
    {
        Map.Erase(Key);
    }

    return self;
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

            Strings[Strings.Length] = "\"" $ GetSanitizedString(Keys[i]) $ "\":" $ V.Encode();
        }

        S $= class'UString'.static.Join(",", Strings);
    }

    S $= "}";

    return S;
}
