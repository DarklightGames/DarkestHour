//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class Dictionary extends Object;

var private DictionaryNode Head;
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

    GetKeysTraverse(Head);

    return Strings;
}

private function GetKeysTraverse(DictionaryNode Node)
{
    if (Node == none)
    {
        return;
    }

    Strings[Strings.Length] = Node.Key;

    if (Node.LHS != none)
    {
        GetKeysTraverse(Node.LHS);
    }

    if (Node.RHS != none)
    {
        GetKeysTraverse(Node.RHS);
    }
}

function array<string> GetValues()
{
    Strings.Length = 0;

    GetValuesTraverse(Head);

    return Strings;
}

private function GetValuesTraverse(DictionaryNode Node)
{
    if (Node == none)
    {
        return;
    }

    Strings[Strings.Length] = Node.Value;

    if (Node.LHS != none)
    {
        GetValuesTraverse(Node.LHS);
    }

    if (Node.RHS != none)
    {
        GetValuesTraverse(Node.RHS);
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

function Put(string Key, string Value)
{
    Head = PutStatic(self, Head, Key, Value);
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

function Erase(string Key)
{
    Head = EraseStatic(self, Head, Key);
}

private static function DictionaryNode EraseStatic(Dictionary D, DictionaryNode Node, string Key)
{
    local int Balance;
    local DictionaryNode Temp;

    if (Node == none)
    {
        return Node;
    }

    if (Key < Node.Key)
    {
        Node.LHS = EraseStatic(D, Node.LHS, Key);
    }
    else if (Key > Node.Key)
    {
        Node.RHS = EraseStatic(D, Node.RHS, Key);
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
                Temp = Node.RHS;
            }

            if (Temp == none)
            {
                Temp = Node;
                Node = none;
            }
            else
            {
                Node.Key = Temp.Key;
                Node.Value = Temp.Value;
                Node.LHS = Temp.LHS;
                Node.RHS = Temp.RHS;
                Node.Height = Temp.Height;
            }

            D.Size -= 1;
        }
        else
        {
            Temp = FindMin(Node.RHS);

            Node.Key = Temp.Key;
            Node.RHS = EraseStatic(D, Node.RHS, Temp.Key);
        }
    }

    if (Node == none)
    {
        return none;
    }

    Node.Height = Max(GetHeight(Node.LHS), GetHeight(Node.RHS)) + 1;

    Balance = GetBalance(Node);

    if (Balance > 1 && GetBalance(Node.LHS) >= 0)
    {
        return RotateRight(Node);
    }
    else if (Balance > 1 && GetBalance(Node.LHS) < 0)
    {
        Node.LHS = RotateLeft(Node.LHS);

        return RotateRight(Node);
    }
    else if (Balance < -1 && GetBalance(Node.RHS) <= 0)
    {
        return RotateLeft(Node);
    }
    else if (Balance < -1 && GetBalance(Node.RHS) > 0)
    {
        Node.RHS = RotateRight(Node.RHS);

        return RotateLeft(Node);
    }

    return Node;
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

private static function DictionaryNode PutStatic(Dictionary D, DictionaryNode Node, string Key, string Value)
{
    local int Balance;

    if (Node == none)
    {
        Node = new class'DictionaryNode';
        Node.Key = Key;
        Node.Value = Value; //TODO: not needed??

        D.Size += 1;

        return Node;
    }

    if (Key < Node.Key)
    {
        Node.LHS = PutStatic(D, Node.LHS, Key, Value);
    }
    else if (Key > Node.Key)
    {
        Node.RHS = PutStatic(D, Node.RHS, Key, Value);
    }
    else
    {
        Node.Value = Value;

        return Node;
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

