//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DHBrowser_ServerListPageInternet extends ROUT2k4Browser_ServerListPageInternet;

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
}
