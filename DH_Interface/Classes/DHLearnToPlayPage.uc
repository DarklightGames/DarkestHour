//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DHLearnToPlayPage extends UT2K4MainPage;

function BackButtonClicked()
{
    Controller.CloseMenu(true);
}

defaultproperties
{
    Background=Texture'DH_GUI_Tex.Menu.Setupmenu'

    PanelCaption(0)="Video Guides"
    PanelCaption(1)=""
    PanelCaption(2)=""
    PanelCaption(3)=""
    PanelCaption(4)=""
    PanelCaption(5)=""
    PanelCaption(6)=""

    PanelClass(0)=""
    PanelClass(1)=""
    PanelClass(2)=""
    PanelClass(3)=""
    PanelClass(4)=""
    PanelClass(5)=""
    PanelClass(6)=""

    PanelHint(0)="Learn about the game by watching a video"
    PanelHint(1)=""
    PanelHint(2)=""
    PanelHint(3)=""
    PanelHint(4)=""
    PanelHint(5)=""
    PanelHint(6)=""

    Begin Object Class=DHGUITabControl Name=LearnToPlayTabs
        bFillSpace=false
        bDockPanels=true
        TabHeight=0.06
        BackgroundStyleName="DHHeader"
        WinHeight=0.044
        RenderWeight=0.49
        TabOrder=3
        bAcceptsInput=true
        //OnActivate=SettingTabs.InternalOnActivate
        OnChange=DHLearnToPlayPage.InternalOnChange
    End Object
    c_Tabs=LearnToPlayTabs

    Begin Object Class=DHGUIHeader Name=LearnToPlayHeader
        Caption="Learn To Play"
        StyleName="DHTopper"
        WinHeight=32.0
        RenderWeight=0.3
    End Object
    t_Header=LearnToPlayHeader

    Begin Object Class=DHLearnToPlayFooter Name=LearnToPlayFooter
        Spacer=0.01
        StyleName="DHFooter"
        RenderWeight=0.3
        TabOrder=4
        OnPreDraw=SettingFooter.InternalOnPreDraw
    End Object
    t_Footer=LearnToPlayFooter

    bRequire640x480=false
    WinTop=0.0
    WinHeight=1.0
}
