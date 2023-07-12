//==============================================================================
// Darklight Games (c) 2008-2023
//==============================================================================

class ArrayList_string extends Object;

var array<string> Items;

function Add(string Item)
{
    Items[Items.Length] = Item;
}

function AddAtIndex(int Index, string Item)
{
    Items.Insert(Index, 1);

    Items[Index] = Item;
}

function Clear()
{
    Items.Length = 0;
}

function bool Contains(string Item)
{
    return IndexOf(Item) != -1;
}

function string Get(int Index)
{
    return Items[Index];
}

function int IndexOf(string Item)
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

function int LastIndexOf(string Item)
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

function Remove(int Index)
{
    Items.Remove(Index, 1);
}

function RemoveRange(int FromIndex, int ToIndex)
{
    local int Count;

    Count = ToIndex - FromIndex + 1;

    Items.Remove(FromIndex, Count);
}

function Resize(int Length)
{
    Items.Length = Length;
}

function Set(int Index, string Item)
{
    Items[Index] = Item;
}

function int Size()
{
    return Items.Length;
}

function array<string> ToArray()
{
    return Items;
}

function ArrayList_string Sort()
{
    QuickSort(0, Items.Length - 1);

    return self;
}

private function QuickSort(int Lo, int Hi)
{
    local int p;

    if (Lo < Hi)
    {
        p = QuickSortPartition(Lo, Hi);
        QuickSort(Lo, p);
        QuickSort(p + 1, Hi);
    }
}

private function int QuickSortPartition(int Lo, int Hi)
{
    local string Pivot;
    local int i, j;

    Pivot = Items[Lo];
    i = Lo - 1;
    j = Hi + 1;

    while (true)
    {
        while (Items[++i] < Pivot)
        {
        }

        while (Items[--j] > Pivot)
        {
        }

        if (i >= j)
        {
            return j;
        }

        class'UCore'.static.SSwap(Items[i], Items[j]);
    }
}
