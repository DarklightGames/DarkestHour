//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DHBrowser_ServerListPageInternet extends ROUT2k4Browser_ServerListPageInternet;

var array<string> ServerBlacklist; // Hide unwanted servers

function InitServerList()
{
    li_Server = new(none) class'DH_Interface.DHBrowser_ServersList';

    lb_Server.InitBaseList(li_Server);

    lb_Server.HeaderColumnPerc = li_Server.InitColumnPerc;

    li_Server.OnChange = ServerListChanged;
    li_Server.bPresort = true;
    lb_Server.SetAnchor(self);
}

function MyOnReceivedServer(GameInfo.ServerResponseLine s)
{
    local int i;

    for (i = 0; i < ServerBlacklist.Length; ++i)
    {
        if (ServerBlacklist[i] == s.IP)
        {
            SetTimer(1.0);
            return;
        }
    }

    super.MyOnReceivedServer(s);
}

defaultproperties
{
    Begin Object Class=GUISplitter Name=HorzSplitter
        DefaultPanels(0)="DH_Interface.DHBrowser_ServerListBox"
        DefaultPanels(1)="DH_Interface.DHGUISplitter"
        MaxPercentage=0.9
        OnReleaseSplitter=DHBrowser_ServerListPageInternet.InternalReleaseSplitter
        OnCreateComponent=DHBrowser_ServerListPageInternet.InternalOnCreateComponent
        IniOption="@Internal"
        StyleName="DHNoBox"
        WinHeight=1.0
        RenderWeight=1.0
        OnLoadINI=DHBrowser_ServerListPageInternet.InternalOnLoadINI
    End Object
    sp_Main=GUISplitter'DH_Interface.DHBrowser_ServerListPageInternet.HorzSplitter'

    RulesListBoxClass="DH_Interface.DHBrowser_RulesListBox"
    PlayersListBoxClass="DH_Interface.DHBrowser_PlayersListBox"
    bStandardized=true
    StandardHeight=0.8

    ServerBlacklist(0)="81.169.151.184"
}
