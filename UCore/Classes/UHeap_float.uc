//==============================================================================
// Darklight Games (c) 2008-2019
//==============================================================================

class UHeap_float extends Object;

var array<float> Data;
var bool         bMinHeap; // the heap is max by default

final function Clear() { Data.Length = 0; }
final function int GetLength() { return Data.Length; }

final function Insert(float Value)
{
    Data[Data.Length] = Value;
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
        class'UCore'.static.FSwap(Data[0], Data[EndIndex]);
        SiftDown(0, EndIndex - 1);
    }

    Data.Remove(EndIndex, 1);
}

// Extract the root of the heap, removing it in the process
final function float Pop()
{
    local float Value;

    if (Data.Length > 0)
    {
        Remove();
        Value = Data[0];
        return Value;
    }
}

// Get the root item
final function float Peek()
{
    if (Data.Length > 0)
    {
        return Data[0];
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

final function array<float> GetSorted()
{
    local int EndIndex;

    if (Data.Length < 2)
    {
        return self.Data;
    }

    EndIndex = Data.Length - 1;

    while (EndIndex > 0)
    {
        class'UCore'.static.FSwap(Data[0], Data[EndIndex]);
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

        if (ShouldSwap(i, ParentIndex))
        {
            class'UCore'.static.FSwap(Data[i], Data[ParentIndex]);
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

        if (ShouldSwap(ChildIndex, SwapIndex))
        {
            SwapIndex = ChildIndex;
        }

        RightChildIndex = ChildIndex + 1;

        if (RightChildIndex <= EndIndex && ShouldSwap(RightChildIndex, SwapIndex))
        {
            SwapIndex = RightChildIndex;
        }

        if (SwapIndex != RootIndex)
        {
            class'UCore'.static.FSwap(Data[RootIndex], Data[SwapIndex]);
            RootIndex = SwapIndex;
            continue;
        }

        break;
    }
}

protected function bool ShouldSwap(int A, int B)
{
    if (bMinHeap)
    {
        return Data[A] < Data[B];
    }

    return Data[A] > Data[B];
}

static final function Heapsort(out array<float> Data, optional bool bDescending)
{
    local UHeap_float Heap;
    local int i;

    Heap = new default.Class;
    Heap.bMinHeap = bDescending;

    for (i = 0; i < Data.Length; ++i)
    {
        Heap.Data[Heap.Data.Length] = Data[i];
    }

    Heap.Heapify();
    Data = Heap.GetSorted();
    Heap.Clear();
}

static final function float SortAndPeek(array<float> Data, optional bool bDescending)
{
    local UHeap_float Heap;
    local float Value;
    local int i;

    Heap = new default.Class;
    Heap.bMinHeap = bDescending;

    for (i = 0; i < Data.Length; ++i)
    {
        Heap.Data[Heap.Data.Length] = Data[i];
    }

    Heap.Heapify();
    Value = Heap.Peek();
    Heap.Clear();

    return Value;
}

static final function int GetLeftChildIndex(int Index) { return 2 * Index + 1; }
static final function int GetRightChildIndex(int Index) { return 2 * Index + 2; }
static final function int GetParentIndex(int Index) { return (Index - 1) >> 1; }

// DEBUG

function DebugLog()
{
    local int i;

    Log("HEAP CONTENTS:");

    for (i = 0; i < Data.Length; ++i)
    {
        Log(i $ ":" @ Data[i]);
    }
}

function DebugSortedLog()
{
    local array<float> Sorted;
    local int i;

    Log("HEAP CONTENTS (SORTED):");

    Sorted = GetSorted();

    for (i = 0; i < Sorted.Length; ++i)
    {
        Log(i $ ":" @ Sorted[i]);
    }
}
