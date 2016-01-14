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

    for (i = 0; i < Values.Size(); ++i)
    {
        Strings[Strings.Length] = Values.Get(i).Encode();
    }

    return "[" $ class'UString'.static.Join(",", Strings) $ "]";
}

static function JSONArray Create()
{
    local JSONArray A;

    A = new class'JSONArray';
    A.Values = new class'ArrayList_JSONValue';

    return A;
}
