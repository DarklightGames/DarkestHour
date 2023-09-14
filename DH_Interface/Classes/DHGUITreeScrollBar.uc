//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DHGUITreeScrollBar extends DHGUIVertScrollBar;

var() editconst noexport GUITreeList List;

function SetList(GUIListBase InList)
{
    super.SetList(InList);

    List = GUITreeList(InList);

    if (List != none)
    {
        ItemCount = List.VisibleCount;
    }
}

function UpdateGripPosition(float NewPos)
{
    if (List != none)
    {
        List.MakeVisible(NewPos);

        ItemCount = List.VisibleCount;
    }

    GripPos = NewPos;
    CurPos = (ItemCount - ItemsPerPage) * GripPos;

    PositionChanged(CurPos);
}

delegate MoveGripBy(int items)
{
    local int NewItem;

    if (List != none)
    {
        NewItem = List.Top + items;
        ItemCount = List.VisibleCount;

        if (ItemCount > 0)
        {
            List.SetTopItem(NewItem);
        }
    }

    CurPos += items;

    if (CurPos < 0)
    {
        CurPos = 0;
    }

    if (CurPos > ItemCount-ItemsPerPage)
    {
        CurPos = ItemCount-ItemsPerPage;
    }

    if (List == none && ItemCount > 0)
    {
        AlignThumb();
    }

    PositionChanged(CurPos);
}

delegate AlignThumb()
{
    local float NewPos;

    if (List != none)
    {
        BigStep = List.ItemsPerPage * Step;

        if (List.ItemCount == 0)
        {
            NewPos = 0;
        }
        else
        {
            NewPos = float(List.Top) / float(List.VisibleCount - List.ItemsPerPage);
        }
    }
    else
    {
        if (ItemCount == 0)
        {
            NewPos = 0;
        }
        else
        {
            NewPos = CurPos / float(ItemCount - ItemsPerPage);
        }
    }

    GripPos = FClamp(NewPos, 0.0, 1.0);
}
