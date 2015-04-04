//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================
class DHDeployMenu extends UT2K4GUIPage;

enum ETab
{
    TAB_Role,
    TAB_Vehicle
};

var automated ROGUIProportionalContainer    MenuOptionsContainer;

var automated FloatingImage                 i_background;

var automated DHGUIButton                   b_MenuOptions[10];

var localized string                        MenuOptions[10], CloseButtonString;

var automated DHDeployTabControl            c_LoadoutArea;
var automated DHDeployTabControl            c_DeploymentMapArea;

var DHDeployMenuPanel                       RolePanel;
var DHDeployMenuPanel                       VehiclePanel;

var array<string>                           DeploymentPanelClass;
var localized array<string>                 DeploymentPanelCaption;
var localized array<string>                 DeploymentPanelHint;

var array<string>                           LoadoutPanelClass;
var localized array<string>                 LoadoutPanelCaption;
var localized array<string>                 LoadoutPanelHint;

var localized string                        NoSelectedRoleText,
                                            RoleHasBotsText,
                                            CurrentRoleText,
                                            RoleFullText,
                                            SelectEquipmentText,
                                            RoleIsFullMessageText,
                                            ChangingRoleMessageText,
                                            UnknownErrorMessageText,
                                            ErrorChangingTeamsMessageText,
                                            UnknownErrorSpectatorMissingReplicationInfo,
                                            SpectatorErrorTooManySpectators,
                                            SpectatorErrorRoundHasEnded,
                                            UnknownErrorTeamMissingReplicationInfo,
                                            ErrorTeamMustJoinBeforeStart,
                                            TeamSwitchErrorTooManyPlayers,
                                            UnknownErrorTeamMaxLives,
                                            TeamSwitchErrorRoundHasEnded,
                                            TeamSwitchErrorGameHasStarted,
                                            TeamSwitchErrorPlayingAgainstBots,
                                            TeamSwitchErrorTeamIsFull,
                                            SpawnPointInvalid,
                                            VehiclePoolInvalid,
                                            SpawnVehicleInvalid;

var bool                                    bReceivedTeam,
                                            bShowingMenuOptions,
                                            bRoleIsCrew,
                                            bRoomForOptions,
                                            bAttemptDeploy;

var float                                   PanelMargin;
var float                                   RequiredExtraWidth;

var DHGameReplicationInfo                   DHGRI;
var DHPlayer                                DHP;

var byte                                    SpawnPointIndex;
var byte                                    VehiclePoolIndex;
var byte                                    SpawnVehicleIndex;

var ETab                                    Tab;

function InitComponent(GUIController MyController, GUIComponent MyOwner)
{
    super.InitComponent(MyController, MyOwner);

    DHP = DHPlayer(PlayerOwner());

    if (DHP == none)
    {
        return;
    }

    DHGRI = DHGameReplicationInfo(DHP.GameReplicationInfo);

    if (DHGRI == none)
    {
        return;
    }

    // Initialize menu options
    InitializeMenuOptions();

    // Check if the player doesn't have a team
    if (DHP.PlayerReplicationInfo.Team != none)
    {
        // We have a team!
        HandlePanelInitialization();
    }
    else
    {
        // Have timer search for team if we didn't get one
        SetTimer(0.1, true);
    }

    // Makes this menu not pause in single-player
    if (DHP.Level.Pauser != none)
    {
        DHP.SetPause(false);
    }

    // Gather spawn point indices
    if (!DHP.bSwappedTeams)
    {
        SpawnPointIndex = DHP.SpawnPointIndex;
        SpawnVehicleIndex = DHP.SpawnVehicleIndex;
        VehiclePoolIndex = DHP.VehiclePoolIndex;
    }
    else
    {
        DHP.bSwappedTeams = false;
    }
}

function Timer()
{
    local ROPlayer C;

    C = ROPlayer(PlayerOwner());

    // Leave timer loop if we found a team
    if (bReceivedTeam)
    {
        SetTimer(0.0, false);
    }

    if (!bReceivedTeam && C != none && C.ForcedTeamSelectOnRoleSelectPage != -5)
    {
        C.ServerChangePlayerInfo(C.ForcedTeamSelectOnRoleSelectPage, 255, 0, 0);

        if (C.PlayerReplicationInfo.Team != none)
        {
            // Initialize loadout panels
            HandlePanelInitialization();
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

function HandlePanelInitialization()
{
    local int i;
    local bool bVehicleTabActive;

    if (DHP.VehiclePoolIndex != 255)
    {
        bVehicleTabActive = true;
    }

    // Initialize loadout panels
    for (i = 0; i < LoadoutPanelClass.Length; ++i)
    {
        // Check if we have a vehicle pool index set and are dealing with role panel
        if (bVehicleTabActive && i == 1)
        {
            c_LoadoutArea.AddTab(LoadoutPanelCaption[i], LoadoutPanelClass[i],, LoadoutPanelHint[i], bVehicleTabActive);
        }
        else // Initialize normally (where 0 is active)
        {
            c_LoadoutArea.AddTab(LoadoutPanelCaption[i], LoadoutPanelClass[i],, LoadoutPanelHint[i]);
        }
    }

    // Initialize deployment panel(s)
    for (i = 0; i < DeploymentPanelClass.Length; ++i)
    {
        c_DeploymentMapArea.AddTab(DeploymentPanelCaption[i],DeploymentPanelClass[i],,DeploymentPanelHint[i]);
    }

    // Set easy panel access
    RolePanel = DHDeployMenuPanel(c_LoadoutArea.TabStack[0].MyPanel);
    VehiclePanel = DHDeployMenuPanel(c_LoadoutArea.TabStack[1].MyPanel);

    // We have a team now
    bReceivedTeam = true;
}

function bool OnClick(GUIComponent Sender)
{
    switch (Sender)
    {
        // Back to deploy
        case b_MenuOptions[0]:
            if (bRoomForOptions && bShowingMenuOptions)
            {
                CloseMenu();
            }
            else if (bShowingMenuOptions)
            {
                // Hide menu options (show panels & menu button)
                bShowingMenuOptions = false;
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

function HandleExtraWidth(float ExtraWidth)
{
    local float L, T, W, H;

    if (ExtraWidth >= RequiredExtraWidth)
    {
        // Tell panels to not have menu option buttons
        bRoomForOptions = true;
        RolePanel.b_MenuButton.SetVisibility(false);
        VehiclePanel.b_MenuButton.SetVisibility(false);

        // Set the position values
        L = 1.0 - ExtraWidth + PanelMargin;
        T = 0.0;
        W = ExtraWidth - (PanelMargin * 2);
        H = 1.0;

        // Draw the menu options in the extra space
        MenuOptionsContainer.SetPosition(L, T, W, H);
        MenuOptionsContainer.SetVisibility(true);
        bShowingMenuOptions = true;

        // Change the back button to the close button
        b_MenuOptions[0].Caption = CloseButtonString;
    }
    else
    {
        // Tell panels there is no longer room for option buttons
        bRoomForOptions = false;
        RolePanel.b_MenuButton.SetVisibility(true);
        VehiclePanel.b_MenuButton.SetVisibility(true);

        // Set the position values (cant call defaults :C)
        L = 0.25;
        T = 0.05;
        W = 0.5;
        H = 0.9;

        // Set option container to default
        MenuOptionsContainer.SetPosition(L, T, W, H);
        MenuOptionsContainer.SetVisibility(false);
        bShowingMenuOptions = false;

        // Change the back button to the close button
        b_MenuOptions[0].Caption = MenuOptions[0];
    }
}

function HandleMenuButton()
{
    if (!bShowingMenuOptions && !bRoomForOptions)
    {
        // Show menu options (hide panels & menu button)
        bShowingMenuOptions = true;
        MenuOptionsContainer.SetVisibility(true);
        c_LoadoutArea.SetVisibility(false);
        c_DeploymentMapArea.SetVisibility(false);
    }
}

function ChangeSpawnIndices(byte NewSpawnPointIndex, byte NewVehiclePoolIndex, byte NewSpawnVehicleIndex)
{
    if (NewSpawnPointIndex < DHGRI.SPAWN_POINTS_MAX)
    {
        SpawnPointIndex = NewSpawnPointIndex;
    }
    else
    {
        SpawnPointIndex = 255;
    }

    if (NewVehiclePoolIndex < arraycount(DHGRI.VehiclePoolVehicleClasses))
    {
        VehiclePoolIndex = NewVehiclePoolIndex;
    }
    else
    {
        VehiclePoolIndex = 255;
    }

    if (NewSpawnVehicleIndex < arraycount(DHGRI.SpawnVehicles))
    {
        SpawnVehicleIndex = NewSpawnVehicleIndex;
    }
    else
    {
        SpawnVehicleIndex = 255;
    }
}

function InternalOnMessage(coerce string Msg, float MsgLife)
{
    local int Result;
    local string error_msg;

    if (Msg == "notify_gui_role_selection_page")
    {
        Result = int(MsgLife);

        switch (Result)
        {
            case 0: // All is well!
            case 97:
            case 98:
                if (DHP != none && bAttemptDeploy)
                {
                    DHP.PlayerReplicationInfo.bReadyToPlay = true;

                    // This should go in the area that gets called if everything is fine
                    if (DHP.ClientLevelInfo.SpawnMode == ESM_RedOrchestra)
                    {
                        DHP.ServerAttemptDeployPlayer(DHP.DesiredAmmoAmount, true);
                    }
                    else
                    {
                        DHP.ServerAttemptDeployPlayer(DHP.DesiredAmmoAmount);
                    }

                    CloseMenu(); // Close menu as deploying
                }

                return;

            default:
                error_msg = getErrorMessageForId(result);
                break;
        }

        if (Controller != none)
        {
            Controller.OpenMenu(Controller.QuestionMenuClass);
            GUIQuestionPage(Controller.TopPage()).SetupQuestion(error_msg, QBTN_Ok, QBTN_Ok);
        }
    }
}

static function string getErrorMessageForId(int id)
{
    local string error_msg;

    switch (id)
    {
        // TEAM CHANGE ERROR
        case 1: // Couldn't switch to spectator: no player replication info
            error_msg = default.UnknownErrorMessageText $ default.UnknownErrorSpectatorMissingReplicationInfo;
            break;

        case 2: // Couldn't switch to spectator: out of spectator slots
            error_msg = default.SpectatorErrorTooManySpectators;
            break;

        case 3: // Couldn't switch to spectator: game has ended
        case 4: // Couldn't switch to spectator: round has ended
            error_msg = default.SpectatorErrorRoundHasEnded;
            break;

        case 10: // Couldn't switch teams: no player replication info
            error_msg = default.UnknownErrorMessageText $ default.UnknownErrorTeamMissingReplicationInfo;
            break;

        case 11: // Couldn't switch teams: must join team before game start
            error_msg = default.ErrorTeamMustJoinBeforeStart;
            break;

        case 12: // Couldn't switch teams: too many active players
            error_msg = default.TeamSwitchErrorTooManyPlayers;
            break;

        case 13: // Couldn't switch teams: MaxLives > 0 (wtf is this)
            error_msg = default.UnknownErrorMessageText $ default.UnknownErrorTeamMaxLives;
            break;

        case 14: // Couldn't switch teams: game has ended
        case 15: // Couldn't switch teams: round has ended
            error_msg = default.TeamSwitchErrorRoundHasEnded;
            break;

        case 16: // Couldn't switch teams: server rules disallow team changes after game has started
            error_msg = default.TeamSwitchErrorGameHasStarted;
            break;

        case 17: // Couldn't switch teams: playing game against bots
            error_msg = default.TeamSwitchErrorPlayingAgainstBots;
            break;

        case 18: // Couldn't switch teams: team is full
            error_msg = default.TeamSwitchErrorTeamIsFull;
            break;

        case 19: // Spawn point invalid at index
            error_msg = default.SpawnPointInvalid;
            break;

        case 20: // Vehicle pool index not valid
            error_msg = default.VehiclePoolInvalid;
            break;

        case 21: // Spawn vehicle index not valid
            error_msg = default.SpawnVehicleInvalid;
            break;

        case 99: // Couldn't change teams: unknown reason
            error_msg = default.ErrorChangingTeamsMessageText;
            break;
        // ROLE CHANGE ERROR
        case 100: // Couldn't change roles (role is full)
            error_msg = default.RoleIsFullMessageText;
            break;

        case 199: // Couldn't change roles (unknown error)
            error_msg = default.UnknownErrorMessageText;
            break;

        default:
            error_msg = default.UnknownErrorMessageText $ " (id = " $ id $ ")";
    }

    return error_msg;
}

function OnClose(optional bool bCancelled)
{
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
    SpawnPointIndex=255
    VehiclePoolIndex=-255
    SpawnVehicleIndex=255

    OnMessage=InternalOnMessage
    bRenderWorld=true
    bAllowedAsLast=true
    BackgroundColor=(B=0,G=125,R=0)
    InactiveFadeColor=(B=0,G=0,R=0)
    WinTop=0.0
    WinHeight=1.0
    PanelMargin=0.005
    RequiredExtraWidth=0.15

    //Strings!
    CloseButtonString="Close"
    NoSelectedRoleText="Select a role from the role list."
    RoleHasBotsText=" (has bots)"
    CurrentRoleText="Current Role"
    RoleFullText="Full"
    SelectEquipmentText="Select an item to view its description."
    RoleIsFullMessageText="The role you selected is full. Select another role from the list and hit continue."
    ChangingRoleMessageText="Please wait while your player information is being updated."
    UnknownErrorMessageText="An unknown error occured when updating player information. Please wait a bit and retry."
    ErrorChangingTeamsMessageText="An error occured when changing teams. Please retry in a few moments or select another team."
    UnknownErrorSpectatorMissingReplicationInfo=" (Spectator switch error: player has no replication info.)"
    SpectatorErrorTooManySpectators="Cannot switch to Spectating mode: too many spectators on server."
    SpectatorErrorRoundHasEnded="Cannot switch to Spectating mode: round has ended."
    UnknownErrorTeamMissingReplicationInfo=" (Team switch error: player has no replication info.)"
    ErrorTeamMustJoinBeforeStart="Cannot switch teams: must join team before game starts."
    TeamSwitchErrorTooManyPlayers="Cannot switch teams: too many active players in game."
    UnknownErrorTeamMaxLives=" (Team switch error: MaxLives > 0)"
    TeamSwitchErrorRoundHasEnded="Cannot switch teams: round has ended."
    TeamSwitchErrorGameHasStarted="Cannot switch teams: server rules disallow team changes after game has started."
    TeamSwitchErrorPlayingAgainstBots="Cannot switch teams: server rules ask for bots on one team and players on the other."
    TeamSwitchErrorTeamIsFull="Cannot switch teams: the selected team is full."
    SpawnPointInvalid="Invalid spawn point."
    VehiclePoolInvalid="Invalid vehicle pool."
    SpawnVehicleInvalid="Invalid deploy vehicle."

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
    i_Background=FloatingBackground

    // Loadout / Role Area
    Begin Object class=DHDeployTabControl Name=LoadoutArea
        bFillSpace=false
        bDockPanels=true
        TabHeight=0.03
        BackgroundStyleName="DHHeader"
        WinWidth=0.315
        WinHeight=0.039 //Button height
        WinLeft=0.005 //PanelMargin
        WinTop=0.0
        RenderWeight=0.49
        TabOrder=1
        bAcceptsInput=true
    End Object
    c_LoadoutArea=LoadoutArea

    // Deployment Area
    Begin Object class=DHDeployTabControl name=DeploymentArea
        bFillSpace=false
        bDockPanels=true
        TabHeight=0.03
        BackgroundStyleName="DHHeader"
        WinWidth=0.642
        WinHeight=0.039 //Button height
        WinLeft=0.325
        WinTop=0.0
        RenderWeight=0.49
        TabOrder=2
        bAcceptsInput=true
    End Object
    c_DeploymentMapArea=DeploymentArea

    // Menu Options Container
    Begin Object Class=ROGUIProportionalContainerNoSkinAlt Name=MenuContainer
        HeaderBase=Texture'DH_GUI_Tex.Menu.DHBox'
        WinWidth=0.5
        WinHeight=0.9
        WinLeft=0.25
        WinTop=0.05
        ImageOffset(0)=10
        ImageOffset(1)=10
        ImageOffset(2)=10
        ImageOffset(3)=10
    End Object
    MenuOptionsContainer=MenuContainer

    // Menu Option Buttons
    Begin Object Class=DHGUIButton Name=MenuOptionsButton0
        CaptionAlign=TXTA_Center
        RenderWeight=5.85
        StyleName="DHSmallTextButtonStyle"
        WinWidth=1.0
        WinHeight=0.05
        WinLeft=0.0
        WinTop=0.01
        OnClick=OnClick
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
        OnClick=OnClick
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
        OnClick=OnClick
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
        OnClick=OnClick
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
        OnClick=OnClick
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
        OnClick=OnClick
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
        OnClick=OnClick
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
        OnClick=OnClick
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
        OnClick=OnClick
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
