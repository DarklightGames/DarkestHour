//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DHBrowser_ServerListPageLAN extends ROUT2k4Browser_ServerListPageLAN;

function InitComponent(GUIController MyController, GUIComponent MyOwner)
{
    Super.Initcomponent(MyController, MyOwner);

    class'ROInterfaceUtil'.static.SetROStyle(MyController, Controls);

    class'ROInterfaceUtil'.static.ReformatLists(MyController, lb_Server);
    class'ROInterfaceUtil'.static.ReformatLists(MyController, lb_Rules);
    class'ROInterfaceUtil'.static.ReformatLists(MyController, lb_Players);
}

function InitServerList()
{
    li_Server = new(none) class'DH_Interface.DHBrowser_ServersList';

    // Switch out the list
    lb_Server.InitBaseList(li_Server);
    lb_Server.HeaderColumnPerc = li_Server.InitColumnPerc;
    li_Server.OnChange = ServerListChanged;
    lb_Server.SetAnchor(Self);
}

defaultproperties
{
    Begin Object Class=GUISplitter Name=HorzSplitter
        DefaultPanels(0)="DH_Interface.DHBrowser_ServerListBox"
        DefaultPanels(1)="DH_Interface.DHGUISplitter"
        MaxPercentage=0.9
        OnReleaseSplitter=DHBrowser_ServerListPageLAN.InternalReleaseSplitter
        OnCreateComponent=DHBrowser_ServerListPageLAN.InternalOnCreateComponent
        IniOption="@Internal"
        StyleName="DHNoBox"
        WinHeight=1.0
        RenderWeight=1.0
        OnLoadINI=DHBrowser_ServerListPageLAN.InternalOnLoadINI
    End Object
    sp_Main=GUISplitter'DH_Interface.DHBrowser_ServerListPageLAN.HorzSplitter'

    RulesListBoxClass="DH_Interface.DHBrowser_RulesListBox"
    PlayersListBoxClass="DH_Interface.DHBrowser_PlayersListBox"
    bStandardized=true
    StandardHeight=0.8

    HeaderColumnSizes(0)=(ColumnSizes=(0.04,0.22,0.09,0.10,0.10,0.27,0.10,0.08))

    /*
    InitColumnPerc(0)=0.04  // icons
    InitColumnPerc(1)=0.22  // name
    InitColumnPerc(2)=0.09  // health
    InitColumnPerc(3)=0.10  // location
    InitColumnPerc(4)=0.10  // version
    InitColumnPerc(5)=0.27  // map
    InitColumnPerc(6)=0.10  // slots
    InitColumnPerc(7)=0.08  // ping
    */
}
