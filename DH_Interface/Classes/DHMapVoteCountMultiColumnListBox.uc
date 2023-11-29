//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DHMapVoteCountMultiColumnListBox extends MapVoteCountMultiColumnListBox;

function InitBaseList(GUIListBase ListBase)
{
    super.InitBaseList(ListBase);

    ListBase.OnChange = OnChange;
}

defaultproperties
{
    ContextMenu=none
}
