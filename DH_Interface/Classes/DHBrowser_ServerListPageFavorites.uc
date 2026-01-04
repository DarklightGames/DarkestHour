//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DHBrowser_ServerListPageFavorites extends ROUT2k4Browser_ServerListPageFavorites;

function InitComponent(GUIController MyController, GUIComponent MyOwner)
{
    super.InitComponent(MyController, MyOwner);

    Class'DHInterfaceUtil'.static.SetROStyle(MyController, Controls);

    Class'DHInterfaceUtil'.static.ReformatLists(MyController, lb_Server);
    Class'DHInterfaceUtil'.static.ReformatLists(MyController, lb_Rules);
    Class'DHInterfaceUtil'.static.ReformatLists(MyController, lb_Players);
}

function InitServerList()
{
    li_Server = new(none) Class'DHBrowser_ServersList';

    // Switch out the list
    lb_Server.InitBaseList(li_Server);
    lb_Server.HeaderColumnPerc = li_Server.InitColumnPerc;
    li_Server.OnChange = ServerListChanged;
    lb_Server.SetAnchor(Self);
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
    sp_Main=DHGUISplitter'DH_Interface.HorzSplitter'

    RulesListBoxClass="DH_Interface.DHBrowser_RulesListBox"
    PlayersListBoxClass="DH_Interface.DHBrowser_PlayersListBox"
    DetailSplitterPosition=0.465621

    Begin Object Class=DHGUIContextMenu Name=FavoritesContextMenu
        OnOpen=DHBrowser_ServerListPageFavorites.ContextMenuOpened
        OnSelect=DHBrowser_ServerListPageFavorites.ContextSelect
    End Object
    ContextMenu=DHGUIContextMenu'DH_Interface.FavoritesContextMenu'

    bStandardized=true
    StandardHeight=0.8
}
