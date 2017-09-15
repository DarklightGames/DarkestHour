//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2017
//==============================================================================

class DHMainMenu extends UT2K4GUIPage;

var()   config string           MenuSong;

var automated       FloatingImage           i_background, i_Overlay, i_Announcement;
var automated       GUIButton               b_QuickPlay, b_MultiPlayer, b_Practice, b_Settings, b_Host, b_Quit;
var automated       GUISectionBackground    sb_MainMenu, sb_HelpMenu, sb_ConfigFixMenu, sb_ShowVersion, sb_Social;
var automated       GUIButton               b_Credits, b_Manual, b_Demos, b_Website, b_Back, b_MOTDTitle, b_Facebook, b_GitHub, b_SteamCommunity, b_Patreon, b_Discord;
var automated       GUILabel                l_Version;
var automated       GUIImage                i_DHTextLogo;
var automated       DHGUIScrollTextBox      tb_MOTDContent;
var automated       GUIImage                i_MOTDLoading;
var automated       ROGUIProportionalContainerNoSkin c_MOTD;

var     HTTPRequest             QuickPlayRequest;
var     HTTPRequest             MOTDRequest;

var     string                  QuickPlayIp;
var     string                  MOTDURL;
var     string                  FacebookURL;
var     string                  GitHubURL;
var     string                  SteamCommunityURL;
var     string                  PatreonURL;
var     string                  DiscordURL;

var     localized string        QuickPlayString;
var     localized string        JoinTestServerString;
var     localized string        ConnectingString;
var     localized string        SteamMustBeRunningText;
var     localized string        SinglePlayerDisabledText;
var     localized string        MOTDErrorString;

var     bool                    bAllowClose;
var     int                     EllipseCount;
var     bool                    bShouldRequestMOTD;
var     bool                    bShouldRequestQuickPlayIP;
var     bool                    bIsRequestingQuickPlayIP;

var     config string           SavedVersion;
var     string                  ControlsChangedMessage;

delegate OnHideAnnouncement();

function InitComponent(GUIController MyController, GUIComponent MyOwner)
{
    super.InitComponent(MyController, MyOwner);

    sb_MainMenu.ManageComponent(b_QuickPlay);
    sb_MainMenu.ManageComponent(b_MultiPlayer);
    sb_MainMenu.ManageComponent(b_Practice);
    sb_MainMenu.ManageComponent(b_Settings);
    sb_MainMenu.ManageComponent(b_Quit);
    sb_MainMenu.ManageComponent(b_Credits);
    sb_ShowVersion.ManageComponent(l_Version);

    sb_Social.ManageComponent(b_Facebook);
    sb_Social.ManageComponent(b_GitHub);
    sb_Social.ManageComponent(b_SteamCommunity);
    sb_Social.ManageComponent(b_Patreon);
    sb_Social.ManageComponent(b_Discord);

    c_MOTD.ManageComponent(tb_MOTDContent);
    c_MOTD.ManageComponent(b_MOTDTitle);
    c_MOTD.ManageComponent(i_MOTDLoading);

    l_Version.Caption = class'DarkestHourGame'.default.Version.ToString();

    b_QuickPlay.Caption = default.JoinTestServerString;

    // Only show the quick-play button in pre-release builds (for easy joining of test server)
    if (!class'DarkestHourGame'.default.Version.IsPrerelease())
    {
        b_QuickPlay.Hide();
    }

    // If they have not changed their name from the default, change their
    // name to their Steam name!
    if (PlayerOwner() != none &&
        PlayerOwner().GetUrlOption("Name") ~= "DHPlayer" &&
        Controller != none &&
        Controller.SteamGetUserName() != "")
    {
        // This converts an underscore to a non-breaking space (0xA0)
        PlayerOwner().ConsoleCommand("SetName" @ Repl(Controller.SteamGetUserName(), "_", "�"));
    }
}

function ShowControlsChangedMessage()
{
    local GUIQuestionPage ConfirmWindow;

    ConfirmWindow = Controller.ShowQuestionDialog(ControlsChangedMessage, QBTN_YesNo, QBTN_Yes);
    ConfirmWindow.OnButtonClick = OnControlsChangedButtonClicked;
}

function OnControlsChangedButtonClicked(byte bButton)
{
    switch (bButton)
    {
        case QBTN_Yes:
            Controller.OpenMenu(Controller.GetSettingsPage());
            break;
        default:
            break;
    }
}

// Override to remove EULA confirmation
function InternalOnOpen()
{
    PlayerOwner().ClientSetInitialMusic(MenuSong, MTRAN_Segue);
}

// New function to bind a key to a command, but first checking it's safe to do so without messing up the player's controls config
// First checks whether our new key is already assigned to something - if it is then we don't make any changes
// Means the key is either already bound to what we want (so no need to change) or the player is using it for something else (so don't mess up his config)
// Secondly checks whether our new command is already bound to another key or keys - if it is bound to two keys then we don't make any changes
// But if the command is already bound to only one key, we'll also bound it to the new key, as the config menu can handle two key assignments
function SetKeyBindIfAvailable(string BindKeyName, string NewBoundCommand, optional string ExistingCommandCanBeOverriden)
{
    local array<string> ExistingAssignedKeys, s;
    local string        ExistingBoundCommand;

    Controller.GetCurrentBind(BindKeyName, ExistingBoundCommand); // finds any command that our key is already assigned to

    if (ExistingBoundCommand == "" || ExistingBoundCommand ~= ExistingCommandCanBeOverriden) // only proceed if our key isn't already bound or is bound to a command we want to override
    {
        Controller.GetAssignedKeys(NewBoundCommand, ExistingAssignedKeys, s); // finds any other keys already assigned to our command

        if (ExistingAssignedKeys.Length < 2) // only proceed if no more than one other key is already assigned to our command (we can add a 2nd if a slot is free)
        {
            if (ExistingBoundCommand != "") log("BINDING" @ NewBoundCommand @ "TO" @ BindKeyName @ "KEY, overriding existing command" @ ExistingBoundCommand);
            else log("BINDING" @ NewBoundCommand @ "TO" @ BindKeyName @ "KEY"); // TEMPDEBUG

            Controller.SetKeyBind(BindKeyName, NewBoundCommand);
        }
        else log(NewBoundCommand @ "is already bound to" @ ExistingAssignedKeys[0] @ "and" @ ExistingAssignedKeys[1] @ "keys"); // TEMPDEBUG
    }
    else log(BindKeyName @ "is already assigned to" @ ExistingBoundCommand); // TEMPDEBUG
}

function OnClose(optional bool bCanceled)
{
}

function bool MyKeyEvent(out byte Key, out byte State, float delta)
{
    if (Key == 0x1B && State == 1)
    {
        bAllowClose = true;
        return true;
    }
    else
    {
        return false;
    }
}

function bool CanClose(optional bool bCanceled)
{
    if (bAllowClose)
    {
        Controller.OpenMenu(Controller.GetQuitPage());
    }

    return false;
}

function bool ButtonClick(GUIComponent Sender)
{
    local GUIButton selected;

    if (GUIButton(Sender) != none)
    {
        selected = GUIButton(Sender);
    }

    switch (sender)
    {
        case b_QuickPlay:
            if (!Controller.CheckSteam())
            {
                Controller.ShowQuestionDialog(SteamMustBeRunningText, QBTN_Ok, QBTN_Ok);
            }
            else
            {
                GetQuickPlayIp();
            }
            break;

        case b_Practice:
            if (class'LevelInfo'.static.IsDemoBuild())
            {
                Controller.ShowQuestionDialog(SinglePlayerDisabledText, QBTN_Ok, QBTN_Ok);
            }
            else
            {
                Profile("InstantAction");
                Controller.OpenMenu(Controller.GetInstantActionPage());
                Profile("InstantAction");
            }
            break;

        case b_MultiPlayer:
            if (!Controller.CheckSteam())
            {
                Controller.ShowQuestionDialog(SteamMustBeRunningText, QBTN_Ok, QBTN_Ok);
            }
            else
            {
                Profile("ServerBrowser");
                Controller.OpenMenu(Controller.GetServerBrowserPage());
                Profile("ServerBrowser");
            }
            break;

        case b_Host:
            if (!Controller.CheckSteam())
            {
                Controller.ShowQuestionDialog(SteamMustBeRunningText, QBTN_Ok, QBTN_Ok);
            }
            else
            {
                Profile("MPHost");
                Controller.OpenMenu(Controller.GetMultiplayerPage());
                Profile("MPHost");
            }
            break;

        case b_Settings:
            Profile("Settings");
            Controller.OpenMenu(Controller.GetSettingsPage());
            Profile("Settings");
            break;

        case b_Credits:
            Controller.OpenMenu("DH_Interface.DHCreditsPage");
            break;

        case b_Quit:
            Profile("Quit");
            Controller.OpenMenu(Controller.GetQuitPage());
            Profile("Quit");
            break;

        case b_MOTDTitle:
            PlayerOwner().ConsoleCommand("START" @ MOTDURL);
            break;

        case b_Facebook:
            PlayerOwner().ConsoleCommand("START" @ default.FacebookURL);
            break;

        case b_GitHub:
            PlayerOwner().ConsoleCommand("START" @ default.GitHubURL);
            break;

        case b_SteamCommunity:
            PlayerOwner().ConsoleCommand("START" @ default.SteamCommunityURL);
            break;

        case b_Patreon:
            PlayerOwner().ConsoleCommand("START" @ default.PatreonURL);
            break;

        case b_Discord:
            PlayerOwner().ConsoleCommand("START" @ default.DiscordURL);
            break;

        case i_Overlay:
            HideAnnouncement();
            break;

        case i_Announcement:
            PlayerOwner().ConsoleCommand("START" @ default.PatreonURL);
            HideAnnouncement();
            break;
    }

    return true;
}

function ShowAnnouncement()
{
    i_Overlay.Show();
    i_Announcement.Show();
}

function HideAnnouncement()
{
    i_Overlay.Hide();
    i_Announcement.Hide();

    OnHideAnnouncement();
}

event Opened(GUIComponent Sender)
{
    local UVersion SavedVersionObject;

    sb_ShowVersion.SetVisibility(true);

    if (bDebugging)
    {
        Log(Name $ ".Opened()   Sender:" $ Sender, 'Debug');
    }

    if (Sender != none && PlayerOwner().Level.IsPendingConnection())
    {
        PlayerOwner().ConsoleCommand("CANCEL");
    }

    if (SavedVersion != class'DarkestHourGame'.default.Version.ToString())
    {
        SavedVersionObject = class'UVersion'.static.FromString(SavedVersion);

        // Matt: suggest add "alpha" so ppl using the dev build or who have played the v8-alpha test version will get the new smoke launcher and vehicle lock keys
        if (SavedVersionObject == none || SavedVersionObject.Major < 8) // || SavedVersionObject.Prerelease == "alpha")
        {
            // To make a long story short, we can't force the client to delete
            // their configuration file at will, so we need to forcibly create
            // control bindings for the new commands added in 8.0;
            Controller.SetKeyBind("I", "SquadTalk");
            Controller.SetKeyBind("Insert", "Speak Squad");
            Controller.SetKeyBind("CapsLock", "ShowOrderMenu | OnRelease HideOrderMenu");
            //Controller.SetKeyBind("L", "ToggleVehicleLock"); // Matt: want to add
            Controller.SetKeyBind("Minus", "DecreaseSmokeLauncherSetting");
            Controller.SetKeyBind("Equals", "IncreaseSmokeLauncherSetting");
            // TODO: fetch the defaults programmatically, this is sloppy!
            // Matt: suggested alternative below, using new SetKeyBindIfAvailable() function:
            /*
            SetKeyBindIfAvailable("I", "SquadTalk");
            SetKeyBindIfAvailable("Insert", "Speak Squad");
            SetKeyBindIfAvailable("CapsLock", "ShowOrderMenu | OnRelease HideOrderMenu");
            SetKeyBindIfAvailable("L", "ToggleVehicleLock");
            SetKeyBindIfAvailable("Minus", "DecreaseSmokeLauncherSetting", "ShrinkHUD"); // optional 3rd argument means it will override a current binding to the ShrinkHUD command
            SetKeyBindIfAvailable("Equals", "IncreaseSmokeLauncherSetting", "GrowHUD"); */
        }

        SavedVersion = class'DarkestHourGame'.default.Version.ToString();
        SaveConfig();
    }

    // Force voice quality to higher quality
    if (PlayerOwner().VoiceChatCodec != "CODEC_96WB" || PlayerOwner().ConsoleCommand("get Engine.PlayerController VoiceChatCodec") != "CODEC_96WB")
    {
        Log("Forcing codec to 96WB...");
        PlayerOwner().VoiceChatCodec = "CODEC_96WB";
        PlayerOwner().VoiceChatLANCodec = "CODEC_96WB";
        PlayerOwner().ConsoleCommand("set Engine.PlayerController VoiceChatCodec CODEC_96WB");
        PlayerOwner().ConsoleCommand("set Engine.PlayerController VoiceChatLANCodec CODEC_96WB");
        PlayerOwner().SaveConfig();
    }

    super.Opened(Sender);

    SetTimer(1.0, true);
}

event bool NotifyLevelChange()
{
    if (bDebugging)
    {
        Log(Name @ "NotifyLevelChange  PendingConnection:" $ PlayerOwner().Level.IsPendingConnection());
    }

    return PlayerOwner().Level.IsPendingConnection();
}

function OnQuickPlayResponse(int Status, TreeMap_string_string Headers, string Content)
{
    bShouldRequestQuickPlayIP = false;

    if (Status == 200)
    {
        PlayerOwner().ClientTravel(Content, TRAVEL_Absolute, false);
        Controller.CloseAll(false, true);
    }
    else
    {
        Log("OnQuickPlayResponse failed:" @ Status @ Content);
    }

    b_QuickPlay.Caption = default.JoinTestServerString;

    QuickPlayRequest = none;
}

function OnMOTDResponse(int Status, TreeMap_string_string Headers, string Content)
{
    local string Title;

    if (Status == 200)
    {
        // Remove all \r (carriage return) characters
        Content = Repl(Content, Chr(13), "");

        // Colin: Once we get JSON parsing, we can make this cleaner.
        // For the time being, we will say that the first line is the title,
        // second line is the URL, and everything else is the content.
        Divide(Content, Chr(10), Title, Content);
        Divide(Content, Chr(10), MOTDURL, Content);

        // Replace all \n (line feed) characters with engine equivalent.
        Content = Repl(Content, Chr(10), "|");

        b_MOTDTitle.Caption = Caps(Title);
        tb_MOTDContent.MyScrollText.SetContent(Content);
    }
    else
    {
        b_MOTDTitle.Caption = "Error";
        tb_MOTDContent.MyScrollText.SetContent(Repl(default.MOTDErrorString, "{0}", Status));
    }

    MOTDRequest = none;

    i_MOTDLoading.SetVisibility(false);
}

// Quick play button functions
event Timer()
{
    local int i;

    if (bIsRequestingQuickPlayIP)
    {
        b_QuickPlay.Caption = ConnectingString;

        for (i = 0; i <= EllipseCount; ++i)
        {
            b_QuickPlay.Caption $= ".";
        }

        EllipseCount = ++EllipseCount % 3;
    }

    if (bShouldRequestMOTD)
    {
        GetMOTD();

        bShouldRequestMOTD = false;
    }
}

function GetMOTD()
{
    if (MOTDRequest != none)
    {
        return;
    }

    MOTDRequest = PlayerOwner().Spawn(class'HTTPRequest');
    MOTDRequest.Host = "darkesthour.darklightgames.com";
    MOTDRequest.Path = "/client/motd.php";
    MOTDRequest.OnResponse = OnMOTDResponse;
    MOTDRequest.Send();

    b_MOTDTitle.Caption = "";
    tb_MOTDContent.MyScrollText.SetContent("");
    i_MOTDLoading.SetVisibility(true);
}

function GetQuickPlayIp()
{
    QuickPlayRequest = PlayerOwner().Spawn(class'HTTPRequest');
    QuickPlayRequest.Host = "darkesthour.darklightgames.com";

    if (class'DarkestHourGame'.default.Version.IsPrerelease())
    {
        QuickPlayRequest.Path = "/client/betaserverip.php";
    }
    else
    {
        QuickPlayRequest.Path = "/client/quickplayip.php";
    }

    QuickPlayRequest.OnResponse = OnQuickPlayResponse;
    QuickPlayRequest.Send();

    bIsRequestingQuickPlayIP = true;

    Timer();
}

defaultproperties
{
    // IP variables
    QuickPlayString="Quick Join"
    JoinTestServerString="Join Test Server"
    ConnectingString="Joining"

    // Menu variables
    Begin Object Class=FloatingImage Name=FloatingBackground
        Image=material'DH_GUI_Tex.MainMenu.BackGround'
        DropShadow=none
        ImageStyle=ISTY_Scaled
        WinTop=0.0
        WinLeft=0.0
        WinWidth=1.0
        WinHeight=1.0
        RenderWeight=0.000003
    End Object
    i_Background=FloatingImage'DH_Interface.DHMainMenu.FloatingBackground'

    Begin Object Class=FloatingImage Name=OverlayBackground
        Image=texture'Engine.BlackTexture'
        DropShadow=none
        ImageStyle=ISTY_Scaled
        WinTop=0.0
        WinLeft=0.0
        WinWidth=1.0
        WinHeight=1.0
        RenderWeight=1.0
        ImageColor=(R=0,G=0,B=0,A=192)
        bCaptureMouse=true
        bAcceptsInput=true
        OnClick=DHMainMenu.ButtonClick
        bVisible=false
    End Object
    i_Overlay=FloatingImage'DH_Interface.DHMainMenu.OverlayBackground'

    Begin Object Class=FloatingImage Name=AnnouncementImage
        Image=texture'DH_GUI_Tex.MainMenu.patreon_announce_image'
        DropShadow=none
        ImageStyle=ISTY_Justified
        WinTop=0.1
        WinLeft=0.25
        WinWidth=0.5
        WinHeight=0.8
        RenderWeight=1.0
        bCaptureMouse=true
        bAcceptsInput=true
        OnClick=DHMainMenu.ButtonClick
        bVisible=false
    End Object
    i_Announcement=FloatingImage'DH_Interface.DHMainMenu.AnnouncementImage'

    Begin Object Class=ROGUIContainerNoSkinAlt Name=sbSection1
        WinTop=0.25
        WinLeft=0.025
        WinWidth=0.2
        WinHeight=0.75
        OnPreDraw=sbSection1.InternalPreDraw
    End Object
    sb_MainMenu=ROGUIContainerNoSkinAlt'DH_Interface.DHMainMenu.sbSection1'

    Begin Object Class=ROGUIContainerNoSkinAlt Name=SocialSection
        WinTop=0.9125
        WinLeft=0.55
        WinWidth=0.4
        WinHeight=0.0875
        OnPreDraw=sbSection1.InternalPreDraw
        NumColumns=5
    End Object
    sb_Social=SocialSection

    Begin Object class=GUIButton Name=QuickPlayButton
        CaptionAlign=TXTA_Left
        Caption="Join Test Server"
        bAutoShrink=false
        bUseCaptionHeight=true
        FontScale=FNS_Large
        StyleName="DHMenuTextButtonWhiteStyleHuge"
        TabOrder=1
        bFocusOnWatch=true
        OnClick=DHMainMenu.ButtonClick
        OnKeyEvent=QuickPlayButton.InternalOnKeyEvent
    End Object
    b_QuickPlay=GUIButton'DH_Interface.DHMainMenu.QuickPlayButton'

    Begin Object Class=GUIButton Name=ServerButton
        CaptionAlign=TXTA_Left
        Caption="Server Browser"
        bAutoShrink=false
        bUseCaptionHeight=true
        FontScale=FNS_Large
        StyleName="DHMenuTextButtonWhiteStyleHuge"
        TabOrder=2
        bFocusOnWatch=true
        OnClick=DHMainMenu.ButtonClick
        OnKeyEvent=ServerButton.InternalOnKeyEvent
    End Object
    b_MultiPlayer=GUIButton'DH_Interface.DHMainMenu.ServerButton'

    Begin Object Class=GUIButton Name=InstantActionButton
        CaptionAlign=TXTA_Left
        Caption="Practice"
        bAutoShrink=false
        bUseCaptionHeight=true
        FontScale=FNS_Large
        StyleName="DHMenuTextButtonWhiteStyleHuge"
        TabOrder=3
        bFocusOnWatch=true
        OnClick=DHMainMenu.ButtonClick
        OnKeyEvent=InstantActionButton.InternalOnKeyEvent
    End Object
    b_Practice=GUIButton'DH_Interface.DHMainMenu.InstantActionButton'

    Begin Object Class=GUIButton Name=SettingsButton
        CaptionAlign=TXTA_Left
        Caption="Settings"
        bAutoShrink=false
        bUseCaptionHeight=true
        FontScale=FNS_Large
        StyleName="DHMenuTextButtonWhiteStyleHuge"
        TabOrder=4
        bFocusOnWatch=true
        OnClick=DHMainMenu.ButtonClick
        OnKeyEvent=SettingsButton.InternalOnKeyEvent
    End Object
    b_Settings=GUIButton'DH_Interface.DHMainMenu.SettingsButton'

    Begin Object Class=GUIButton Name=CreditsButton
        CaptionAlign=TXTA_Left
        Caption="Credits"
        bAutoShrink=false
        bUseCaptionHeight=true
        FontScale=FNS_Large
        StyleName="DHMenuTextButtonWhiteStyleHuge"
        TabOrder=5
        bFocusOnWatch=true
        OnClick=DHMainMenu.ButtonClick
        OnKeyEvent=CreditsButton.InternalOnKeyEvent
    End Object
    b_Credits=GUIButton'DH_Interface.DHMainMenu.CreditsButton'

    Begin Object Class=GUIButton Name=QuitButton
        CaptionAlign=TXTA_Left
        Caption="Exit"
        bAutoShrink=false
        bUseCaptionHeight=true
        FontScale=FNS_Large
        StyleName="DHMenuTextButtonWhiteStyleHuge"
        TabOrder=6
        bFocusOnWatch=true
        OnClick=DHMainMenu.ButtonClick
        OnKeyEvent=QuitButton.InternalOnKeyEvent
    End Object
    b_Quit=GUIButton'DH_Interface.DHMainMenu.QuitButton'

    Begin Object class=ROGUIContainerNoSkinAlt Name=sbSection2
        WinTop=0.624
        WinLeft=0.042188
        WinWidth=0.485
        WinHeight=0.2355
        OnPreDraw=sbSection2.InternalPreDraw
    End Object
    sb_HelpMenu=ROGUIContainerNoSkinAlt'DH_Interface.DHMainMenu.sbSection2'

    Begin Object Class=GUIButton Name=MOTDTitleButton
        CaptionAlign=TXTA_Left
        Caption=""
        bAutoShrink=false
        bUseCaptionHeight=true
        FontScale=FNS_Large
        StyleName="DHMenuTextButtonWhiteStyle"
        TabOrder=7
        bFocusOnWatch=true
        OnClick=DHMainMenu.ButtonClick
        OnKeyEvent=MOTDTitleButton.InternalOnKeyEvent
        WinWidth=1.0
        WinHeight=0.1
        WinLeft=0.0
        WinTop=0.0
    End Object
    b_MOTDTitle=MOTDTitleButton

    Begin Object Class=GUIGFXButton Name=FacebookButton
        WinWidth=0.04
        WinHeight=0.075
        WinLeft=0.875
        WinTop=0.925
        OnClick=DHMainMenu.ButtonClick
        Graphic=texture'DH_GUI_Tex.MainMenu.facebook'
        TabOrder=1
        bTabStop=true
        Position=ICP_Center
        Hint="Follow us on Facebook!"
        bRepeatClick=false
        StyleName="TextLabel"
    End Object
    b_Facebook=FacebookButton

    Begin Object Class=GUIGFXButton Name=GitHubButton
        WinWidth=0.04
        WinHeight=0.075
        WinLeft=0.875
        WinTop=0.925
        OnClick=DHMainMenu.ButtonClick
        Graphic=texture'DH_GUI_Tex.MainMenu.github'
        bTabStop=true
        Position=ICP_Center
        Hint="Join us on GitHub!"
        bRepeatClick=false
        StyleName="TextLabel"
    End Object
    b_GitHub=GitHubButton

    Begin Object Class=GUIGFXButton Name=SteamCommunityButton
        WinWidth=0.04
        WinHeight=0.075
        WinLeft=0.875
        WinTop=0.925
        OnClick=DHMainMenu.ButtonClick
        Graphic=texture'DH_GUI_Tex.MainMenu.steam'
        bTabStop=true
        Position=ICP_Center
        Hint="Join the Steam Community!"
        bRepeatClick=false
        StyleName="TextLabel"
    End Object
    b_SteamCommunity=SteamCommunityButton

    Begin Object Class=GUIGFXButton Name=PatreonButton
        WinWidth=0.04
        WinHeight=0.075
        WinLeft=0.875
        WinTop=0.925
        OnClick=DHMainMenu.ButtonClick
        Graphic=texture'DH_GUI_Tex.MainMenu.patreon'
        bTabStop=true
        Position=ICP_Center
        Hint="Support us on Patreon!"
        bRepeatClick=false
        StyleName="TextLabel"
    End Object
    b_Patreon=PatreonButton

    Begin Object Class=GUIGFXButton Name=DiscordButton
        WinWidth=0.04
        WinHeight=0.075
        WinLeft=0.875
        WinTop=0.925
        OnClick=DHMainMenu.ButtonClick
        Graphic=texture'DH_GUI_Tex.MainMenu.discord'
        bTabStop=true
        Position=ICP_Center
        Hint="Join us in Discord!"
        bRepeatClick=false
        StyleName="TextLabel"
    End Object
    b_Discord=DiscordButton

    Begin Object Class=ROGUIContainerNoSkinAlt Name=sbSection3
        WinWidth=0.261250
        WinHeight=0.026563
        WinLeft=0.712799
        WinTop=0.185657
        OnPreDraw=sbSection3.InternalPreDraw
    End Object
    sb_ShowVersion=ROGUIContainerNoSkinAlt'DH_Interface.DHMainMenu.sbSection3'

    Begin Object class=GUILabel Name=VersionNum
        StyleName="DHSmallText"
        TextAlign=TXTA_Right
        WinWidth=1.0
        WinHeight=1.0
        WinLeft=0.0
        WinTop=0.0
        RenderWeight=20.7
    End Object
    l_Version=GUILabel'DH_Interface.DHMainMenu.VersionNum'

    Begin Object class=GUIImage Name=LogoImage
        Image=texture'DH_GUI_Tex.Menu.DHTextLogo'
        ImageColor=(R=255,G=255,B=255,A=255)
        ImageRenderStyle=MSTY_Alpha
        ImageStyle=ISTY_Justified
        ImageAlign=IMGA_BottomRight
        WinWidth=0.867656
        WinHeight=0.197539
        WinLeft=0.130391
        WinTop=0.0
    End Object
    i_DHTextLogo=LogoImage

    Begin Object class=GUIImage Name=MOTDLoadingImage
        Image=TexRotator'DH_GUI_Tex.MainMenu.LoadingRotator'
        ImageColor=(R=255,G=255,B=255,A=255)
        ImageRenderStyle=MSTY_Alpha
        ImageStyle=ISTY_Justified
        ImageAlign=IMGA_BottomRight
        WinWidth=0.33
        WinHeight=0.33
        WinLeft=0.33
        WinTop=0.33
    End Object
    i_MOTDLoading=MOTDLoadingImage

    Begin Object Class=DHGUIScrollTextBox Name=MyMOTDText
        bNoTeletype=true
        CharDelay=0.05
        EOLDelay=0.1
        bVisibleWhenEmpty=true
        OnCreateComponent=MyMOTDText.InternalOnCreateComponent
        StyleName="DHLargeText"
        WinTop=0.1
        WinLeft=0.0
        WinWidth=1.0
        WinHeight=0.9
        RenderWeight=0.6
        TabOrder=1
        bNeverFocus=true
    End Object
    tb_MOTDContent=DHGUIScrollTextBox'DH_Interface.DHMainMenu.MyMOTDText'

    Begin Object Class=ROGUIProportionalContainerNoSkin Name=sbSection4
        WinTop=0.25
        WinLeft=0.55
        WinWidth=0.4
        WinHeight=0.65
        OnPreDraw=sbSection4.InternalPreDraw
    End Object
    c_MOTD=sbSection4

    SteamMustBeRunningText="Steam must be running and you must have an active internet connection to play multiplayer"
    SinglePlayerDisabledText="Practice mode is only available in the full version."
    MenuSong="DH_Menu_Music"
    BackgroundColor=(B=0,G=0,R=0)
    InactiveFadeColor=(B=0,G=0,R=0)
    OnOpen=InternalOnOpen
    WinTop=0.0
    WinHeight=1.0
    MOTDErrorString="Error: Could not download news feed ({0})"
    bShouldRequestMOTD=true
    GitHubURL="http://github.com/DarklightGames/DarkestHour/wiki"
    FacebookURL="http://www.facebook.com/darkesthourgame"
    SteamCommunityURL="http://steamcommunity.com/app/1280"
    PatreonURL="http://www.patreon.com/darkesthourgame"
    DiscordURL="http://discord.gg/EEwFhtk"
    ControlsChangedMessage="New controls have been added to the game. As a result, your previous control bindings may have been changed.||Do you want to review your control settings?"
}
