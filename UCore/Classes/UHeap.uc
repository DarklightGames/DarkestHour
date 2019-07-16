//==============================================================================
// Darklight Games (c) 2008-2019
//==============================================================================

class UHeap extends Object;

struct DataPoint
{
    var Object Item;
    var float  Priority;
};

var array<DataPoint> Data;
var bool             bMinHeap; // the heap is max by default

final function Clear() { Data.Length = 0; }
final function int GetLength() { return Data.Length; }

final function Insert(Object Item, float Priority)
{
    local DataPoint P;

    P.Item = Item;
    P.Priority = Priority;

    Data[Data.Length] = P;
    SiftUp(Data.Length - 1);
}

// Remove the root
final function Remove()
{
    local int EndIndex;

    if (Data.Length < 1)
    {
        return;
    }

    EndIndex = Data.Length - 1;

    if (EndIndex > 1)
    {
        class'UCore'.static.Swap(Data[0].Item, Data[EndIndex].Item);
        class'UCore'.static.FSwap(Data[0].Priority, Data[EndIndex].Priority);
        SiftDown(0, EndIndex - 1);
    }

    Data.Remove(EndIndex, 1);
}

// Extract the root of the heap, removing it in the process
final function Object Pop()
{
    local Object O;

    if (Data.Length > 0)
    {
        Remove();
        O = Data[0].Item;
        return O;
    }
}

// Get the root item
final function Object Peek()
{
    if (Data.Length > 0)
    {
        return Data[0].Item;
    }
}

final function Heapify()
{
    local int i;

    for (i = int(Data.Length * 0.5); i >= 0; --i)
    {
        SiftDown(i, Data.Length - 1);
    }
}

final function array<DataPoint> GetSorted()
{
    local int EndIndex;

    if (Data.Length < 2)
    {
        return self.Data;
    }

    EndIndex = Data.Length - 1;

    while (EndIndex > 0)
    {
        class'UCore'.static.Swap(Data[0].Item, Data[EndIndex].Item);
        class'UCore'.static.FSwap(Data[0].Priority, Data[EndIndex].Priority);
        --EndIndex;
        SiftDown(0, EndIndex);
    }

    return self.Data;
}

final function SiftUp(int StartIndex)
{
    local int i, ParentIndex;

    if (StartIndex >= Data.Length)
    {
        Warn("Index overflow");
        return;
    }

    i = StartIndex;

    while (i > 0)
    {
        ParentIndex = GetParentIndex(i);

        if (ShouldSwap(Data[i].Priority, Data[ParentIndex].Priority))
        {
            class'UCore'.static.Swap(Data[i].Item, Data[ParentIndex].Item);
            class'UCore'.static.FSwap(Data[i].Priority, Data[ParentIndex].Priority);
            i = ParentIndex;
            continue;
        }

        break;
    }
}

final function SiftDown(int StartIndex, int EndIndex)
{
    local int RootIndex, ChildIndex, SwapIndex, RightChildIndex;

    if (StartIndex < 0 || EndIndex >= Data.Length)
    {
        Warn("Index overflow");
        return;
    }

    RootIndex = StartIndex;

    while (GetLeftChildIndex(RootIndex) <= EndIndex)
    {
        ChildIndex = GetLeftChildIndex(RootIndex);
        SwapIndex = RootIndex;

        if (ShouldSwap(Data[ChildIndex].Priority, Data[SwapIndex].Priority))
        {
            SwapIndex = ChildIndex;
        }

        RightChildIndex = ChildIndex + 1;

        if (RightChildIndex <= EndIndex && ShouldSwap(Data[RightChildIndex].Priority, Data[SwapIndex].Priority))
        {
            SwapIndex = RightChildIndex;
        }

        if (SwapIndex != RootIndex)
        {
            class'UCore'.static.Swap(Data[RootIndex].Item, Data[SwapIndex].Item);
            class'UCore'.static.FSwap(Data[RootIndex].Priority, Data[SwapIndex].Priority);
            RootIndex = SwapIndex;
            continue;
        }

        break;
    }
}

protected final function bool ShouldSwap(float A, float B)
{
    if (bMinHeap)
    {
        return A < B;
    }

    return A > B;
}

static final function Heapsort(out array<DataPoint> Data, optional bool bDescending)
{
    local UHeap Heap;
    local int i, EndIndex;

    Heap = new class'UHeap';
    Heap.bMinHeap = bDescending;

    for (i = 0; i < Data.Length; ++i)
    {
        Heap.Data[Heap.Data.Length] = Data[i];
    }

    Heap.Heapify();
    Data = Heap.GetSorted();
    Heap.Clear();
}

static final function OHeapsort(out array<Object> Data, Functor_float_Object PriorityFunction, optional bool bDescending)
{
    local UHeap Heap;
    local DataPoint P;
    local array<DataPoint> Sorted;
    local int i, EndIndex;

    Heap = new class'UHeap';
    Heap.bMinHeap = bDescending;

    for (i = 0; i < Data.Length; ++i)
    {
        P.Item = Data[i];
        P.Priority = PriorityFunction.DelegateFunction(Data[i]);

        Heap.Data[Heap.Data.Length] = P;
    }

    Heap.Heapify();
    Sorted = Heap.GetSorted();
    Heap.Clear();
    Data.Length = 0;

    for (i = 0; i < Sorted.Length; ++i)
    {
        Data[Data.Length] = Sorted[i].Item;
    }
}

static final function Object OSortAndPeek(array<Object> Data, Functor_float_Object PriorityFunction, optional bool bDescending)
{
    local UHeap Heap;
    local DataPoint P;
    local Object O;
    local int i, EndIndex;

    Heap = new class'UHeap';
    Heap.bMinHeap = bDescending;

    for (i = 0; i < Data.Length; ++i)
    {
        P.Item = Data[i];
        P.Priority = PriorityFunction.DelegateFunction(Data[i]);

        Heap.Data[Heap.Data.Length] = P;
    }

    Heap.Heapify();
    O = Heap.Peek();
    Heap.Clear();

    return O;
}

static final function int GetLeftChildIndex(int Index) { return 2 * Index + 1; }
static final function int GetRightChildIndex(int Index) { return 2 * Index + 2; }
static final function int GetParentIndex(int Index) { return (Index - 1) >> 1; }

// DEBUG

function DebugLog(optional int IndentLevel)
{
    local string Indent;
    local UHeap Heap;
    local int i;

    for (i = 0; i < IndentLevel; ++i)
    {
        Indent $= "--";
    }

    Log(Indent $ "HEAP CONTENTS:");

    for (i = 0; i < Data.Length; ++i)
    {
        Log(Indent $ i $ ":" @ string(Data[i].Item.Class) @ ">" @ string(Data[i].Priority));

        if (Data[i].Item.IsA('UHeap'))
        {
            Heap = UHeap(Data[i].Item);

            if (Heap != none)
            {
                Heap.DebugLog(IndentLevel + 1);
            }
            else
            {
                Warn("Cast fail");
            }
        }
    }
}

function DebugSortedLog(optional int IndentLevel)
{
    local string Indent;
    local UHeap Heap;
    local array<DataPoint> Sorted;
    local int i;

    for (i = 0; i < IndentLevel; ++i)
    {
        Indent $= "-- ";
    }

    Log(Indent $ "HEAP CONTENTS (SORTED):");

    Sorted = GetSorted();

    for (i = 0; i < Sorted.Length; ++i)
    {
        Log(Indent $ i $ ":" @ string(Sorted[i].Item.Class) @ ">" @ string(Sorted[i].Priority));

        if (Sorted[i].Item.IsA('UHeap'))
        {
            Heap = UHeap(Data[i].Item);

            if (Heap != none)
            {
                Heap.DebugSortedLog(IndentLevel + 1);
            }
            else
            {
                Warn("Cast fail");
            }
        }
    }
}
