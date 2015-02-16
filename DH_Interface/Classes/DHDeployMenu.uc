//-----------------------------------------------------------
//
//-----------------------------------------------------------
class DHDeployMenu extends UT2K4GUIPage;

var automated       FloatingImage                   i_background;
var automated       GUIButton                       b_SwitchTeam,
                                                    b_MapVoting,
                                                    b_KickVoting,
                                                    b_Communication,
                                                    b_Options,
                                                    b_Disconnect,
                                                    b_Confirm,
                                                    b_DebugSpawn;

var automated       GUILabel                        l_DeployTimeStatus;

var automated       GUIProgressBar                  pb_DeployProgressBar;
var automated       GUITabControl                   c_LoadoutArea;
var automated       GUITabControl                   c_DeploymentMapArea;

var array<string>               DeploymentPanelClass;
var localized array<string>     DeploymentPanelCaption;
var localized array<string>     DeploymentPanelHint;

var array<string>               LoadoutPanelClass;
var localized array<string>     LoadoutPanelCaption;
var localized array<string>     LoadoutPanelHint;

function InitComponent(GUIController MyController, GUIComponent MyOwner)
{
    local int i;
    local PlayerController pc;

    Super.InitComponent(MyController, MyOwner);

    //Initialize loadout panels
    for(i=0;i<LoadoutPanelClass.Length;++i)
    {
        c_LoadoutArea.AddTab(LoadoutPanelCaption[i],LoadoutPanelClass[i],,LoadoutPanelHint[i]);
    }

    //Initialize deployment panel(s)
    for(i=0;i<DeploymentPanelClass.Length;++i)
    {
        c_DeploymentMapArea.AddTab(DeploymentPanelCaption[i],DeploymentPanelClass[i],,DeploymentPanelHint[i]);
    }

    // Turn pause off if currently paused (Theel: nasty hack to make this menu not pause)
    pc = PlayerOwner();
    if (pc != None && pc.Level.Pauser != None)
       pc.SetPause(false);
}

function bool OnClick(GUIComponent Sender)
{
    switch(Sender)
    {
        case b_SwitchTeam:
            //Theel: should add a check here to make sure player isn't waiting for deploy time (this will stop insane team switching)
            if (DHPlayer(PlayerOwner()).bReadyToSpawn)
            {
                DHRoleSelectPanel(c_LoadoutArea.TabStack[0].MyPanel).ToggleTeam();

                //I don't think this works
                if (PlayerOwner().Pawn != none)
                {
                    CloseMenu();
                }
            }
            else
            {
                DHRoleSelectPanel(c_LoadoutArea.TabStack[0].MyPanel).InternalOnMessage("notify_gui_role_selection_page",19);

                //GUIQuestionPage(Controller.TopPage()).SetupQuestion(RoleIsFullMessageText, QBTN_Ok, QBTN_Ok);
                //Need to tell the player they must wait for deploy timer!
            }

            //Controller.OpenMenu("DH_Interface.DHGUITeamSelection");
        break;

        case b_MapVoting:
            Controller.OpenMenu(Controller.MapVotingMenu);
        break;

        case b_KickVoting:
            Controller.OpenMenu(Controller.KickVotingMenu);
        break;

        case b_Communication:
            Controller.OpenMenu("ROInterface.ROCommunicationPage");
        break;

        case b_Options:
            Controller.OpenMenu("DH_Interface.DHSettingsPage_new");
        break;

        case b_Disconnect:
            PlayerOwner().ConsoleCommand( "DISCONNECT" );
            CloseMenu();
        break;

        case B_DebugSpawn:
            DHPlayer(PlayerOwner()).bReadyToSpawn = true;
            if(DHPlayer(PlayerOwner()).Pawn == none)
            {
                DHPlayer(PlayerOwner()).ServerDeployPlayer();
            }
            CloseMenu();
        break;

        case b_Confirm:
            CloseMenu();
        break;
    }
}

function bool DrawDeployTimer(Canvas C)
{
    local DHPlayer DHP;
    local float P;

    DHP = DHPlayer(PlayerOwner());

    //Handle progress bar values (so they move/advance based on deploy time)
    if (DHP.CurrentRedeployTime != 0 && !DHP.bReadyToSpawn)
    {
        P = pb_DeployProgressBar.High * (DHP.LastKilledTime + DHP.CurrentRedeployTime - DHP.Level.TimeSeconds) / DHP.CurrentRedeployTime;
        P = pb_DeployProgressBar.High - P;
        pb_DeployProgressBar.Value = FClamp(P, pb_DeployProgressBar.Low, pb_DeployProgressBar.High);

        if (pb_DeployProgressBar.Value == pb_DeployProgressBar.High)
        {
            //Progress is done
            l_DeployTimeStatus.Caption = "Ready To Deploy";
        }
        else
        {
            //Progress isn't done
            l_DeployTimeStatus.Caption = "Deploy in:" @ int(DHP.LastKilledTime + DHP.CurrentRedeployTime - DHP.Level.TimeSeconds) @ "Seconds";
        }
    }
    else
    {
        pb_DeployProgressBar.Value = pb_DeployProgressBar.High;
        l_DeployTimeStatus.Caption = "Ready To Deploy";
        if (DHP.Pawn != none)
        {
            l_DeployTimeStatus.Caption = "Deployed"; //If we have a pawn and progress bar has finished, we are deployed
        }
    }
    return false;
}


function CloseMenu()
{
    if (Controller != none)
        Controller.RemoveMenu(self);
}

function InternalOnClose(optional bool bCancelled)
{
    local PlayerController pc;

    // Turn pause off if currently paused
    pc = PlayerOwner();
    if (pc != None && pc.Level.Pauser != None)
       pc.SetPause(false);

    Super.OnClose(bCancelled);
}

DefaultProperties
{
    //Menu variables
    bRenderWorld=True
    bAllowedAsLast=True
    BackgroundColor=(B=0,G=125,R=0)
    InactiveFadeColor=(B=0,G=0,R=0)
    OnClose=InternalOnClose
    WinTop=0.0
    WinHeight=1.0

    //Components
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

    //LOADOUT AREA
    Begin Object class=GUITabControl Name=LoadoutArea
        bFillSpace=false
        bDockPanels=true
        TabHeight=0.03
        BackgroundStyleName="DHHeader"
        WinWidth=0.313189
        WinHeight=0.038610
        WinLeft=0.018555
        WinTop=0.052083
        RenderWeight=0.49
        TabOrder=3
        bAcceptsInput=true
    End Object
    c_LoadoutArea=GUITabControl'DH_Interface.DHDeployMenu.LoadoutArea'

    //DEPLOYMENT MAP AREA
    Begin Object class=GUITabControl name=DeploymentArea
        bFillSpace=false
        bDockPanels=true
        TabHeight=0.03
        BackgroundStyleName="DHHeader"
        WinWidth=0.642175
        WinHeight=0.039361
        WinLeft=0.340298
        WinTop=0.050421
        RenderWeight=0.49
        TabOrder=3
        bAcceptsInput=true
    End Object
    c_DeploymentMapArea=GUITabControl'DH_Interface.DHDeployMenu.DeploymentArea'

    //CONFIRM BUTTON
    Begin Object class=GUIButton Name=ConfirmButton
        CaptionAlign=TXTA_Right
        Caption="ExitMenu"
        bAutoShrink=false
        bUseCaptionHeight=true
        FontScale=FNS_Large
        StyleName="DHMenuTextButtonStyle"
        TabOrder=0
        bFocusOnWatch=true
        OnClick=DHDeployMenu.OnClick
        WinWidth=0.099853
        WinHeight=0.036120
        WinLeft=0.887277
        WinTop=0.955100
    End Object
    b_Confirm=GUIButton'DH_Interface.DHDeployMenu.ConfirmButton'

    //DEBUG SPAWN BUTTON
    Begin Object class=GUIButton Name=SpawnButton
        CaptionAlign=TXTA_Right
        Caption="Debug Spawn"
        bAutoShrink=false
        bUseCaptionHeight=true
        FontScale=FNS_Large
        StyleName="DHMenuTextButtonStyle"
        TabOrder=0
        bFocusOnWatch=true
        OnClick=DHDeployMenu.OnClick
        WinWidth=0.150000
        WinHeight=0.045573
        WinLeft=0.744338
        WinTop=0.952863
    End Object
    b_DebugSpawn=SpawnButton

    //Top Buttons!
    Begin Object class=GUIButton Name=SwitchTeamButton
        CaptionAlign=TXTA_Center
        Caption="Switch Team"
        bAutoShrink=false
        bUseCaptionHeight=true
        FontScale=FNS_Large
        StyleName="DHMenuTextButtonStyle"
        TabOrder=0
        bFocusOnWatch=true
        OnClick=DHDeployMenu.OnClick
        WinWidth=0.142500
        WinHeight=0.045573
        WinLeft=0.004297
        WinTop=0.006250
    End Object
    b_SwitchTeam=SwitchTeamButton

    Begin Object Class=GUIButton Name=DisconnectButton
        WinWidth=0.12
        WinHeight=0.048
        WinLeft=0.889564
        WinTop=0.004
        StyleName="DHMenuTextButtonStyle"
        Caption="Disconnect"
        Hint="Disconnect from current game"
        TabOrder=1
        OnClick=DHDeployMenu.OnClick
        bAutoShrink=false
    End Object
    b_Disconnect=DisconnectButton

    Begin Object Class=GUIButton Name=OptionsButton
        WinWidth=0.12
        WinHeight=0.048
        WinLeft=0.784042
        WinTop=0.004
        StyleName="DHMenuTextButtonStyle"
        Caption="Options"
        TabOrder=1
        OnClick=DHDeployMenu.OnClick
        bAutoShrink=false
    End Object
    b_Options=OptionsButton

    Begin Object Class=GUIButton Name=MapVotingButton
        WinWidth=0.12
        WinHeight=0.048
        WinLeft=0.438865
        WinTop=0.004
        StyleName="DHMenuTextButtonStyle"
        Caption="VoteMap"
        TabOrder=1
        OnClick=DHDeployMenu.OnClick
        bAutoShrink=false
    End Object
    b_MapVoting=MapVotingButton

    Begin Object Class=GUIButton Name=KickVotingButton
        WinWidth=0.12
        WinHeight=0.048
        WinLeft=0.552607
        WinTop=0.004
        StyleName="DHMenuTextButtonStyle"
        Caption="VoteKick"
        TabOrder=1
        OnClick=DHDeployMenu.OnClick
        bAutoShrink=false
    End Object
    b_KickVoting=KickVotingButton

    Begin Object Class=GUIButton Name=CommsButton
        WinWidth=0.12
        WinHeight=0.048
        WinLeft=0.662401
        WinTop=0.004
        StyleName="DHMenuTextButtonStyle"
        Caption="Communication"
        TabOrder=1
        OnClick=DHDeployMenu.OnClick
        bAutoShrink=false
    End Object
    b_Communication=CommsButton

    //Deploy time status label
    Begin Object Class=GUILabel Name=DeployTimeStatus
        Caption=""
        RenderWeight=5.85
        TextAlign=TXTA_Center
        StyleName="DHLargeText"
        WinWidth=0.315937
		WinHeight=0.033589
		WinLeft=0.137395
		WinTop=0.010181
		bNeverFocus=true
		bAcceptsInput=false
    End Object
    l_DeployTimeStatus=DeployTimeStatus

    //Deploy time progress bar
    Begin Object class=GUIProgressBar Name=DeployTimePB
        BarColor=(B=255,G=255,R=255,A=255)
        Value=0.0
        RenderWeight=1.75
        bShowValue=false
        CaptionWidth=0.0
        ValueRightWidth=0.0
        BarBack=Texture'InterfaceArt_tex.Menu.GreyDark'
        BarTop=Texture'InterfaceArt_tex.Menu.GreyLight'
        OnDraw=DHDeployMenu.DrawDeployTimer
        WinWidth=0.315937
		WinHeight=0.033589
		WinLeft=0.137395
		WinTop=0.010181
		bNeverFocus=true
		bAcceptsInput=false
    End Object
    pb_DeployProgressBar=DeployTimePB

    //Panel Variables
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