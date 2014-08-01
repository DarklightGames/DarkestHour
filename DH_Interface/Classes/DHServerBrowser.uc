//-----------------------------------------------------------
//
//-----------------------------------------------------------
class DHServerBrowser extends ROUT2k4ServerBrowser;

defaultproperties
{
     CurrentGameType="DH_Engine.DarkestHourGame"
     Begin Object Class=DHmoComboBox Name=GameTypeCombo
         bReadOnly=true
         CaptionWidth=0.100000
         Caption="Game Type"
         OnCreateComponent=GameTypeCombo.InternalOnCreateComponent
         IniOption="@INTERNAL"
         WinTop=0.860000
         WinLeft=0.620000
         WinWidth=0.358680
         WinHeight=0.035000
         RenderWeight=1.000000
         TabOrder=0
         OnPreDraw=DHServerBrowser.ComboOnPreDraw
         OnLoadINI=DHServerBrowser.InternalOnLoadINI
     End Object
     co_GameType=DHmoComboBox'DH_Interface.DHServerBrowser.GameTypeCombo'

     Begin Object Class=DHGUITabControl Name=PageTabs
         bFillSpace=false
         bDockPanels=true
         TabHeight=0.060000
         BackgroundStyleName="DHHeader"
         WinHeight=0.044000
         RenderWeight=0.490000
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
         Spacer=0.010000
         StyleName="DHFooter"
         WinHeight=0.070000
         TabOrder=4
         OnPreDraw=FooterPanel.InternalOnPreDraw
     End Object
     t_Footer=DHBrowser_Footer'DH_Interface.DHServerBrowser.FooterPanel'

     Begin Object Class=BackgroundImage Name=PageBackground
         Image=Texture'DH_GUI_Tex.Menu.MultiMenuBack'
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
     PanelHint(4)="Choose from hundreds of DH servers across the world"
}
