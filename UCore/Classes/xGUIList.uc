//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class xGUIList extends Object;

final static function int GetIndexOfObject(GUIList L, Object Object)
{
    local int i;

    if (L == none)
    {
        return -1;
    }

    for (i = 0; i < L.ItemCount; ++i)
    {
        if (L.GetObjectAtIndex(i) == Object)
        {
            return i;
        }
    }

    return -1;
}

