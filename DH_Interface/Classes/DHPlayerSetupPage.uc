//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DHPlayerSetupPage extends ROUT2K4PlayerSetupPage;

defaultproperties
{
    Begin Object Class=GUIImage Name=MyBackground
        Image=Texture'InterfaceArt_tex.Menu.button_normal'
        ImageStyle=ISTY_Stretched
        WinHeight=1.0
        RenderWeight=0.0001
        bBoundToParent=true
        bScaleToParent=true
        bNeverFocus=true
    End Object
    BackgroundImage=GUIImage'DH_Interface.DHPlayerSetupPage.MyBackground'
    Begin Object Class=GUITitleBar Name=psTitleBar
        bUseTextHeight=false
        Caption="Player Setup"
        StyleName="TitleBar"
        WinTop=0.05
        WinLeft=0.05
        WinWidth=0.8
        WinHeight=0.056055
        RenderWeight=0.3
    End Object
    TitleBar=GUITitleBar'DH_Interface.DHPlayerSetupPage.psTitleBar'
    Begin Object Class=DHGUITabControl Name=PageTabs
        bDockPanels=true
        TabHeight=0.06
        WinTop=0.05
        WinLeft=0.05
        WinWidth=0.92
        WinHeight=0.1
        RenderWeight=0.49
        TabOrder=3
        bAcceptsInput=true
        OnActivate=PageTabs.InternalOnActivate
    End Object
    playerTabs=DHGUITabControl'DH_Interface.DHPlayerSetupPage.PageTabs'
    OnCanClose=DHPlayerSetupPage.InternalOnCanClose
}
