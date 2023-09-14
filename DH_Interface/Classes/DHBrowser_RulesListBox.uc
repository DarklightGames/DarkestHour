//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DHBrowser_RulesListBox extends UT2K4Browser_RulesListBox;

defaultproperties
{
    Begin Object Class=GUIMultiColumnListHeader Name=MyHeader
        BarStyleName="DHMultiColBar"
        StyleName="DHMultiColBar"
    End Object
    Header=GUIMultiColumnListHeader'DH_Interface.DHBrowser_RulesListBox.MyHeader'
    SelectedStyleName="DHListSelectionStyle"
    DefaultListClass="DH_Interface.DHBrowser_RulesList"
    Begin Object Class=DHGUIVertScrollBar Name=TheScrollbar
        bVisible=false
        OnPreDraw=TheScrollbar.GripPreDraw
    End Object
    MyScrollBar=DHGUIVertScrollBar'DH_Interface.DHBrowser_RulesListBox.TheScrollbar'
    StyleName="DHComboListBox"
}
