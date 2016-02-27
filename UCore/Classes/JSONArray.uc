//==============================================================================
// Darklight Games (c) 2008-2015
//==============================================================================

class JSONArray extends JSONValue;

var ArrayList_JSONValue Values;

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
            Log(Values.Get(i).Encode());

            Strings[Strings.Length] = Values.Get(i).Encode();
        }
    }

    return "[" $ class'UString'.static.Join(",", Strings) $ "]";
}

function Add(JSONValue Item)
{
    if (Values == none)
    {
        Values = new class'ArrayList_JSONValue';
    }

    Values.Add(Item);
}

function AddAtIndex(int Index, JSONValue Item)
{
    if (Values == none)
    {
        Values = new class'ArrayList_JSONValue';
    }

    Values.AddAtIndex(Index, Item);
}

static function JSONArray VCreate(vector V)
{
    local JSONArray A;

    A = new class'JSONArray';
    A.Add(class'JSONNumber'.static.FCreate(V.X));
    A.Add(class'JSONNumber'.static.FCreate(V.X));
    A.Add(class'JSONNumber'.static.FCreate(V.X));

    return A;
}
