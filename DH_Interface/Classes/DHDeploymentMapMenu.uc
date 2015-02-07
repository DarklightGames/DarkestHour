//-----------------------------------------------------------
// DHDeploymentMapMenu
//-----------------------------------------------------------
//Theel: ToDo: This class still has a ton of work
//Method of spawning
//1) Spawn the pawn
//2) Teleport pawn to the correct/requested location
//3) Have player possess the pawn and take control

//This will require a black room, but the player will never see or experience it and it is strictly
//to reduce the required number of player starts and allow pawns to start "inside" eachother
//Allowing for smaller cover to protect spawns!!!

class DHDeploymentMapMenu extends MidGamePanel;

var()   float                       DeploymentMapCenterX, DeploymentMapCenterY, DeploymentMapRadius;

var     automated GUIFooter         f_Legend;

var     automated GUILabel          l_HelpText, l_HintText, l_TeamText;

var     automated GUIImage          i_Background, i_HintImage, i_Team; //

var     automated GUIGFXButton      b_SpawnPoints[16]; //change to 32?
var     material                    SpawnPoint[5];

var()   localized string            MapPreferenceStrings[3];
var()   localized string            NodeTeleportHelpText,
                                    SetDefaultText,
                                    ChooseSpawnText,
                                    ClearDefaultText,
                                    SetDefaultHint,
                                    ClearDefaultHint,
                                    SpawnText,
                                    TeleportText,
                                    SpawnHint,
                                    TeleportHint,
                                    SelectedHint,
                                    UnderAttackHint,
                                    CoreHint,
                                    NodeHint,
                                    UnclaimedHint,
                                    LockedHint;

var()   localized string            Titles[6];
var()   localized string            NewSelectedHint, NewTeleportHint, EnemyCoreHint;
var     localized string            DefendMsg;

var     color                       TColor[2];

//var()   material                    NodeImage;



var()   color                       SelectionColor;

// Actor references - these must be cleared at level change
var     DHPlayerReplicationInfo     PRI; //DHPlayerReplicationInfo used to be ONSPlayerReplicationInfo
var     DHSpawnPoint                SelectedSpawnPoint;



function InitComponent(GUIController MyController, GUIComponent MyOwner)
{
    local int i;
    local DHGameReplicationInfo DHGRI;
    Super.InitComponent(MyController, MyOwner);

    DHGRI = DHGameReplicationInfo(PlayerOwner().GameReplicationInfo);

    //i_LevelMap.Image = DHGRI.MapImage;
    i_Background.Image = DHGRI.MapImage;

    //Hide/disable all the spawn point buttons
    for (i=0;i<arraycount(b_SpawnPoints);++i)
    {
        b_SpawnPoints[i].bVisible = false;
        //b_SpawnPoints.DisableComponent
    }
}

event Opened( GUIComponent Sender )
{
    Super.Opened(Sender);
}

//Not sure what this does yet.
function ShowPanel(bool bShow)
{
    local string colorname,t;

    Super.ShowPanel(bShow);

    if ( bShow )
    {
        if ( (PRI != None) && (PRI.Team != None) )
        {
            colorname = PRI.Team.ColorNames[PRI.Team.TeamIndex];
            t = Repl(DefendMsg, "%t", colorname, false);
            l_TeamText.Caption = t;

            i_Team.Image = PRI.Level.GRI.TeamSymbols[PRI.Team.TeamIndex];
            i_Team.ImageColor = TColor[PRI.Team.TeamIndex];
        }
    }
}

function bool InternalOnPreDraw( Canvas C )
{
    return false;
}

function bool PreDrawMap(Canvas C)
{
    local float L,T,W,H;

    DeploymentMapRadius = fmin( i_Background.ActualHeight(),i_Background.ActualWidth() ) / 2;
    DeploymentMapCenterX = i_Background.Bounds[0] + DeploymentMapRadius;
    DeploymentMapCenterY = i_Background.Bounds[1] + i_Background.ActualHeight() / 2;

    l_HelpText.bBoundToParent=false;
    l_HelpText.bScaleToParent=false;

    l_HintText.bScaleToParent=false;
    l_HintText.bBoundToParent=false;

    i_HintImage.bScaleToParent=false;
    i_HintImage.bBoundToParent=false;

    l_TeamText.bScaleToParent=false;
    l_TeamText.bBoundToParent=false;

    i_Team.bScaleToParent=false;
    i_Team.bBoundToParent=false;

    L = DeploymentMapCenterX + DeploymentMapRadius + (ActualWidth()*0.05);
    T = DeploymentMapCenterY - DeploymentMapRadius;

    W = ActualLeft() + ActualWidth() - L;
    H = ActualTop() + ActualHeight() - T;

    i_HintImage.WinLeft = L;
    i_HintImage.WinTop = T;

    l_HelpText.WinLeft = i_HintImage.ActualLeft() + i_HintImage.ActualWidth() + 8;
    l_HelpText.WinTop = t;
    l_HelpText.WinHeight = i_HintImage.ActualHeight();
    l_HelpTExt.WinWidth = W - i_HintImage.ActualWidth() - 8;

    t += i_HintImage.ActualHeight()+8;
    l_HintText.WinLeft = l;
    l_HintText.WinTop= t;
    l_HintText.WinWidth = w;
    l_HintText.WinHeight = H - i_HintImage.ActualHeight() - 8;

    L = DeploymentMapCenterX + DeploymentMapRadius;
    W = ActualLeft() + ActualWidth() - L;

    i_Team.WinLeft = L;
    i_Team.WinWidth = W;
    i_Team.WinHeight = W;
    i_Team.WinTop = i_Background.ActualTop() + i_Background.ActualHeight() - i_Team.ActualHeight();


    l_TeamText.WinLeft = L;
    l_TeamText.WinWidth = W;
    l_TeamText.WinTop = i_Team.ActualTop() - l_TeamText.ActualHeight();

    return false;
}

function bool DrawMapComponents(Canvas C)
{
    local DHGameReplicationInfo DHGRI;
    local vector vBoundaryScale, vMapScaleCenter;
    local float fMapScale;
    local DHSpawnPoint SP;

    //AppendComponent(ObjImage);
    DHGRI = DHGameReplicationInfo(PlayerOwner().GameReplicationInfo);

    //i_Background.SetVisibility(true);
    //This is where I need to do the math for the scale calc

    // This is how RO does it
    // Calculate level map constants
    vBoundaryScale = DHGRI.SouthWestBounds - DHGRI.NorthEastBounds;
    vMapScaleCenter =  vBoundaryScale / 2.0  + DHGRI.NorthEastBounds;
    fMapScale = Abs(vBoundaryScale.x);

    if (fMapScale ~= 0.0)
    {
        fMapScale = 1.0; // just so we never get divisions by 0
    }

    /*
    WinTop=0.070134
    WinLeft=0.029188

    WinWidth=0.634989
    WinHeight=0.747156
    */

    SelectedSpawnPoint = DHGRI.GetSpawnPointTest(PlayerOwner().PlayerReplicationInfo.Team.TeamIndex);

    b_SpawnPoints[0].bVisible = true;
    b_SpawnPoints[0].SetPosition(0.4,0.3,0.05,0.05);
    //function SetPosition( float NewLeft, float NewTop, float NewWidth, float NewHeight, optional bool bForceRelative )

    //Need a way to get active + team spawn point.

    //foreach above show 0++ bSpawnPoints and move to relative position for the map

        //DrawIconOnMap(C, SubCoords, MapIconVehicleResupply, MyMapScale, DHGRI.ResupplyAreas[i].ResupplyVolumeLocation, MapCenter);


    return false;
}

//After initial drawing is complete this is ran?
//Needs repurposed, this I guess actually shows the panel once it's rendered
function InternalOnPostDraw(Canvas Canvas)
{
    PRI = DHPlayerReplicationInfo(PlayerOwner().PlayerReplicationInfo);
    if (PRI != None)
    {
        bInit = False;
        OnRendered = None;
        ShowPanel(true);
    }
}


//This is how the player is selecting a core to spawn at I think!
function SetSelectedSpawn()
{
    /*
    local ONSPowerCore Core;

    Core = ONSHudOnslaught(PlayerOwner().myHUD).LocatePowerCore(Controller.MouseX - OnslaughtMapCenterX, Controller.MouseY - OnslaughtMapCenterY, OnslaughtMapRadius);
    if ( ValidSpawnPoint(Core) )
        SelectedCore = Core;
    else SelectedCore = None;
    */
}

//Hehe this is a good function that handles either spawning or teleporting
function bool SpawnClick(GUIComponent Sender)
{
    local PlayerController PC;

    if (bInit || PRI == None || PRI.bOnlySpectator)
        return true;

    PC = PlayerOwner();
    //SetSelectedSpawn();

    //SelectedSpawnPoint = DHGameReplicationInfo(PRI.Level.GRI).GetSpawnPointTest(PRI.Team.TeamIndex);

    if ( SelectedSpawnPoint == None )
    {
        Log("No spawn point found! Error!");
        return true;
    }

    //Spawn the pawn (for now just respawn the player?)
    TeleportPawn(PC.Pawn, SelectedSpawnPoint);

    //Controller.CloseMenu(false);





    //PC.Suicide(); //Slay the player if living
    //PC.ServerRestartPlayer(); //Restart the player?
    //PRI.TeleportTo(SelectedSpawnPoint); //Teleport the player if they have a pawn

    //Teleport the pawn

    //Have controller possess pawn

    //Do I need to call the server restart player or whatever functions?

    /*
    if ( bNodeTeleporting )
    {
        if ( SelectedCore != None )
        {
            Controller.CloseMenu(false);
            PRI.TeleportTo(SelectedCore);
        }
    }
    else
    {
        Controller.CloseMenu(false);
        PRI.SetStartCore( SelectedCore, true );
        PC.ServerRestartPlayer();
    }
    */
}

// Set timer for spawn protection
simulated function bool TeleportPawn(Pawn PlayerPawn, DHSpawnPoint SP)
{
    local rotator newRot, oldRot;
    local float mag;
    local vector oldDir;
    local Controller P;

    if (PlayerPawn == none || SP == none)
    {
        return false;
    }

    // Rotate the pawn to the same direction as the spawnpoint
    //PlayerPawn.Rotation.Yaw = SP.Rotation.Yaw;

    newRot = PlayerPawn.Rotation;
    newRot.Yaw = SP.Rotation.Yaw;
    newRot.Roll = 0;

    if (!PlayerPawn.SetLocation(SP.Location))
    {
        Log(self @ "Teleport failed for" @ PlayerPawn);
        return false;
    }

    PlayerPawn.SetRotation(newRot);
    PlayerPawn.SetViewRotation(newRot);
    PlayerPawn.ClientSetRotation(newRot);

    if (PlayerPawn.Controller != none)
    {
        PlayerPawn.Controller.MoveTimer = -1.0;
        //PlayerPawn.Anchor = SP;
        PlayerPawn.SetMoveTarget(SP);
    }

    DH_Pawn(PlayerPawn).TeleSpawnProtEnds = PRI.Level.TimeSeconds + SP.SpawnProtectionTime;


    return true;


    /*
    if (bChangesYaw)
    {
        if (Incoming.Physics == PHYS_Walking)
        {
            OldRot.Pitch = 0;
        }

        oldDir = vector(OldRot);
        mag = Incoming.Velocity dot oldDir;
        Incoming.Velocity = Incoming.Velocity - mag * oldDir + mag * vector(Incoming.Rotation);
    }
    if (bReversesX)
    {
        Incoming.Velocity.X *= -1.0;
    }

    if (bReversesY)
    {
        Incoming.Velocity.Y *= -1.0;
    }

    if (bReversesZ)
    {
        Incoming.Velocity.Z *= -1.0;
    }
    */
}


//Nothing likely needed to be done here!
function bool InternalOnClick(GUIComponent Sender)
{
    local GUIButton Selected;

    if (GUIButton(Sender) != None)
        Selected = GUIButton(Sender);

    if (Selected == None)
        return false;

    switch (Selected)
    {
        case b_SpawnPoints[0]:
            SpawnClick(Sender);
        break;

        default:
            //SpawnClick(Sender);
        break;
    }
    return false;
}


//Hmmm wtf is this
function Timer()
{
    local PlayerController PC;

    PC = PlayerOwner();
    PC.ServerRestartPlayer();
    PC.bFire = 0;
    PC.bAltFire = 0;
    Controller.CloseMenu(false);
}

//Menu was closed, do stuff
/* BOINK
function Closed(GUIComponent Sender, bool bCancelled)
{
    local ONSPlayerReplicationInfo.EMapPreference Pref;

    if (PRI != None)
    {
        Pref = EMapPreference(co_MenuOptions.GetIndex());
        if ( Pref != PRI.ShowMapOnDeath )
        {
            PRI.ShowMapOnDeath = Pref;
            PRI.SaveConfig();
        }
    }

    Super.Closed(Sender,bCancelled);
}

//This is sorta like a reset, releases the PRI and selected spawn point and also unlocks
function Free()
{
    Super.Free();

    PRI = None;
    SelectedCore = None;
}

//WTF? why not just call free?
function LevelChanged()
{
    Super.LevelChanged();

    PRI = None;
    SelectedCore = None;
}
*/

defaultproperties
{
    //Background=Texture'DH_GUI_Tex.Menu.DHBox'
    SpawnPoint(0)=Texture'DH_GUI_Tex.Menu.DHBox'

    //These might need repurposed to support 512x512 and 1024x1024!
    DeploymentMapCenterX=0.650000
    DeploymentMapCenterY=0.400000
    DeploymentMapRadius=0.300000

//Defined objects need repurposed to support class and package changes
     Begin Object Class=GUILabel Name=HelpText
         TextColor=(B=255,G=255,R=255)
         StyleName="TextLabel"
         WinTop=0.035141
         WinLeft=0.719388
         WinWidth=0.274188
     End Object
     l_HelpText=GUILabel'DH_Interface.DHDeploymentMapMenu.HelpText'

     Begin Object Class=GUILabel Name=HintLabel
         bMultiLine=True
         FontScale=FNS_Small
         StyleName="TextLabel"
         WinTop=0.117390
         WinLeft=0.669020
         WinWidth=0.323888
         WinHeight=0.742797
         RenderWeight=0.520000
     End Object
     l_HintText=GUILabel'DH_Interface.DHDeploymentMapMenu.HintLabel'

     Begin Object Class=GUILabel Name=TeamLabel
         Caption="Defend the Red Core"
         TextAlign=TXTA_Center
         bMultiLine=True
         FontScale=FNS_Small
         StyleName="TextLabel"
         WinTop=0.391063
         WinLeft=0.597081
         WinWidth=0.385550
         WinHeight=0.043963
         RenderWeight=0.520000
     End Object
     l_TeamText=GUILabel'DH_Interface.DHDeploymentMapMenu.TeamLabel'

     Begin Object Class=GUIImage Name=BackgroundImage
         Image=Texture'DH_GUI_Tex.Menu.DHBox'
         ImageStyle=ISTY_Justified
         //WinTop=0.070134
         //WinLeft=0.029188
         //WinWidth=0.634989
         //WinHeight=0.747156
        WinWidth=0.744226
        WinHeight=0.970106
        WinLeft=0.007699
        WinTop=0.005882

         bAcceptsInput=True
         OnPreDraw=DHDeploymentMapMenu.PreDrawMap
         OnDraw=DHDeploymentMapMenu.DrawMapComponents
         //OnClick=DHDeploymentMapMenu.SpawnClick
         //OnRightClick=DHDeploymentMapMenu.SelectClick
     End Object
     i_Background=GUIImage'DH_Interface.DHDeploymentMapMenu.BackgroundImage'


    Begin Object Class=GUIGFXButton Name=SpawnPointButton
        Graphic=texture'InterfaceArt_tex.HUD.satchel_ammo'
        Position=ICP_Justified
        bClientBound=true
        StyleName="DHGripButtonNB"
        WinWidth=0.1
        WinHeight=0.1
        TabOrder=1 //wtf is this? was 21
        bTabStop=true
        OnClick=DHDeploymentMapMenu.InternalOnClick
        OnKeyEvent=EquipButton0.InternalOnKeyEvent
    End Object
    b_SpawnPoints(0)=GUIGFXButton'DH_Interface.DHDeploymentMapMenu.SpawnPointButton'
    b_SpawnPoints(1)=GUIGFXButton'DH_Interface.DHDeploymentMapMenu.SpawnPointButton'
    b_SpawnPoints(2)=GUIGFXButton'DH_Interface.DHDeploymentMapMenu.SpawnPointButton'
    b_SpawnPoints(3)=GUIGFXButton'DH_Interface.DHDeploymentMapMenu.SpawnPointButton'
    b_SpawnPoints(4)=GUIGFXButton'DH_Interface.DHDeploymentMapMenu.SpawnPointButton'
    b_SpawnPoints(5)=GUIGFXButton'DH_Interface.DHDeploymentMapMenu.SpawnPointButton'
    b_SpawnPoints(6)=GUIGFXButton'DH_Interface.DHDeploymentMapMenu.SpawnPointButton'
    b_SpawnPoints(7)=GUIGFXButton'DH_Interface.DHDeploymentMapMenu.SpawnPointButton'
    b_SpawnPoints(8)=GUIGFXButton'DH_Interface.DHDeploymentMapMenu.SpawnPointButton'
    b_SpawnPoints(9)=GUIGFXButton'DH_Interface.DHDeploymentMapMenu.SpawnPointButton'
    b_SpawnPoints(10)=GUIGFXButton'DH_Interface.DHDeploymentMapMenu.SpawnPointButton'
    b_SpawnPoints(11)=GUIGFXButton'DH_Interface.DHDeploymentMapMenu.SpawnPointButton'
    b_SpawnPoints(12)=GUIGFXButton'DH_Interface.DHDeploymentMapMenu.SpawnPointButton'
    b_SpawnPoints(13)=GUIGFXButton'DH_Interface.DHDeploymentMapMenu.SpawnPointButton'
    b_SpawnPoints(14)=GUIGFXButton'DH_Interface.DHDeploymentMapMenu.SpawnPointButton'
    b_SpawnPoints(15)=GUIGFXButton'DH_Interface.DHDeploymentMapMenu.SpawnPointButton'








     Begin Object Class=GUIImage Name=IconHintImage
         //Image=Texture'ONSInterface-TX.NewHUDicons'
         ImageStyle=ISTY_Scaled
         WinTop=0.033996
         WinLeft=0.671639
         WinWidth=0.043667
         WinHeight=0.049502
         RenderWeight=0.510000
     End Object
     i_HintImage=GUIImage'DH_Interface.DHDeploymentMapMenu.IconHintImage'

     Begin Object Class=GUIImage Name=iTeam
         ImageColor=(G=128,R=0,A=90)
         ImageStyle=ISTY_Scaled
         WinTop=0.400000
         WinLeft=0.619446
         WinWidth=0.338338
         WinHeight=0.405539
         TabOrder=10
     End Object
     i_Team=GUIImage'DH_Interface.DHDeploymentMapMenu.iTeam'


//Worry about these as I continue to work on variables

     MapPreferenceStrings(0)="Never"
     MapPreferenceStrings(1)="When Body is Still"
     MapPreferenceStrings(2)="Immediately"
     NodeTeleportHelpText="Choose Node Teleport Destination"
     SetDefaultText="Set Default"
     ChooseSpawnText="Choose Your Spawn Point"
     ClearDefaultText="Clear Default"
     SetDefaultHint="Set the currently selected node as your preferred spawn location"
     ClearDefaultHint="Allow the game to choose the most appropriate spawn location"
     SpawnText="Spawn Here"
     TeleportText="Teleport Here"
     SpawnHint="Spawn at the currently selected node"
     TeleportHint="Teleport to the currently selected node"
     SelectedHint="Preferred spawn location"
     UnderAttackHint="Node is currently under attack"
     CoreHint="Main power core"
     NodeHint="Node is currently vulnerable to enemy attack"
     UnclaimedHint="Node is currently neutral and may be taken by either team"
     LockedHint="Node is currently unlinked and may not be attacked by the enemy"
     Titles(0)="Core (Under Attack)"
     Titles(1)="Preferred Node"
     Titles(2)="Core"
     Titles(3)="Node (Unclaimed)"
     Titles(4)="Node (Locked)"
     Titles(5)="Node (Attackable)"
     NewSelectedHint="||Right-Click on this node to select it as the preferred spawn location."
     NewTeleportHint="||Left-Click on this node to teleport to it"
     EnemyCoreHint="Enemy Core||Connect the nodes until you can reach this core"
     DefendMsg="Defend the %t core"
     TColor(0)=(B=100,G=100,R=255,A=128)
     TColor(1)=(B=255,G=128,A=128)
     //NodeImage=Texture'ONSInterface-TX.NewHUDicons'
     SelectionColor=(B=255,G=255,R=255,A=255)
     OnPreDraw=DHDeploymentMapMenu.InternalOnPreDraw
     OnRendered=DHDeploymentMapMenu.InternalOnPostDraw
}
