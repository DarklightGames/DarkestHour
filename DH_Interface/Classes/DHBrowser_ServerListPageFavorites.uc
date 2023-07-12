//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DHBrowser_ServerListPageFavorites extends UT2k4Browser_ServerListPageFavorites;

function InitComponent(GUIController MyController, GUIComponent MyOwner)
{
    super.Initcomponent(MyController, MyOwner);

    class'DHInterfaceUtil'.static.SetROStyle(MyController, Controls);

    class'DHInterfaceUtil'.static.ReformatLists(MyController, lb_Server);
    class'DHInterfaceUtil'.static.ReformatLists(MyController, lb_Rules);
    class'DHInterfaceUtil'.static.ReformatLists(MyController, lb_Players);
}

defaultproperties
{
    Begin Object Class=DHGUISplitter Name=HorzSplitter
        DefaultPanels(0)="DH_Interface.DHBrowser_ServerListBox"
        DefaultPanels(1)="DH_Interface.DHGUISplitter"
        MaxPercentage=0.9
        OnReleaseSplitter=DHBrowser_ServerListPageFavorites.InternalReleaseSplitter
        OnCreateComponent=DHBrowser_ServerListPageFavorites.InternalOnCreateComponent
        IniOption="@Internal"
        WinHeight=1.0
        RenderWeight=1.0
        OnLoadINI=DHBrowser_ServerListPageFavorites.InternalOnLoadINI
    End Object
    sp_Main=DHGUISplitter'DH_Interface.DHBrowser_ServerListPageFavorites.HorzSplitter'

    RulesListBoxClass="DH_Interface.DHBrowser_RulesListBox"
    PlayersListBoxClass="DH_Interface.DHBrowser_PlayersListBox"
    DetailSplitterPosition=0.465621

    Begin Object Class=ROGUIContextMenu Name=FavoritesContextMenu
        OnOpen=DHBrowser_ServerListPageFavorites.ContextMenuOpened
        OnSelect=DHBrowser_ServerListPageFavorites.ContextSelect
    End Object
    ContextMenu=ROGUIContextMenu'DH_Interface.DHBrowser_ServerListPageFavorites.FavoritesContextMenu'

    bStandardized=true
    StandardHeight=0.8
}
