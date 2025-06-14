//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DHBrowser_RulesListBox extends UT2K4Browser_RulesListBox;

defaultproperties
{
    Begin Object Class=GUIMultiColumnListHeader Name=MyHeader
        BarStyleName="DHMultiColBar"
        StyleName="DHMultiColBar"
    End Object
    Header=GUIMultiColumnListHeader'DH_Interface.MyHeader'
    SelectedStyleName="DHListSelectionStyle"
    DefaultListClass="DH_Interface.DHBrowser_RulesList"
    Begin Object Class=DHGUIVertScrollBar Name=TheScrollbar
        bVisible=false
        OnPreDraw=TheScrollbar.GripPreDraw
    End Object
    MyScrollBar=DHGUIVertScrollBar'DH_Interface.TheScrollbar'
    StyleName="DHComboListBox"
}
