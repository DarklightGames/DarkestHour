//==============================================================================
// Darklight Games (c) 2008-2023
//==============================================================================

class Stack_Object extends Object;

var array<Object> Items;

function Push(Object Item)
{
    Items[Items.Length] = Item;
}

function Object Peek()
{
    if (Items.Length > 0)
    {
        return Items[Items.Length - 1];
    }

    return none;
}

function Object Pop()
{
    local Object P;

    if (Items.Length > 0)
    {
        P = Items[Items.Length - 1];
        Items.Length = Items.Length - 1;
    }

    return P;
}

function Clear()
{
    Items.Length = 0;
}

function bool Contains(Object Item)
{
    return IndexOf(Item) != -1;
}

function int IndexOf(Object Item)
{
    local int i;

    for (i = 0; i < Items.Length; ++i)
    {
        if (Items[i] == Item)
        {
            return i;
        }
    }

    return -1;
}

function bool IsEmpty()
{
    return Items.Length == 0;
}

function int LastIndexOf(Object Item)
{
    local int i;

    for (i = Items.Length - 1; i >= 0; --i)
    {
        if (Items[i] == Item)
        {
            return i;
        }
    }

    return -1;
}

function int Size()
{
    return Items.Length;
}

function array<Object> ToArray()
{
    return Items;
}

