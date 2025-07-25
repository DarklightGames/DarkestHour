//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DHServerBrowser extends ROUT2k4ServerBrowser;

var     config bool             bDidShowWelcomeMessage;
var     localized string        WelcomeMessageText;
var     localized string        WelcomeMessageDiscordButtonText;
var     localized string        WelcomeMessagePlayButtonText;

function CreateTabs()
{
    super.CreateTabs();

    // Activate the Internet tab immediately
    c_Tabs.ActivateTabByName(PanelCaption[2], true);
}

function InternalOnOpen()
{
    local GUIQuestionPage QP;

    if (!bDidShowWelcomeMessage)
    {
        QP = Controller.ShowQuestionDialog(default.WelcomeMessageText, QBTN_OkCancel, QBTN_OK);
        QP.OnButtonClick = InternalOnButtonClick;
        QP.ButtonNames[0] = WelcomeMessageDiscordButtonText;
        QP.ButtonNames[1] = WelcomeMessagePlayButtonText;
        QP.SetupQuestion(default.WelcomeMessageText, QBTN_OkCancel, QBTN_OK, true);

        bDidShowWelcomeMessage = true;
        SaveConfig();
    }
}

function InternalOnButtonClick(byte bButton)
{
    switch (bButton)
    {
        case QBTN_OK:
            PlayerOwner().ConsoleCommand("START" @ Class'DHMainMenu'.default.DiscordURL);
            break;
    }
}

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
    co_GameType=DHmoComboBox'DH_Interface.GameTypeCombo'

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
    c_Tabs=DHGUITabControl'DH_Interface.PageTabs'

    Begin Object Class=DHGUIHeader Name=ServerBrowserHeader
        bUseTextHeight=true
        Caption="Server Browser"
        StyleName="DHTopper"
    End Object
    t_Header=DHGUIHeader'DH_Interface.ServerBrowserHeader'

    Begin Object Class=DHBrowser_Footer Name=FooterPanel
        Spacer=0.01
        StyleName="DHFooter"
        WinHeight=0.07
        TabOrder=4
        OnPreDraw=FooterPanel.InternalOnPreDraw
    End Object
    t_Footer=DHBrowser_Footer'DH_Interface.FooterPanel'

    Begin Object Class=BackgroundImage Name=PageBackground
        Image=Texture'DH_GUI_Tex.MultiMenuBack'
        ImageStyle=ISTY_Scaled
        ImageRenderStyle=MSTY_Alpha
        X1=0
        Y1=0
        X2=1024
        Y2=1024
    End Object
    i_Background=BackgroundImage'DH_Interface.PageBackground'

    PanelClass(0)="DH_Interface.DHBrowser_ServerListPageFavorites"
    PanelClass(1)="DH_Interface.DHBrowser_ServerListPageLAN"
    PanelClass(2)="DH_Interface.DHBrowser_ServerListPageInternet"
    PanelClass(3)=""
    PanelClass(4)=""
    PanelClass(5)=""
    PanelHint(0)="Choose a server to join from among your favorites"
    PanelHint(1)="View all DH servers currently running on your LAN"
    PanelHint(2)="Choose from DH servers across the world"
    PanelCaption(0)="Favorites"
    PanelCaption(1)="LAN"
    PanelCaption(2)="Internet"

    WelcomeMessageText="Welcome to Darkest Hour: Europe '44-'45! Be sure to join the 5000+ strong Discord community to discuss the game, make suggestions, or report any bugs! See you on the battlefield!"
    WelcomeMessageDiscordButtonText="Join Discord"
    WelcomeMessagePlayButtonText="Just play!"
    OnOpen=InternalOnOpen
}

