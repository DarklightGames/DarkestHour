//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DHServerBrowser extends ROUT2k4ServerBrowser;

defaultproperties
{
    CurrentGameType="DH_Engine.DarkestHourGame"
    Begin Object Class=DHmoComboBox Name=GameTypeCombo
        bReadOnly=true
        CaptionWidth=0.1
        Caption="Game Type"
        OnCreateComponent=GameTypeCombo.InternalOnCreateComponent
        IniOption="@INTERNAL"
        WinTop=0.86
        WinLeft=0.62
        WinWidth=0.35868
        WinHeight=0.035
        RenderWeight=1.0
        TabOrder=0
        OnPreDraw=DHServerBrowser.ComboOnPreDraw
        OnLoadINI=DHServerBrowser.InternalOnLoadINI
    End Object
    co_GameType=DHmoComboBox'DH_Interface.DHServerBrowser.GameTypeCombo'
    Begin Object Class=DHGUITabControl Name=PageTabs
        bFillSpace=false
        bDockPanels=true
        TabHeight=0.06
        BackgroundStyleName="DHHeader"
        WinHeight=0.044
        RenderWeight=0.49
        TabOrder=3
        bAcceptsInput=true
        OnActivate=PageTabs.InternalOnActivate
        OnChange=DHServerBrowser.InternalOnChange
    End Object
    c_Tabs=DHGUITabControl'DH_Interface.DHServerBrowser.PageTabs'
    Begin Object Class=DHGUIHeader Name=ServerBrowserHeader
        bUseTextHeight=true
        Caption="Server Browser"
        StyleName="DHTopper"
    End Object
    t_Header=DHGUIHeader'DH_Interface.DHServerBrowser.ServerBrowserHeader'
    Begin Object Class=DHBrowser_Footer Name=FooterPanel
        Spacer=0.01
        StyleName="DHFooter"
        WinHeight=0.07
        TabOrder=4
        OnPreDraw=FooterPanel.InternalOnPreDraw
    End Object
    t_Footer=DHBrowser_Footer'DH_Interface.DHServerBrowser.FooterPanel'
    Begin Object Class=BackgroundImage Name=PageBackground
        Image=texture'DH_GUI_Tex.Menu.MultiMenuBack'
        ImageStyle=ISTY_Scaled
        ImageRenderStyle=MSTY_Alpha
        X1=0
        Y1=0
        X2=1024
        Y2=1024
    End Object
    i_Background=BackgroundImage'DH_Interface.DHServerBrowser.PageBackground'
    PanelClass(0)="DH_Interface.DHBrowser_MOTD"
    PanelClass(1)="DH_Interface.DHBrowser_IRC"
    PanelClass(2)="DH_Interface.DHBrowser_ServerListPageFavorites"
    PanelClass(3)="DH_Interface.DHBrowser_ServerListPageLAN"
    PanelClass(4)="DH_Interface.DHBrowser_ServerListPageInternet"
    PanelHint(1)="DH integrated IRC client"
    PanelHint(3)="View all DH servers currently running on your LAN"
    PanelHint(4)="Choose from DH servers across the world"
}
