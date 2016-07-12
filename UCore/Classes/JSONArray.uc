//==============================================================================
// Darklight Games (c) 2008-2016
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
    local array<string> Strings;

    if (Values != none)
    {
        for (i = 0; i < Values.Size(); ++i)
        {
            Strings[Strings.Length] = Values.Get(i).Encode();
        }
    }

    return "[" $ class'UString'.static.Join(",", Strings) $ "]";
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

static function JSONArray CreateFromVector(vector V)
{
    local JSONArray A;

    A = Create();
    A.Add(class'JSONNumber'.static.FCreate(V.X));
    A.Add(class'JSONNumber'.static.FCreate(V.X));
    A.Add(class'JSONNumber'.static.FCreate(V.X));

    return A;
}

static function JSONArray CreateFromStringArray(array<string> Strings)
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

static function JSONArray CreateFromSerializableArray(array<JSONSerializable> Serializables)
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
