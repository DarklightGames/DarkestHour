//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DHGUIList extends ROGuiListPlus;

//NOTE: Overridden to eliminate the need for selected items to only be highlighted if the list is in focus
function InternalOnDrawItem(Canvas C, int Item, float X, float Y, float XL, float YL, bool bIsSelected, bool bIsPending)
{
    local string Text;
    local bool   bIsDrop;

    Text = Elements[Item].Item;
    bIsDrop = Top + Item == DropIndex;

    if (bIsSelected || (bIsPending && !bIsDrop))
    {
        if (SelectedStyle != none)
        {
            if (SelectedStyle.Images[MenuState] != none)
            {
                SelectedStyle.Draw(C,MenuState, X, Y, XL, YL);
            }
            else
            {
                C.SetPos(X, Y);
                C.DrawTile(Controller.DefaultPens[0], XL, YL, 0.0, 0.0, 32.0, 32.0);
            }
        }
        else
        {
            C.SetPos(X, Y);

            if (SelectedImage == none)
            {
                C.DrawTile(Controller.DefaultPens[0], XL, YL, 0.0, 0.0, 32.0, 32.0);
            }
            else
            {
                C.SetDrawColor(SelectedBKColor.R, SelectedBKColor.G, SelectedBKColor.B, SelectedBKColor.A);
                C.DrawTileStretched(SelectedImage, XL, YL);
            }
        }
    }

    if (bIsPending && OutlineStyle != none)
    {
        if (OutlineStyle.Images[MenuState] != none)
        {
            if (bIsDrop)
            {
                OutlineStyle.Draw(C, MenuState, X + 1.0, Y + 1.0, XL - 2.0, YL - 2.0);
            }
            else
            {
                OutlineStyle.Draw(C, MenuState, X, Y, XL, YL);

                if (DropState == DRP_Source)
                {
                    OutlineStyle.Draw(C, MenuState, Controller.MouseX - MouseOffset[0], Controller.MouseY - MouseOffset[1] + Y - ClientBounds[1], MouseOffset[2] + MouseOffset[0], ItemHeight);
                }
            }
        }
    }

    if (Elements[item].ExtraStrData == DisabledMarker)
    {
        Style.DrawText(C, MSAT_Disabled, X, Y, XL, YL, TXTA_Left, Text, FontScale);
    }
    else if (bIsSelected && SelectedStyle != none)
    {
        SelectedStyle.DrawText(C, MenuState, X, Y, XL, YL, TXTA_Left, Text, FontScale);
    }
    else
    {
        Style.DrawText(C, MenuState, X, Y, XL, YL, TXTA_Left, Text, FontScale);
    }
}


// Modified to avoid "out of bounds" errors on Elements array
function bool InternalOnClick(GUIComponent Sender)
{
    local int NewIndex;

    if (!IsInClientBounds() || ItemsPerPage == 0)
    {
        return false;
    }

    NewIndex = CalculateIndex(); // get the row

    if (!bCanSelectDisabledItems && NewIndex < Elements.Length && NewIndex >= 0 && Elements[NewIndex].ExtraStrData == DisabledMarker)
    {
        return false;
    }

    SetIndex(NewIndex);

    return true;
}
