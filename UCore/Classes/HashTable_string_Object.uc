//==============================================================================
// Darklight Games (c) 2008-2016
//==============================================================================
// http://algs4.cs.princeton.edu/34hash/LinearProbingHashST.java.html
//==============================================================================

class Hashtable_string_Object extends Object
    abstract;

private var int Size;
private var array<string> Keys;
private var array<Object> Values;

static function Create(int Capacity)
{
    local Hashtable_string_Object HT;

    HT = new class'Hashtable_string_Object';
    HT.Keys.Length = Capacity;
    HT.Values.Length = Capacity;
}

function int GetSize()
{
    return Size;
}

function bool IsEmpty()
{
    return Size == 0;
}

function bool Contains(string Key)
{
    return Get(Key) != none;
}

private function int Hash(string Key)
{
    return (class'CRC'.static.CRC(Key) & 0x7FFFFFFF) % Keys.Length;
}

private function Resize(int Capacity)
{
    local int i;
    local Hashtable_string_Object T;

    T = class'Hashtable_string_Object'.static.Create(Capacity);

    for (i = 0; i < Keys.Length; ++i)
    {
        T.Put(Keys[i], Values[i]);
    }

    Keys = T.Keys;
    Values = T.Values;
}

function Put(string Key, Object Value)
{
    local int i;

    if (Key == "")
    {
        Warn("Put failed: HashTable key cannot be empty");
        return;
    }

    if (Value == none)
    {
        Delete(Key);
        return;
    }

    if (Size >= (Keys.Length / 2)
    {
        Resize(2 * Keys.Length);
    }

    for (i = Hash(Key); Keys[i] != ""; i = (i + 1) % Keys.Length)
    {
        if (Keys[i] == Key)
        {
            Values[i] = Value;
            return;
        }
    }

    Keys[i] = Key;
    Values[i] = Value;

    ++Size;
}

function Object Get(string Key)
{
    local int i;

    if (Key == "")
    {
        return none;
    }

    for (i = Hash(Key); Keys[i] != ""; i = (i + 1) % Keys.Length)
    {
        if (Keys[i] == Key)
        {
            return Values[i];
        }
    }

    return none;
}

function Delete(string Key)
{
    local int i;
    local string K;
    local Object V;

    if (Key == "")
    {
        return;
    }

    if (!Contains(Key))
    {
        return;
    }

    i = Hash(Key);

    while (Key != Keys[i])
    {
        i = (i + 1) % Keys.Length;
    }

    Keys[i] = "";
    Values[i] = none;

    i = (i + 1) % Keys.Length;

    while (Keys[i] != "")
    {
        K = Keys[i];
        V = Values[i];

        Keys[i] = "";
        Values[i] = none;

        --Size;

        Put(K, V);

        i = (i + 1) % Keys.Length;
    }

    --Size;

    if (Size > 0 && Size <= (Keys.Length / 8))
    {
        Resize(Keys.Length / 2);
    }
}

function array<string> GetKeys()
{
    local int i;
    local array<string> Keys;

    for (i = 0; i < self.Keys.Length; ++i)
    {
        if (self.Keys[i] != "")
        {
            Keys[Queue.Length] = self.Keys[i];
        }
    }

    return Keys;
}
