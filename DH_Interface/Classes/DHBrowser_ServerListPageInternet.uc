//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DHBrowser_ServerListPageInternet extends ROUT2k4Browser_ServerListPageInternet;

var bool            bDisableWhitelist;  // Kill-switch for the whitelist.
var array<string>   ServerWhitelist;    // Show only servers in this list if they aren't password-protected.

function InitServerList()
{
    li_Server = new(none) class'DH_Interface.DHBrowser_ServersList';

    lb_Server.InitBaseList(li_Server);

    lb_Server.HeaderColumnPerc = li_Server.InitColumnPerc;

    li_Server.OnChange = ServerListChanged;
    li_Server.bPresort = true;
    lb_Server.SetAnchor(self);
}

function bool IsServerPasswordProtected(GameInfo.ServerResponseLine S)
{
    // Passworded      1
    // Stats           2
    // LatestVersion   4
    // Listen Server   8
    // Vac Secured	   16
    // Standard        32
    // UT CLassic      64
    return (S.Flags & 1) != 0;
}

function bool IsServerOnWhitelist(string IP)
{
    local int i;

    for (i = 0; i < ServerWhitelist.Length; ++i)
    {
        if (ServerWhitelist[i] == IP)
        {
            return true;
        }
    }

    return false;
}

function bool ShouldServerBeDisplayed(GameInfo.ServerResponseLine s)
{
    // If the server is not on the whitelist and is not password-protected, don't show it.
    return bDisableWhitelist || IsServerOnWhitelist(s.IP) || IsServerPasswordProtected(s);
}

function MyOnReceivedServer(GameInfo.ServerResponseLine s)
{
    if (!ShouldServerBeDisplayed(s))
    {
        SetTimer(1.0);
        return;
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

    ServerWhitelist(0)="104.243.41.183"     // Official US
    ServerWhitelist(1)="185.206.148.38"     // Official EU
    ServerWhitelist(2)="45.76.59.241"       // Amish USA
}
