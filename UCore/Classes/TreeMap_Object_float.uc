//==============================================================================
// Darklight Games (c) 2008-2023
//==============================================================================

class TreeMap_Object_float extends Object;

var private TreeMapNode_Object_float Head;
var private array<Object> Keys;
var private array<float> Values;
var private int Size;
var private Object RecursiveKey;
var private string RecursiveKeyString;
var private float RecursiveValue;

function int GetSize()
{
    return Size;
}

function array<Object> GetKeys()
{
    Keys.Length = 0;

    GetKeysTraverse(Head);

    return Keys;
}

private function GetKeysTraverse(TreeMapNode_Object_float Node)
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

function array<float> GetValues()
{
    Values.Length = 0;

    GetValuesTraverse(Head);

    return Values;
}

private function GetValuesTraverse(TreeMapNode_Object_float Node)
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

function bool Get(Object Key, optional out float Value)
{
    local TreeMapNode_Object_float Node;
    local string KeyString;

    Node = Head;
    KeyString = string(Key.Name);

    while (Node != none)
    {
        if (KeyString < Node.KeyString)
        {
            Node = Node.LHS;
        }
        else if (KeyString > Node.KeyString)
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

function Put(Object Key, float Value)
{
    RecursiveKey = Key;
    RecursiveKeyString = string(Key.Name);
    RecursiveValue = Value;

    Head = PutStatic(self, Head);
}

private static function int GetBalance(TreeMapNode_Object_float Node)
{
    if (Node == none)
    {
        return 0;
    }

    return GetHeight(Node.LHS) - GetHeight(Node.RHS);
}

private static function int GetHeight(TreeMapNode_Object_float Node)
{
    if (Node == none)
    {
        return 0;
    }

    return Node.Height;
}

private static function TreeMapNode_Object_float FindMin(TreeMapNode_Object_float Node)
{
    while (Node.LHS != none)
    {
        Node = Node.LHS;
    }

    return Node;
}

function Erase(Object Key)
{
    RecursiveKey = Key;
    RecursiveKeyString = string(Key.Name);
    Head = EraseStatic(self, Head);
}

private static function TreeMapNode_Object_float EraseStatic(TreeMap_Object_float D, TreeMapNode_Object_float Node)
{
    local int Balance;
    local TreeMapNode_Object_float Temp;

    if (Node == none)
    {
        return Node;
    }

    if (D.RecursiveKeyString < Node.KeyString)
    {
        Node.LHS = EraseStatic(D, Node.LHS);
    }
    else if (D.RecursiveKeyString > Node.KeyString)
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
            D.RecursiveKeyString = Temp.KeyString;

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

private static function TreeMapNode_Object_float RotateRight(TreeMapNode_Object_float Y)
{
    local TreeMapNode_Object_float X;
    local TreeMapNode_Object_float T2;

    X = Y.LHS;
    T2 = X.RHS;

    X.RHS = Y;
    Y.LHS = T2;

    Y.Height = Max(GetHeight(Y.LHS), GetHeight(Y.RHS)) + 1;
    X.Height = Max(GetHeight(X.LHS), GetHeight(X.RHS)) + 1;

    return X;
}

private static function TreeMapNode_Object_float RotateLeft(TreeMapNode_Object_float X)
{
    local TreeMapNode_Object_float Y;
    local TreeMapNode_Object_float T2;

    Y = X.RHS;
    T2 = Y.LHS;

    Y.LHS = X;
    X.RHS = T2;

    X.Height = Max(GetHeight(X.LHS), GetHeight(X.RHS)) + 1;
    Y.Height = Max(GetHeight(Y.LHS), GetHeight(Y.RHS)) + 1;

    return Y;
}

private static function TreeMapNode_Object_float PutStatic(TreeMap_Object_float D, TreeMapNode_Object_float Node)
{
    local int Balance;

    if (Node == none)
    {
        Node = new class'TreeMapNode_Object_float';
        Node.Key = D.RecursiveKey;
        Node.KeyString = D.RecursiveKeyString;
        Node.Value = D.RecursiveValue;

        D.Size += 1;

        return Node;
    }

    if (D.RecursiveKeyString < Node.KeyString)
    {
        Node.LHS = PutStatic(D, Node.LHS);
    }
    else if (D.RecursiveKeyString > Node.KeyString)
    {
        Node.RHS = PutStatic(D, Node.RHS);
    }
    else
    {
        Node.Value = D.RecursiveValue;

        return Node;
    }

    Balance = GetBalance(Node);

    if (Balance > 1 && D.RecursiveKeyString < Node.LHS.KeyString)
    {
        return RotateRight(Node);
    }
    else if (Balance < -1 && D.RecursiveKeyString > Node.RHS.KeyString)
    {
        return RotateLeft(Node);
    }
    else if (Balance > 1 && D.RecursiveKeyString > Node.LHS.KeyString)
    {
        Node.LHS = RotateLeft(Node.LHS);

        return RotateRight(Node);
    }
    else if (Balance  < -1 && D.RecursiveKeyString < Node.RHS.KeyString)
    {
        Node.RHS = RotateRight(Node.RHS);

        return RotateLeft(Node);
    }

    return Node;
}

