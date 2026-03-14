//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
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
