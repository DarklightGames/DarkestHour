//==============================================================================
// Darklight Games (c) 2008-2023
//==============================================================================

class HashtableIterator_string_Object extends Object;

var int i;
var Hashtable_string_Object Hashtable;

function Begin()
{
    i = 0;
}

function bool Next(optional out string Key, optional out Object Value)
{
    while (i < Hashtable.Keys.Length)
    {
        if (Hashtable.Keys[i] != "")
        {
            Key = Hashtable.Keys[i];
            Value = Hashtable.Values[i];
            ++i;
            return true;
        }

        ++i;
    }

    return false;
}

function bool Peek(optional out string Key, optional out Object Value)
{
    while (i < Hashtable.Keys.Length)
    {
        if (Hashtable.Keys[i] != "")
        {
            Key = Hashtable.Keys[i];
            Value = Hashtable.Values[i];
            return true;
        }

        ++i;
    }

    return false;
}
