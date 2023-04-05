//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
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

