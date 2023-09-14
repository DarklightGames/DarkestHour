//==============================================================================
// Darklight Games (c) 2008-2023
//==============================================================================

class TreeMap_string_string extends Object;

var private TreeMapNode_string_string Head;
var private array<string> Keys;
var private array<string> Values;
var private int Size;
var private string RecursiveKey;
var private string RecursiveValue;

function int GetSize()
{
    return Size;
}

function array<string> GetKeys()
{
    Keys.Length = 0;

    GetKeysTraverse(Head);

    return Keys;
}

private function GetKeysTraverse(TreeMapNode_string_string Node)
{
    if (Node == none)
    {
        return;
    }

    Keys[Keys.Length] = Node.Key;

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
    Values.Length = 0;

    GetValuesTraverse(Head);

    return Values;
}

private function GetValuesTraverse(TreeMapNode_string_string Node)
{
    if (Node == none)
    {
        return;
    }

    Values[Values.Length] = Node.Value;

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
    local TreeMapNode_string_string Node;

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
    RecursiveKey = Key;
    RecursiveValue = Value;

    Head = PutStatic(self, Head);
}

private static function int GetBalance(TreeMapNode_string_string Node)
{
    if (Node == none)
    {
        return 0;
    }

    return GetHeight(Node.LHS) - GetHeight(Node.RHS);
}

private static function int GetHeight(TreeMapNode_string_string Node)
{
    if (Node == none)
    {
        return 0;
    }

    return Node.Height;
}

private static function TreeMapNode_string_string FindMin(TreeMapNode_string_string Node)
{
    while (Node.LHS != none)
    {
        Node = Node.LHS;
    }

    return Node;
}

function Erase(string Key)
{
    RecursiveKey = Key;
    Head = EraseStatic(self, Head);
}

private static function TreeMapNode_string_string EraseStatic(TreeMap_string_string D, TreeMapNode_string_string Node)
{
    local int Balance;
    local TreeMapNode_string_string Temp;

    if (Node == none)
    {
        return Node;
    }

    if (D.RecursiveKey < Node.Key)
    {
        Node.LHS = EraseStatic(D, Node.LHS);
    }
    else if (D.RecursiveKey > Node.Key)
    {
        Node.RHS = EraseStatic(D, Node.RHS);
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
            Node.Value = Temp.Value;

            D.RecursiveKey = Temp.Key;

            Node.RHS = EraseStatic(D, Node.RHS);
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

private static function TreeMapNode_string_string RotateRight(TreeMapNode_string_string Y)
{
    local TreeMapNode_string_string X;
    local TreeMapNode_string_string T2;

    X = Y.LHS;
    T2 = X.RHS;

    X.RHS = Y;
    Y.LHS = T2;

    Y.Height = Max(GetHeight(Y.LHS), GetHeight(Y.RHS)) + 1;
    X.Height = Max(GetHeight(X.LHS), GetHeight(X.RHS)) + 1;

    return X;
}

private static function TreeMapNode_string_string RotateLeft(TreeMapNode_string_string X)
{
    local TreeMapNode_string_string Y;
    local TreeMapNode_string_string T2;

    Y = X.RHS;
    T2 = Y.LHS;

    Y.LHS = X;
    X.RHS = T2;

    X.Height = Max(GetHeight(X.LHS), GetHeight(X.RHS)) + 1;
    Y.Height = Max(GetHeight(Y.LHS), GetHeight(Y.RHS)) + 1;

    return Y;
}

private static function TreeMapNode_string_string PutStatic(TreeMap_string_string D, TreeMapNode_string_string Node)
{
    local int Balance;

    if (Node == none)
    {
        Node = new class'TreeMapNode_string_string';
        Node.Key = D.RecursiveKey;
        Node.Value = D.RecursiveValue;

        D.Size += 1;

        return Node;
    }

    if (D.RecursiveKey < Node.Key)
    {
        Node.LHS = PutStatic(D, Node.LHS);
    }
    else if (D.RecursiveKey > Node.Key)
    {
        Node.RHS = PutStatic(D, Node.RHS);
    }
    else
    {
        Node.Value = D.RecursiveValue;

        return Node;
    }

    Balance = GetBalance(Node);

    if (Balance > 1 && D.RecursiveKey < Node.LHS.Key)
    {
        return RotateRight(Node);
    }
    else if (Balance < -1 && D.RecursiveKey > Node.RHS.Key)
    {
        return RotateLeft(Node);
    }
    else if (Balance > 1 && D.RecursiveKey > Node.LHS.Key)
    {
        Node.LHS = RotateLeft(Node.LHS);

        return RotateRight(Node);
    }
    else if (Balance  < -1 && D.RecursiveKey < Node.RHS.Key)
    {
        Node.RHS = RotateRight(Node.RHS);

        return RotateLeft(Node);
    }

    return Node;
}

