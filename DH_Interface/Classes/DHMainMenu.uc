//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DHMainMenu extends UT2K4GUIPage;

var automated       FloatingImage       i_background;
var automated       GUISectionBackground    sb_MainMenu;
var automated       GUIButton       b_QuickPlay, b_MultiPlayer, b_Practice, b_Settings, b_Help, b_Host, b_Quit;
var automated       GUISectionBackground    sb_HelpMenu;
var automated       GUIButton           b_Credits, b_Manual, b_Demos, b_Website, b_Back;
var automated       GUISectionBackground           sb_ShowVersion;
var automated       GUILabel        l_Version;
var bool            AllowClose;
var localized string    ManualURL;
var string          WebsiteURL;
var localized string SteamMustBeRunningText;
var localized string SinglePlayerDisabledText;
var() config string     MenuSong;

//Quick Play Variables
var ROBufferedTCPLink myLink;

var string waitString;
var string quickplayip;
var string LinkClassName;
var string getRequest;
var string getResponse;
var string newsIPAddr;

var int     myRetryCount;
var int     myRetryMax;

var float   ReReadyPause;

var bool bAttemptQuickPlay;
var bool sendGet;
var bool pageWait;

//Other
var localized string VersionString;
var globalconfig bool AcceptedEULA;

function InitComponent(GUIController MyController, GUIComponent MyOwner)
{
    local int xl,yl,y;
    super.InitComponent(MyController, MyOwner);
    Controller.LCDCls();
    Controller.LCDDrawTile(Controller.LCDLogo, 0, 0, 50, 43, 0, 0, 50, 43);
    y = 0;
    Controller.LCDStrLen("Darkest Hour",Controller.LCDMedFont,xl,yl);
    Controller.LCDDrawText("Darkest Hour",(100-(XL/2)),y,Controller.LCDMedFont);
    y += 14;
    Controller.LCDStrLen("Europe",Controller.LCDSmallFont,xl,yl);
    Controller.LCDDrawText("Europe",(100-(XL/2)),y,Controller.LCDSmallFont);
    y += 14;
    Controller.LCDStrLen("44-45",Controller.LCDLargeFont,xl,yl);
    Controller.LCDDrawText("44-45",(100-(XL/2)),y,Controller.LCDLargeFont);
    Controller.LCDRepaint();

    sb_MainMenu.ManageComponent(b_QuickPlay);
    sb_MainMenu.ManageComponent(b_MultiPlayer);
    sb_MainMenu.ManageComponent(b_Practice);
    sb_MainMenu.ManageComponent(b_Settings);
    sb_MainMenu.ManageComponent(b_Help);
    sb_MainMenu.ManageComponent(b_Host);
    sb_MainMenu.ManageComponent(b_Quit);
    sb_HelpMenu.ManageComponent(b_Credits);
    sb_HelpMenu.ManageComponent(b_Manual);
    sb_HelpMenu.ManageComponent(b_Demos);
    sb_HelpMenu.ManageComponent(b_Website);
    sb_HelpMenu.ManageComponent(b_Back);
    sb_ShowVersion.ManageComponent(l_Version);

    //Quick Play Init
    GetQuickPlayIP();
}

function InternalOnOpen()
{
        Log("MainMenu: starting music "$MenuSong);
        PlayerOwner().ClientSetInitialMusic(MenuSong,MTRAN_Segue);
}

function OnClose(optional bool bCanceled)
{
}

function ShowSubMenu(int menu_id)
{
        switch (menu_id)
        {
                case 0:
                        sb_MainMenu.SetVisibility(true);
                        sb_HelpMenu.SetVisibility(false);
                        break;

                case 1:
                        sb_MainMenu.SetVisibility(false);
                        sb_HelpMenu.SetVisibility(true);
                        break;
        }
}

function bool MyKeyEvent(out byte Key,out byte State,float delta)
{
    if (Key == 0x1B && State == 1)
    {
        AllowClose = true;
        return true;
    }
    else
        return false;
}

function bool CanClose(optional bool bCanceled)
{
    if (AllowClose)
        Controller.OpenMenu(Controller.GetQuitPage());

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
            bAttemptQuickPlay = true;
            if (quickplayip != "")
            {
                PlayerOwner().ClientTravel(quickplayip, TRAVEL_Absolute, false);
                Controller.CloseAll(false, true);
            }
            break;

        case b_Practice:
            if (class'LevelInfo'.static.IsDemoBuild())
            {
                Controller.OpenMenu(Controller.QuestionMenuClass);
                GUIQuestionPage(Controller.TopPage()).SetupQuestion(SinglePlayerDisabledText, QBTN_Ok, QBTN_Ok);
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
                Controller.OpenMenu(Controller.QuestionMenuClass);
                GUIQuestionPage(Controller.TopPage()).SetupQuestion(SteamMustBeRunningText, QBTN_Ok, QBTN_Ok);
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
                Controller.OpenMenu(Controller.QuestionMenuClass);
                GUIQuestionPage(Controller.TopPage()).SetupQuestion(SteamMustBeRunningText, QBTN_Ok, QBTN_Ok);
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

        case b_Manual:
            Profile("Manual");
            PlayerOwner().ConsoleCommand("start "@ManualURL);
            Profile("Manual");
            break;

        case b_Website:
            Profile("Website");
            PlayerOwner().ConsoleCommand("start "@WebsiteURL);
            Profile("Website");
            break;

        case b_Demos:
            Controller.OpenMenu("ROInterface.RODemosMenu");
            break;

        case b_Help:
            ShowSubMenu(1);
            break;

        case b_Back:
            ShowSubMenu(0);
            break;
    }
    return true;
}

event Opened(GUIComponent Sender)
{
    //l_Version.Caption = VersionString;
    //sb_ShowVersion.SetVisibility(true);

    if (bDebugging)
        Log(Name$".Opened()   Sender:"$Sender,'Debug');

     if (Sender != none && PlayerOwner().Level.IsPendingConnection())
            PlayerOwner().ConsoleCommand("CANCEL");
         ShowSubMenu(0);
         super.Opened(Sender);
}

function LoadMenuLevel()
{
}

event bool NotifyLevelChange()
{
    if (bDebugging)
        Log(Name@"NotifyLevelChange  PendingConnection:"$PlayerOwner().Level.IsPendingConnection());
        return PlayerOwner().Level.IsPendingConnection();
}

//Quick Play Button Functions
event Timer()
{
    local string text;
    local string page;
    local string command;

    Log("IsConnected?:"@myLink.IsConnected());

    if (myLink != none)
    {
        if (myLink.ServerIpAddr.Port != 0 && myLink.IsConnected())
        {
            if (sendGet)
            {
                 command = getRequest$myLink.CRLF$"Host: "$newsIPAddr$myLink.CRLF$myLink.CRLF;
                 myLink.SendCommand(command);
                 pageWait = true;
                 myLink.WaitForCount(1,20,1); // 20 sec timeout
                 sendGet = false;
            }
            else if (bAttemptQuickPlay)
            {
                 waitString = waitString$".";
                 b_QuickPlay.Caption = waitString;
            }
        }
        if (myLink.PeekChar() != 0)
        {
            pageWait = false;
            // data waiting
            page = "";
            while(myLink.ReadBufferedLine(text))
            {
                page = page$text;
            }
            HTTPParse(page);
            waitString = page;
            quickplayip = waitString; //Sets the quickplay ip for the quick play button
            myLink.DestroyLink();
            myLink = none;
            KillTimer();

            if (bAttemptQuickPlay)
            {
                Log(" ");
                Log(" ");
                Log("IP:"@quickplayip);
                Log(" ");
                Log(" ");
                PlayerOwner().ClientTravel(quickplayip, TRAVEL_Absolute, false);
                Controller.CloseAll(false, true);
            }
        }
    }
    SetTimer(ReReadyPause, true);
}

protected function ROBufferedTCPLink CreateNewLink()
{
    local class<ROBufferedTCPLink> NewLinkClass;
    local ROBufferedTCPLink NewLink;

    if (PlayerOwner() == none)
        return none;

    if (LinkClassName != "")
    {
        NewLinkClass = class<ROBufferedTCPLink>(DynamicLoadObject(LinkClassName, class'class'));
    }
    if (NewLinkClass != none)
    {
        NewLink = PlayerOwner().Spawn(NewLinkClass);
    }

    NewLink.ResetBuffer();

    return NewLink;
}

function GetQuickPlayIP()
{
    if (myLink == none)
    {
        myLink = CreateNewLink();
    }
    if (myLink != none)
    {
        myLink.ServerIpAddr.Port = 0;

        sendGet = true;
        myLink.Resolve(newsIPAddr);  // NOTE: This is a non-blocking operation

        SetTimer(ReReadyPause, true);
    }
    else
    {
        waitString = waitString@"No Server Info Found";
    }
}

//Used for parsing the string out of <BODY> </BODY>
//Needed becasue the get request returns stuff other than the text in the file
function HTTPParse(out string page)
{
    local string junk;
    local int i;

    junk = page;
    Caps(junk);
    i = InStr(junk, "<BODY>");

    if (i > -1)
    {
         // remove all header from string
         page = Right(page, len(page) - i - 6);
    }

    junk = page;
    Caps(junk);
    i = InStr(junk, "</BODY>");

    if (i > -1)
    {
         // remove all footers from string
         page = Left(page,i);
    }

    page = Repl(page, "<br>", "|", false);
}

defaultproperties
{
    //IP Variables
    waitString = "Join Test Server"
    newsIPAddr = "darkesthourgame.com"
    getRequest = "GET /quickplayip.php HTTP/1.1"
    ReReadyPause=0.250000
    myRetryCount=0
    myRetryMax=40
    LinkClassName="ROInterface.ROBufferedTCPLink"
    sendGet = true;
    //Menu Variables
    Begin Object Class=FloatingImage Name=FloatingBackground
        Image=texture'DH_GUI_Tex.Menu.MainBackGround'
        DropShadow=none
        ImageStyle=ISTY_Scaled
        WinTop=0.000000
        WinLeft=0.000000
        WinWidth=1.000000
        WinHeight=1.000000
        RenderWeight=0.000003
    End Object
    i_Background=FloatingImage'DH_Interface.DHMainMenu.FloatingBackground'
    Begin Object Class=ROGUIContainerNoSkinAlt Name=sbSection1
        WinTop=0.624000
        WinLeft=0.042188
        WinWidth=0.485000
        WinHeight=0.281354
        OnPreDraw=sbSection1.InternalPreDraw
    End Object
    sb_MainMenu=ROGUIContainerNoSkinAlt'DH_Interface.DHMainMenu.sbSection1'
    Begin Object class=GUIButton Name=QuickPlayButton
        CaptionAlign=TXTA_Left
        Caption="Join Test Server"
        bAutoShrink=false
        bUseCaptionHeight=true
        FontScale=FNS_Large
        StyleName="DHMenuTextButtonStyle"
        TabOrder=1
        bFocusOnWatch=true
        OnClick=DHMainMenu.ButtonClick
        OnKeyEvent=QuickPlayButton.InternalOnKeyEvent
    End Object
    b_QuickPlay=GUIButton'DH_Interface.DHMainMenu.QuickPlayButton'
    Begin Object Class=GUIButton Name=ServerButton
        CaptionAlign=TXTA_Left
        Caption="Multiplayer"
        bAutoShrink=false
        bUseCaptionHeight=true
        FontScale=FNS_Large
        StyleName="DHMenuTextButtonStyle"
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
        StyleName="DHMenuTextButtonStyle"
        TabOrder=3
        bFocusOnWatch=true
        OnClick=DHMainMenu.ButtonClick
        OnKeyEvent=InstantActionButton.InternalOnKeyEvent
    End Object
    b_Practice=GUIButton'DH_Interface.DHMainMenu.InstantActionButton'
    Begin Object Class=GUIButton Name=SettingsButton
        CaptionAlign=TXTA_Left
        Caption="Configuration"
        bAutoShrink=false
        bUseCaptionHeight=true
        FontScale=FNS_Large
        StyleName="DHMenuTextButtonStyle"
        TabOrder=4
        bFocusOnWatch=true
        OnClick=DHMainMenu.ButtonClick
        OnKeyEvent=SettingsButton.InternalOnKeyEvent
    End Object
    b_Settings=GUIButton'DH_Interface.DHMainMenu.SettingsButton'
    Begin Object Class=GUIButton Name=HelpButton
        CaptionAlign=TXTA_Left
        Caption="Help & Game Management"
        bAutoShrink=false
        bUseCaptionHeight=true
        FontScale=FNS_Large
        StyleName="DHMenuTextButtonStyle"
        TabOrder=5
        bFocusOnWatch=true
        OnClick=DHMainMenu.ButtonClick
        OnKeyEvent=HelpButton.InternalOnKeyEvent
    End Object
    b_Help=GUIButton'DH_Interface.DHMainMenu.HelpButton'
    Begin Object Class=GUIButton Name=HostButton
        CaptionAlign=TXTA_Left
        Caption="Host Game"
        bAutoShrink=false
        bUseCaptionHeight=true
        FontScale=FNS_Large
        StyleName="DHMenuTextButtonStyle"
        TabOrder=6
        bFocusOnWatch=true
        OnClick=DHMainMenu.ButtonClick
        OnKeyEvent=HostButton.InternalOnKeyEvent
    End Object
    b_Host=GUIButton'DH_Interface.DHMainMenu.HostButton'
    Begin Object Class=GUIButton Name=QuitButton
        CaptionAlign=TXTA_Left
        Caption="Exit"
        bAutoShrink=false
        bUseCaptionHeight=true
        FontScale=FNS_Large
        StyleName="DHMenuTextButtonStyle"
        TabOrder=7
        bFocusOnWatch=true
        OnClick=DHMainMenu.ButtonClick
        OnKeyEvent=QuitButton.InternalOnKeyEvent
    End Object
    b_Quit=GUIButton'DH_Interface.DHMainMenu.QuitButton'
    Begin Object Class=ROGUIContainerNoSkinAlt Name=sbSection2
        WinTop=0.624000
        WinLeft=0.042188
        WinWidth=0.485000
        WinHeight=0.235500
        OnPreDraw=sbSection2.InternalPreDraw
    End Object
    sb_HelpMenu=ROGUIContainerNoSkinAlt'DH_Interface.DHMainMenu.sbSection2'
    Begin Object Class=GUIButton Name=CreditsButton
        CaptionAlign=TXTA_Left
        Caption="Credits"
        bAutoShrink=false
        bUseCaptionHeight=true
        FontScale=FNS_Large
        StyleName="DHMenuTextButtonStyle"
        TabOrder=11
        bFocusOnWatch=true
        OnClick=DHMainMenu.ButtonClick
        OnKeyEvent=CreditsButton.InternalOnKeyEvent
    End Object
    b_Credits=GUIButton'DH_Interface.DHMainMenu.CreditsButton'
    Begin Object Class=GUIButton Name=ManualButton
        CaptionAlign=TXTA_Left
        Caption="Manual"
        bAutoShrink=false
        bUseCaptionHeight=true
        FontScale=FNS_Large
        StyleName="DHMenuTextButtonStyle"
        TabOrder=12
        bFocusOnWatch=true
        OnClick=DHMainMenu.ButtonClick
        OnKeyEvent=ManualButton.InternalOnKeyEvent
    End Object
    b_Manual=GUIButton'DH_Interface.DHMainMenu.ManualButton'
    Begin Object Class=GUIButton Name=DemosButton
        CaptionAlign=TXTA_Left
        Caption="Demo Management"
        bAutoShrink=false
        bUseCaptionHeight=true
        FontScale=FNS_Large
        StyleName="DHMenuTextButtonStyle"
        TabOrder=13
        bFocusOnWatch=true
        OnClick=DHMainMenu.ButtonClick
        OnKeyEvent=DemosButton.InternalOnKeyEvent
    End Object
    b_Demos=GUIButton'DH_Interface.DHMainMenu.DemosButton'
    Begin Object Class=GUIButton Name=WebsiteButton
        CaptionAlign=TXTA_Left
        Caption="Visit Website"
        bAutoShrink=false
        bUseCaptionHeight=true
        FontScale=FNS_Large
        StyleName="DHMenuTextButtonStyle"
        TabOrder=14
        bFocusOnWatch=true
        OnClick=DHMainMenu.ButtonClick
        OnKeyEvent=WebsiteButton.InternalOnKeyEvent
    End Object
    b_Website=GUIButton'DH_Interface.DHMainMenu.WebsiteButton'
    Begin Object Class=GUIButton Name=BackButton
        CaptionAlign=TXTA_Left
        Caption="Back"
        bAutoShrink=false
        bUseCaptionHeight=true
        FontScale=FNS_Large
        StyleName="DHMenuTextButtonStyle"
        TabOrder=15
        bFocusOnWatch=true
        OnClick=DHMainMenu.ButtonClick
        OnKeyEvent=BackButton.InternalOnKeyEvent
    End Object
    b_Back=GUIButton'DH_Interface.DHMainMenu.BackButton'
    Begin Object Class=ROGUIContainerNoSkinAlt Name=sbSection3
        WinTop=0.010000
        WinLeft=0.010000
        WinWidth=0.230000
        WinHeight=0.050000
        OnPreDraw=sbSection3.InternalPreDraw
    End Object
    sb_ShowVersion=ROGUIContainerNoSkinAlt'DH_Interface.DHMainMenu.sbSection3'
    Begin Object Class=GUILabel Name=VersionNum
        StyleName="DHSmallText"
        WinTop=0.020000
        WinLeft=0.020000
        WinWidth=0.202128
        WinHeight=0.040000
        RenderWeight=20.700001
    End Object
    l_Version=GUILabel'DH_Interface.DHMainMenu.VersionNum'
    ManualURL="http://www.darkesthourgame.com"
    WebsiteURL="http://www.darkesthourgame.com"
    SteamMustBeRunningText="Steam must be running and you must have an active internet connection to play multiplayer"
    SinglePlayerDisabledText="Practice mode is only available in the full version."
    MenuSong="DH_Menu_Music"
    VersionString="DH Version: Beta 3.0"
    AcceptedEULA=true
    BackgroundColor=(B=0,G=0,R=0)
    InactiveFadeColor=(B=0,G=0,R=0)
    OnOpen=DHMainMenu.InternalOnOpen
    WinTop=0.000000
    WinHeight=1.000000
}
