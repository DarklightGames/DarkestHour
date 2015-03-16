//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================
class DHDeployMenu extends UT2K4GUIPage;

var automated ROGUIProportionalContainer    MenuOptionsContainer;

var automated FloatingImage                 i_background;

var automated DHGUIButton                   b_MenuButton,
                                            b_MenuOptions[10];

var localized string                        MenuOptions[10];

var automated GUITabControl                 c_LoadoutArea;
var automated GUITabControl                 c_DeploymentMapArea;

var array<string>                           DeploymentPanelClass;
var localized array<string>                 DeploymentPanelCaption;
var localized array<string>                 DeploymentPanelHint;

var array<string>                           LoadoutPanelClass;
var localized array<string>                 LoadoutPanelCaption;
var localized array<string>                 LoadoutPanelHint;

var bool                                    bReceivedTeam, bShowingMenuOptions, bSpawningVehicle;

function InitComponent(GUIController MyController, GUIComponent MyOwner)
{
    local int i;
    local PlayerController pc;

    Super.InitComponent(MyController, MyOwner);

    // Initialize menu options
    InitializeMenuOptions();

    // Check if the player doesn't have a team
    if (PlayerOwner().PlayerReplicationInfo.Team == none)
    {
        // We haven't got a team yet, lets tell timer to try again!
        bReceivedTeam = false;
    }
    else
    {
        //We have a team!
        bReceivedTeam = true;

        // Initialize loadout panels
        for (i = 0;i<LoadoutPanelClass.Length;++i)
        {
            c_LoadoutArea.AddTab(LoadoutPanelCaption[i],LoadoutPanelClass[i],,LoadoutPanelHint[i]);
        }

        // Initialize deployment panel(s)
        for (i = 0;i<DeploymentPanelClass.Length;++i)
        {
            c_DeploymentMapArea.AddTab(DeploymentPanelCaption[i],DeploymentPanelClass[i],,DeploymentPanelHint[i]);
        }
    }

    SetTimer(0.1,true);

    // Makes this menu not pause in single-player
    pc = PlayerOwner();
    if (pc != none && pc.Level.Pauser != none)
    {
        pc.SetPause(false);
    }
}

function Timer()
{
    local int i;

    if (!bReceivedTeam && ROPlayer(PlayerOwner()) != none && ROPlayer(PlayerOwner()).ForcedTeamSelectOnRoleSelectPage != -5)
    {
        ROPlayer(PlayerOwner()).ServerChangePlayerInfo(ROPlayer(PlayerOwner()).ForcedTeamSelectOnRoleSelectPage, 255, 0, 0);

        if (PlayerOwner().PlayerReplicationInfo.Team != none)
        {
            //We have a team!
            bReceivedTeam = true;

            // Initialize loadout panels
            for (i = 0;i<LoadoutPanelClass.Length;++i)
            {
                c_LoadoutArea.AddTab(LoadoutPanelCaption[i],LoadoutPanelClass[i],,LoadoutPanelHint[i]);
            }

            // Initialize deployment panel(s)
            for (i = 0;i<DeploymentPanelClass.Length;++i)
            {
                c_DeploymentMapArea.AddTab(DeploymentPanelCaption[i],DeploymentPanelClass[i],,DeploymentPanelHint[i]);
            }
        }
    }
}

function InitializeMenuOptions()
{
    local int i;

    for (i = 0; i < arraycount(b_MenuOptions); ++i)
    {
        if (MenuOptions[i] == "")
        {
            continue;
        }
        b_MenuOptions[i].Caption = MenuOptions[i];
        MenuOptionsContainer.ManageComponent(b_MenuOptions[i]);
    }

    MenuOptionsContainer.SetVisibility(false); // Initially hidden
}

function bool OnClick(GUIComponent Sender)
{
    switch (Sender)
    {
        case b_MenuButton:
            if (!bShowingMenuOptions)
            {
                bShowingMenuOptions = true;
                b_MenuButton.Caption = "Deployment";
                MenuOptionsContainer.SetVisibility(true);
                c_LoadoutArea.SetVisibility(false);
                c_DeploymentMapArea.SetVisibility(false);
            }
            else
            {
                bShowingMenuOptions = false;
                b_MenuButton.Caption = "Menu";
                MenuOptionsContainer.SetVisibility(false);
                c_LoadoutArea.SetVisibility(true);
                c_DeploymentMapArea.SetVisibility(true);
            }
            break;

        // Back to deploy
        case b_MenuOptions[0]:
            if (bShowingMenuOptions)
            {
                bShowingMenuOptions = false;
                b_MenuButton.Caption = "Menu";
                MenuOptionsContainer.SetVisibility(false);
                c_LoadoutArea.SetVisibility(true);
                c_DeploymentMapArea.SetVisibility(true);
            }
            break;

        // Switch Team
        case b_MenuOptions[1]:
            // Open team select menu
            Controller.ReplaceMenu("DH_Interface.DHGUITeamSelection");
            break;

        // Map Vote
        case b_MenuOptions[2]:
            Controller.OpenMenu(Controller.MapVotingMenu);
            break;

        // Kick Vote
        case b_MenuOptions[3]:
            Controller.OpenMenu(Controller.KickVotingMenu);
            break;

        // Communication
        case b_MenuOptions[4]:
            Controller.OpenMenu("ROInterface.ROCommunicationPage");
            break;

        // Server Browser
        case b_MenuOptions[5]:
            Controller.OpenMenu("DH_Interface.DHServerBrowser");
            break;

        // Options
        case b_MenuOptions[6]:
            Controller.OpenMenu("DH_Interface.DHSettingsPage_new");
            break;

        // Suicide
        case b_MenuOptions[7]:
            PlayerOwner().ConsoleCommand("SUICIDE");
            CloseMenu();
            break;

        // Disconnect
        case b_MenuOptions[8]:
            PlayerOwner().ConsoleCommand("DISCONNECT");
            CloseMenu();
            break;
    }
    return false;
}

function CloseMenu()
{
    if (Controller != none)
    {
        Controller.RemoveMenu(self);
    }
}

defaultproperties
{
    bRenderWorld=True
    bAllowedAsLast=True
    BackgroundColor=(B=0,G=125,R=0)
    InactiveFadeColor=(B=0,G=0,R=0)
    WinTop=0.0
    WinHeight=1.0

    // Background
    Begin Object Class=FloatingImage Name=FloatingBackground
        Image=texture'DH_GUI_Tex.Menu.MultiMenuBack'
        DropShadow=none
        ImageStyle=ISTY_Scaled
        WinTop=0.0
        WinLeft=0.0
        WinWidth=1.0
        WinHeight=1.0
        RenderWeight=0.000003
    End Object
    i_Background=FloatingImage'DH_Interface.DHDeployMenu.FloatingBackground'

    // Loadout / Role Area
    Begin Object class=GUITabControl Name=LoadoutArea
        bFillSpace=false
        bDockPanels=true
        TabHeight=0.03
        BackgroundStyleName="DHHeader"
        WinWidth=0.313189
        WinHeight=0.03861
        WinLeft=0.01
        WinTop=0.05
        RenderWeight=0.49
        TabOrder=3
        bAcceptsInput=true
    End Object
    c_LoadoutArea=GUITabControl'DH_Interface.DHDeployMenu.LoadoutArea'

    // Deployment Area
    Begin Object class=GUITabControl name=DeploymentArea
        bFillSpace=false
        bDockPanels=true
        TabHeight=0.03
        BackgroundStyleName="DHHeader"
        WinWidth=0.642175
        WinHeight=0.039361
        WinLeft=0.340298
        WinTop=0.05
        RenderWeight=0.49
        TabOrder=3
        bAcceptsInput=true
    End Object
    c_DeploymentMapArea=GUITabControl'DH_Interface.DHDeployMenu.DeploymentArea'

    // Menu Options Container
    Begin Object Class=ROGUIProportionalContainerNoSkinAlt Name=MenuContainer
        HeaderBase=Texture'DH_GUI_Tex.Menu.DHBox'
        WinWidth=0.5
        WinHeight=0.9
        WinLeft=0.01
        WinTop=0.05
        ImageOffset(0)=10
        ImageOffset(1)=10
        ImageOffset(2)=10
        ImageOffset(3)=10
    End Object
    MenuOptionsContainer=MenuContainer

    // Menu Button
    Begin Object Class=DHGUIButton Name=MenuButton
        Caption="Menu"
        CaptionAlign=TXTA_Left
        RenderWeight=5.85
        StyleName="DHSmallTextButtonStyle"
        WinWidth=0.2
        WinHeight=0.05
        WinLeft=0.0155
        WinTop=0.004
        OnClick=DHDeployMenu.OnClick
    End Object
    b_MenuButton=MenuButton

    // Menu Option Buttons
    Begin Object Class=DHGUIButton Name=MenuOptionsButton0
        CaptionAlign=TXTA_Center
        RenderWeight=5.85
        StyleName="DHSmallTextButtonStyle"
        WinWidth=1.0
        WinHeight=0.05
        WinLeft=0.0
        WinTop=0.01
        OnClick=DHDeployMenu.OnClick
    End Object
    b_MenuOptions(0)=MenuOptionsButton0
    Begin Object Class=DHGUIButton Name=MenuOptionsButton1
        CaptionAlign=TXTA_Center
        RenderWeight=5.85
        StyleName="DHSmallTextButtonStyle"
        WinWidth=1.0
        WinHeight=0.05
        WinLeft=0.0
        WinTop=0.11
        OnClick=DHDeployMenu.OnClick
    End Object
    b_MenuOptions(1)=MenuOptionsButton1
    Begin Object Class=DHGUIButton Name=MenuOptionsButton2
        CaptionAlign=TXTA_Center
        RenderWeight=5.85
        StyleName="DHSmallTextButtonStyle"
        WinWidth=1.0
        WinHeight=0.05
        WinLeft=0.0
        WinTop=0.22
        OnClick=DHDeployMenu.OnClick
    End Object
    b_MenuOptions(2)=MenuOptionsButton2
    Begin Object Class=DHGUIButton Name=MenuOptionsButton3
        CaptionAlign=TXTA_Center
        RenderWeight=5.85
        StyleName="DHSmallTextButtonStyle"
        WinWidth=1.0
        WinHeight=0.05
        WinLeft=0.0
        WinTop=0.33
        OnClick=DHDeployMenu.OnClick
    End Object
    b_MenuOptions(3)=MenuOptionsButton3
    Begin Object Class=DHGUIButton Name=MenuOptionsButton4
        CaptionAlign=TXTA_Center
        RenderWeight=5.85
        StyleName="DHSmallTextButtonStyle"
        WinWidth=1.0
        WinHeight=0.05
        WinLeft=0.0
        WinTop=0.44
        OnClick=DHDeployMenu.OnClick
    End Object
    b_MenuOptions(4)=MenuOptionsButton4
    Begin Object Class=DHGUIButton Name=MenuOptionsButton5
        CaptionAlign=TXTA_Center
        RenderWeight=5.85
        StyleName="DHSmallTextButtonStyle"
        WinWidth=1.0
        WinHeight=0.05
        WinLeft=0.0
        WinTop=0.55
        OnClick=DHDeployMenu.OnClick
    End Object
    b_MenuOptions(5)=MenuOptionsButton5
    Begin Object Class=DHGUIButton Name=MenuOptionsButton6
        CaptionAlign=TXTA_Center
        RenderWeight=5.85
        StyleName="DHSmallTextButtonStyle"
        WinWidth=1.0
        WinHeight=0.05
        WinLeft=0.0
        WinTop=0.66
        OnClick=DHDeployMenu.OnClick
    End Object
    b_MenuOptions(6)=MenuOptionsButton6
    Begin Object Class=DHGUIButton Name=MenuOptionsButton7
        CaptionAlign=TXTA_Center
        RenderWeight=5.85
        StyleName="DHSmallTextButtonStyle"
        WinWidth=1.0
        WinHeight=0.05
        WinLeft=0.0
        WinTop=0.77
        OnClick=DHDeployMenu.OnClick
    End Object
    b_MenuOptions(7)=MenuOptionsButton7
    Begin Object Class=DHGUIButton Name=MenuOptionsButton8
        CaptionAlign=TXTA_Center
        RenderWeight=5.85
        StyleName="DHSmallTextButtonStyle"
        WinWidth=1.0
        WinHeight=0.05
        WinLeft=0.0
        WinTop=0.88
        OnClick=DHDeployMenu.OnClick
    End Object
    b_MenuOptions(8)=MenuOptionsButton8

    MenuOptions(0)="Back"
    MenuOptions(1)="Change Team"
    MenuOptions(2)="Map Vote"
    MenuOptions(3)="Kick Vote"
    MenuOptions(4)="Communication"
    MenuOptions(5)="Server Browser"
    MenuOptions(6)="Options"
    MenuOptions(7)="Suicide"
    MenuOptions(8)="Disconnect"

    // Panel Variables
    LoadoutPanelCaption(0)="Role"
    LoadoutPanelCaption(1)="Vehicle"
    LoadoutPanelCaption(2)="Squad"

    LoadoutPanelHint(0)="Choose a role/class to deploy"
    LoadoutPanelHint(1)="Choose a vehicle to deploy"
    LoadoutPanelHint(2)="Create or join a squad"

    LoadoutPanelClass(0)="DH_Interface.DHRoleSelectPanel"
    LoadoutPanelClass(1)="DH_Interface.DHVehicleSelectPanel"
    LoadoutPanelClass(2)=""

    DeploymentPanelClass(0)="DH_Interface.DHDeploymentMapMenu"
    DeploymentPanelCaption(0)="Deployment"
    DeploymentPanelHint(0)="Deploy to the battlefield"
}
