class Stack extends Object
    template(ItemType);

var private array<ItemType> Items;

function ItemType Peek()
{
    return Items[Items.Length - 1];
}

function Push(ItemType Item)
{
    Items[Items.Length] = S;
}

function int Search(ItemType Item)
{
    local int i;

    for (i = 1; i <= Items.Length; ++i)
    {
        if (Items[Items.Length - i] == Item)
        {
            return i;
        }
    }

    return -1;
}

function ItemType Pop()
{
    Items.Length = Items.Length - 1;
}

function int Size()
{
    return Items.Length;
}