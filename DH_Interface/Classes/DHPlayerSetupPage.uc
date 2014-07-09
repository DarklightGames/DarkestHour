class DHPlayerSetupPage extends ROUT2K4PlayerSetupPage;

defaultproperties
{
     Begin Object Class=GUIImage Name=MyBackground
         Image=Texture'InterfaceArt_tex.Menu.button_normal'
         ImageStyle=ISTY_Stretched
         WinHeight=1.000000
         RenderWeight=0.000100
         bBoundToParent=True
         bScaleToParent=True
         bNeverFocus=True
     End Object
     BackgroundImage=GUIImage'DH_Interface.DHPlayerSetupPage.MyBackground'

     Begin Object Class=GUITitleBar Name=psTitleBar
         bUseTextHeight=False
         Caption="Player Setup"
         StyleName="TitleBar"
         WinTop=0.050000
         WinLeft=0.050000
         WinWidth=0.800000
         WinHeight=0.056055
         RenderWeight=0.300000
     End Object
     TitleBar=GUITitleBar'DH_Interface.DHPlayerSetupPage.psTitleBar'

     Begin Object Class=DHGUITabControl Name=PageTabs
         bDockPanels=True
         TabHeight=0.060000
         WinTop=0.050000
         WinLeft=0.050000
         WinWidth=0.920000
         WinHeight=0.100000
         RenderWeight=0.490000
         TabOrder=3
         bAcceptsInput=True
         OnActivate=PageTabs.InternalOnActivate
     End Object
     playerTabs=DHGUITabControl'DH_Interface.DHPlayerSetupPage.PageTabs'

     OnCanClose=DHPlayerSetupPage.InternalOnCanClose
}
