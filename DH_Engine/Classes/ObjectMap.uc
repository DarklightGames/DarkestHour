//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class ObjectMap extends Object;

struct Pair
{
    var string Key;
    var Object Value;
};

var private array<Pair> Pairs;

function bool Insert(string Key, Object Value)
{
    local Pair P;
    local int i;

    for (i = 0; i < Pairs.Length; ++i)
    {
        if (Pairs[i].Key == Key)
        {
            //Replace previous value
            Pairs[i].Value = Value;

            return true;
        }
    }

    P.Key = Key;
    P.Value = Value;

    Pairs[Pairs.Length] = P;

    return true;
}

function Object Get(string Key)
{
    local int i;

    for (i = 0; i < Pairs.Length; ++i)
    {
        if (Pairs[i].Key == Key)
        {
            return Pairs[i].Value;
        }
    }

    return none;
}

defaultproperties
{
}
