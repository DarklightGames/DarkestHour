//==============================================================================
// Darklight Games (c) 2008-2023
//==============================================================================

class JSONArray extends JSONValue;

var ArrayList_JSONValue Values;

function int Size()
{
    return Values.Size();
}

function bool IsArray()
{
    return true;
}

function JSONArray AsArray()
{
    return self;
}

function string Encode()
{
    local int i;
    local string S;

    S = "[";

    if (Values != none)
    {
        for (i = 0; i < Values.Size(); ++i)
        {
            S $= Values.Get(i).Encode();

            if (i < Values.Size() - 1)
            {
                S $= ",";
            }
        }
    }

    S $= "]";

    return S;
}

function Add(JSONValue Item)
{
    Values.Add(Item);
}

function AddString(coerce string Value)
{
    Add(class'JSONString'.static.Create(Value));
}

function AddInt(int Value)
{
    Add(class'JSONNumber'.static.Create(string(Value)));
}

function AddFloat(float Value)
{
    Add(class'JSONNumber'.static.Create(string(Value)));
}

function AddAtIndex(int Index, JSONValue Item)
{
    Values.AddAtIndex(Index, Item);
}

function JSONValue Get(int Index)
{
    return Values.Get(Index);
}

static function JSONArray Create()
{
    local JSONArray A;

    A = new class'JSONArray';
    A.Values = new class'ArrayList_JSONValue';

    return A;
}

static function JSONArray FromVector(vector V)
{
    local JSONArray A;

    A = Create();
    A.Add(class'JSONNumber'.static.FCreate(V.X));
    A.Add(class'JSONNumber'.static.FCreate(V.Y));
    A.Add(class'JSONNumber'.static.FCreate(V.Z));

    return A;
}

static function JSONArray IFromVector(vector V)
{
    local JSONArray A;

    A = Create();
    A.Add(class'JSONNumber'.static.ICreate(V.X));
    A.Add(class'JSONNumber'.static.ICreate(V.Y));
    A.Add(class'JSONNumber'.static.ICreate(V.Z));

    return A;
}

static function JSONArray FromStrings(array<string> Strings)
{
    local int i;
    local JSONArray A;

    A = Create();

    for (i = 0; i < Strings.Length; ++i)
    {
        A.AddString(Strings[i]);
    }

    return A;
}

static function JSONArray FromValues(array<JSONValue> Values)
{
    local int i;
    local JSONArray A;

    A = Create();

    for (i = 0; i < Values.Length; ++i)
    {
        A.Add(Values[i]);
    }

    return A;
}

static function JSONArray FromSerializables(array<JSONSerializable> Serializables)
{
    local int i;
    local JSONArray A;

    A = Create();

    for (i = 0; i < Serializables.Length; ++i)
    {
        A.Add(Serializables[i].ToJSON());
    }

    return A;
}

