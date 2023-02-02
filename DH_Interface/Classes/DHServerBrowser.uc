//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DHServerBrowser extends ROUT2k4ServerBrowser;

var     config bool             bDidShowBetaMessage;
var     localized string        BetaMessageText;

function CreateTabs()
{
    super.CreateTabs();

    // Activate the Internet tab immediately
    c_Tabs.ActivateTabByName(PanelCaption[2], true);
}

function InternalOnOpen()
{
    local GUIQuestionPage QP;

    if (!bDidShowBetaMessage)
    {
        QP = Controller.ShowQuestionDialog(default.BetaMessageText, QBTN_OkCancel, QBTN_OK);
        QP.OnButtonClick = InternalOnButtonClick;
        QP.ButtonNames[0] = "Join Discord";
        QP.ButtonNames[1] = "Just play!";
        QP.SetupQuestion(default.BetaMessageText, QBTN_OkCancel, QBTN_OK, true);

        bDidShowBetaMessage = true;
        SaveConfig();
    }
}

function InternalOnButtonClick(byte bButton)
{
    switch (bButton)
    {
        case QBTN_OK:
            PlayerOwner().ConsoleCommand("START" @ class'DHMainMenu'.default.DiscordURL);
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
        Image=Texture'DH_GUI_Tex.Menu.MultiMenuBack'
        ImageStyle=ISTY_Scaled
        ImageRenderStyle=MSTY_Alpha
        X1=0
        Y1=0
        X2=1024
        Y2=1024
    End Object
    i_Background=BackgroundImage'DH_Interface.DHServerBrowser.PageBackground'

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

    BetaMessageText="Welcome to the Darkest Hour: Europe '44-'45 live beta! Be sure to join the 500+ strong Discord community to discuss the game, make suggestions, or report any bugs! See you on the battlefield!"
    OnOpen=InternalOnOpen
}

