//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class Dictionary extends Object;

var DictionaryNode Head;

// This is a global string array used by GetKeys and GetValues.
// Arrays are copied when passed as function arguments, which would be a
// performance nightmare. Since UnrealScript code runs on a single-thread, this
// is safe and more efficient.
var private array<string> Strings;
var private int           Size;

function int GetSize()
{
    return Size;
}

function array<string> GetKeys()
{
    Strings.Length = 0;

    GetKeysStatic(Head);

    return Strings;
}

function array<string> GetValues()
{
    Strings.Length = 0;

    GetValuesStatic(Head);

    return Strings;
}

private function GetKeysStatic(DictionaryNode Node)
{
    if (Node == none)
    {
        return;
    }

    Strings[Strings.Length] = Node.Key;

    if (Node.LHS != none)
    {
        GetKeysStatic(Node.LHS);
    }

    if (Node.RHS != none)
    {
        GetKeysStatic(Node.RHS);
    }
}

private function GetValuesStatic(DictionaryNode Node)
{
    if (Node == none)
    {
        return;
    }

    Strings[Strings.Length] = Node.Value;

    if (Node.LHS != none)
    {
        GetValuesStatic(Node.LHS);
    }

    if (Node.RHS != none)
    {
        GetValuesStatic(Node.RHS);
    }
}

function bool Get(string Key, optional out string Value)
{
    local DictionaryNode Node;

    Node = Head;

    while (Node != none)
    {
        if (Key < Node.Key)
        {
            Node = Node.LHS;
        }
        else if (Key > Node.Key)
        {
            Node = Node.RHS;
        }
        else
        {
            Value = Node.Value;

            return true;
        }
    }

    return false;
}

function Add(string Key, string Value)
{
    if (Head == none)
    {
        Head = new class'DictionaryNode';
        Head.Key = Key;
        Head.Value = Value;
    }
    else
    {
        AddStatic(Head, Key, Value);
    }

    Size += 1;
}

private static function int GetBalance(DictionaryNode Node)
{
    if (Node == none)
    {
        return 0;
    }

    return GetHeight(Node.LHS) - GetHeight(Node.RHS);
}

private static function int GetHeight(DictionaryNode Node)
{
    if (Node == none)
    {
        return 0;
    }

    return Node.Height;
}

private static function DictionaryNode FindMin(DictionaryNode Node)
{
    while (Node.LHS != none)
    {
        Node = Node.LHS;
    }

    return Node;
}

private static function ReplaceNodeInParent(DictionaryNode Node, DictionaryNode S)
{
    if (Node.Parent != none)
    {
        if (Node == Node.Parent.LHS)
        {
            Node.Parent.LHS = S;
        }
        else
        {
            Node.Parent.RHS = S;
        }
    }

    if (S != none)
    {
        S.Parent = Node.Parent;
    }
}

function Erase(string Key)
{
    EraseStatic(Head, Key);

    Size -= 1;
}

//TODO: erasure needs to balance the tree!
static function DictionaryNode EraseStatic(DictionaryNode Node, string Key)
{
    local DictionaryNode Temp;

    if (Node == none)
    {
        return Node;
    }

    if (Key < Node.Key)
    {
        return EraseStatic(Node.LHS, Key);
    }
    else if (Key > Node.Key)
    {
        return EraseStatic(Node.RHS, Key);
    }
    else
    {
        if (Node.LHS == none || Node.RHS == none)
        {
            if (Node.LHS != none)
            {
                Temp = Node.LHS;
            }
            else
            {
                Temp  = Node.RHS;
            }

            if (Temp == none)
            {
                Temp = Node;
                Node = none;
            }
            else
            {
                Node = Temp;
            }
        }
        else if (Node.LHS != none)
        {
            ReplaceNodeInParent(Node, Node.LHS);
        }
        else if (Node.RHS != none)
        {
            ReplaceNodeInParent(Node, Node.RHS);
        }
        else
        {
            ReplaceNodeInParent(Node, none);
        }
    }
}

private static function DictionaryNode RotateRight(DictionaryNode Y)
{
    local DictionaryNode X;
    local DictionaryNode T2;

    X = Y.LHS;
    T2 = X.RHS;

    X.RHS = Y;
    Y.LHS = T2;

    Y.Height = Max(GetHeight(Y.LHS), GetHeight(Y.RHS)) + 1;
    X.Height = Max(GetHeight(X.LHS), GetHeight(X.RHS)) + 1;

    return X;
}

private static function DictionaryNode RotateLeft(DictionaryNode X)
{
    local DictionaryNode Y;
    local DictionaryNode T2;

    Y = X.RHS;
    T2 = Y.LHS;

    Y.LHS = X;
    X.RHS = T2;

    X.Height = Max(GetHeight(X.LHS), GetHeight(X.RHS)) + 1;
    Y.Height = Max(GetHeight(Y.LHS), GetHeight(Y.RHS)) + 1;

    return Y;
}

private static function DictionaryNode AddStatic(DictionaryNode Node, string Key, string Value)
{
    local int Balance;

    if (Key < Node.Key)
    {
        if (Node.LHS != none)
        {
            AddStatic(Node.LHS, Key, Value);
        }
        else
        {
            Node.LHS = new class'DictionaryNode';
            Node.LHS.Parent = Node;
            Node.LHS.Key = Key;
            Node.LHS.Value = Value;
        }
    }
    else if (Key > Node.Key)
    {
        if (Node.RHS != none)
        {
            AddStatic(Node.RHS, Key, Value);
        }
        else
        {
            Node.RHS = new class'DictionaryNode';
            Node.RHS.Parent = Node;
            Node.RHS.Key = Key;
            Node.RHS.Value = Value;
        }
    }
    else
    {
        return none;
    }

    Balance = GetBalance(Node);

    if (Balance > 1 && Key < Node.LHS.Key)
    {
        return RotateRight(Node);
    }
    else if (Balance < -1 && Key > Node.RHS.Key)
    {
        return RotateLeft(Node);
    }
    else if (Balance > 1 && Key > Node.LHS.Key)
    {
        Node.LHS = RotateLeft(Node.LHS);

        return RotateRight(Node);
    }
    else if (Balance  < -1 && Key < Node.RHS.Key)
    {
        Node.RHS = RotateRight(Node.RHS);

        return RotateLeft(Node);
    }

    return Node;
}

