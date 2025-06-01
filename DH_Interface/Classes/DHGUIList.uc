//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DHGUIList extends ROGUIListPlus;

function int GetIndexByObject(Object O)
{
    local int i;

    for (i = 0; i < Elements.Length; ++i)
    {
        if (O == GetObjectAtIndex(i))
        {
            return i;
        }
    }

    return -1;
}

function int SelectByObject(Object O)
{
    return SetIndex(GetIndexByObject(O));
}

function bool IsIndexDisabled(int Index)
{
    return Index >= 0 && Index < Elements.Length && Elements[Index].ExtraStrData == DisabledMarker;
}