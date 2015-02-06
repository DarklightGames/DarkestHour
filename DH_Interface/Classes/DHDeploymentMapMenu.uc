//-----------------------------------------------------------
// DHDeploymentMapMenu
//-----------------------------------------------------------

//Method of spawning
//1) Spawn the pawn
//2) Teleport pawn to the correct/requested location
//3) Have player possess the pawn and take control

//This will require a black room, but the player will never see or experience it and it is strictly
//to reduce the required number of player starts and allow pawns to start "inside" eachother
//Allowing for smaller cover to protect spawns!!!

/* Development notes:

- I'm currently working on making this compile and renaming variables to make sense
- Draw functions need refactored and repurposed to work with DH

- I'm struggling to understand how to draw stuff on the map based on coordinates or whatever
- New concept is to make a button that automatically selects an active spawn point that is the same team as user

*/


class DHDeploymentMapMenu extends MidGamePanel;

var()   float                       DeploymentMapCenterX, DeploymentMapCenterY, DeploymentMapRadius;

var     automated GUIFooter         f_Legend;

var     automated GUILabel          l_HelpText, l_HintText, l_TeamText;
var     automated moComboBox        co_MenuOptions;

var     automated GUIImage          i_Background, i_HintImage, i_Team;

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

var()   material                    NodeImage;

var()   color                       SelectionColor;

// Actor references - these must be cleared at level change
var     DHPlayerReplicationInfo     PRI; //DHPlayerReplicationInfo used to be ONSPlayerReplicationInfo
var     DHSpawnPoint                SelectedSpawnPoint;
//var     ONSPowerCore                SelectedCore;


function InitComponent(GUIController MyController, GUIComponent MyOwner)
{
    local int x;

    Super.InitComponent(MyController, MyOwner);

    for (x = 0; x < 3; x++)
    {
        co_MenuOptions.AddItem(MapPreferenceStrings[x]);
        //This seems to be adding in the below options to a drop-down button changing when the menu appears after death
        //However we should make it always appear after 1-5 seconds or something.

        //MapPreferenceStrings(0)="Never"
        //MapPreferenceStrings(1)="When Body is Still"
        //MapPreferenceStrings(2)="Immediately"
    }
}

event Opened( GUIComponent Sender )
{
    Super.Opened(Sender);
}


//called to inform tab that it should be in Node Teleport mode instead of Select Spawn Point mode
/* This is unneeded because we will be controling spawning/teleporting differently
function NodeTeleporting()
{
    bNodeTeleporting = true;
}
*/

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

//This seems to be getting location of core/objectives
//This needs refactored to work with objectives?
//I don't think any of this is needed for our purpose

function bool InternalOnPreDraw( Canvas C )
{
    return false;
}


//This needs refactored to work with objectives
//THESE MAY NOT BE NEEDED COMMENT OUT
/*
function DrawAttackHint()
{
    l_HintText.Caption = UnderAttackHint;
    SetHintImage(NodeImage,0,64,64,64);
    l_HelpText.Caption=Titles[0];
}

//This needs refactored to work with objectives
//THESE MAY NOT BE NEEDED COMMENT OUT
function DrawSpawnHint()
{
    l_HintText.Caption = SelectedHint;
    SetHintImage( NodeImage, 64, 64, 64, 64);
    l_HelpText.Caption=Titles[1];
}

//This needs refactored to work with objectives
//THESE MAY NOT BE NEEDED COMMENT OUT
function DrawCoreHint(bool HomeTeam)
{
    if (!HomeTeam)
    {
        l_HintText.Caption = EnemyCoreHint;
        SetHintImage( NodeImage, 65, 0, 62, 64 );
        return;
    }

    l_HintText.Caption = CoreHint;
    SetHintImage( NodeImage, 65, 0, 62, 64 );
    l_HelpText.Caption=Titles[2];

    if (bNodeTeleporting)
        L_HintText.Caption = l_HintText.Caption$NewTeleportHint;

    l_HintText.Caption = l_HintText.Caption$NewSelectedHint;
}
*/

//This needs refactored to work with objectives
//no all this is doing is determining how to visually draw a core icon, if it's attackable/under attack etc.
//UNNEEDED comment out
/*
function DrawNodeHint( ONSHudOnslaught HUD, ONSPowerCore Core )
{
    if ( HUD == None || Core == None )
        return;

    if (Core.CoreStage == 4)
    {
        if (HUD.PowerCoreAttackable(Core))
        {
            l_HintText.Caption = UnclaimedHint;
            SetHintImage( NodeImage,0,0,31,32);
            l_HelpText.Caption=Titles[3];
        }
        else
        {
            l_HintText.Caption = LockedHint;
            SetHintImage( NodeImage,0,32,31,32);
            l_HelpText.Caption=Titles[4];
        }
    }
    else if (HUD.PowerCoreAttackable(Core))
    {
        l_HintText.Caption = NodeHint;
        SetHintImage( NodeImage, 32,0,32,31);
        l_HelpText.Caption=Titles[5];
    }
    else
    {
        l_HintText.Caption = LockedHint;
        SetHintImage( NodeImage,0,32,31,32);
        l_HelpText.Caption=Titles[4];
    }

    if (PlayerOwner().PlayerReplicationInfo.Team != None && Core.DefenderTeamIndex == PlayerOwner().PlayerReplicationInfo.Team.TeamIndex)
    {
        if (bNodeTeleporting)
            L_HintText.Caption = l_HintText.Caption$NewTeleportHint;

        if (!HUD.PowerCoreAttackable(Core) )
            l_HintText.Caption = l_HintText.Caption$NewSelectedHint;
    }
}
*/

/*
function SetHintImage( Material NewImage, int X1, int Y1, int X2, int Y2 )
{
    i_HintImage.Image = NewImage;
    i_HintImage.X1 = X1;
    i_HintImage.X2 = X1 + X2;
    i_HintImage.Y1 = Y1;
    i_HintImage.Y2 = Y1 + Y2;
}
*/

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


//This isn't going to be so simple, we have to go into the HUD class now and make it work
//I should look to see if there is a simliar function to "DrawRadarMap" in ROHud and if not make one
//However we gotta see exactly what that is doing!

//Important function that is likely getting called often
function bool DrawMap(Canvas C)
{
    //local ONSPowerCore Core; //WTF should this be?
    local DHHud HUD; //Used to be ONSHudOnslaught
    local float HS; //HudScale
    local FloatBox MapBox; //var float X1, Y1, X2, Y2;


    /* Ignore this for now
    if ( PRI != None )
    {
        Core = PRI.StartCore;
    }
    */

    l_TeamText.Caption = "DrawMap Called";

    HUD = DHHud(PlayerOwner().myHud);
    HS = HUD.HudScale;
    HUD.HudScale=1.0;

    //This is now the only invalid line in the function, we need to know what this is doing
    //I guess this is actually drawing the radar
    //We can try something, but I'm sure it won't work
    //Gonna need to add something to DHHud that can handle our request here!
    //HUD.DrawObjectives(C); //THIS IS GONNA BUG THE FUCK OUT!
    //HUD.DrawDeployMap(C); //Time to code this function in the hud class!
    //HUD.DrawDeployMap(C, DeploymentMapCenterX, DeploymentMapCenterY, DeploymentMapRadius, false);
    MapBox.X1 = 23.0;
    MapBox.X2 = 28.0;
    MapBox.Y1 = 4.5;
    MapBox.Y2 = 28.0;
    //MapLevelImage=(WidgetTexture=none,TextureCoords=(X1=0,Y1=0,X2=511,Y2=511),

    /*
    //These might need repurposed to support 512x512 and 1024x1024!
    DeploymentMapCenterX=0.650000
    DeploymentMapCenterY=0.400000
    DeploymentMapRadius=0.300000
    */


    HUD.DrawMap(C,,MapBox,true,true);

    //Used to be: Hud.DrawRadarMap(C, OnslaughtMapCenterX, OnslaughtMapCenterY, OnslaughtMapRadius, false);

    HUD.HudScale=HS;

    /* Ignore for now
    if ( Core != None )
    {
        ONSHUD.DrawSpawnIcon(C, Core.HUDLocation, Core.bFinalCore, ONSHUD.IconScale, ONSHUD.HUDScale);
    }
    */

    return true;
}


//After initial drawing is complete this is ran?
//Needs repurposed, this I guess actually shows the panel once it's rendered


function InternalOnPostDraw(Canvas Canvas)
{
    PRI = DHPlayerReplicationInfo(PlayerOwner().PlayerReplicationInfo);
    if (PRI != None)
    {
        bInit = False;
        co_MenuOptions.SetIndex(1); //Just remove this shit or soemthing
        OnRendered = None;
        ShowPanel(true);
    }
}

/* LETS TRY COMMENTING THIS OUT FOR NOW
//part of SetSelectedCore() I think this is ran if the player select clicks
function bool SelectClick( GUIComponent Sender )
{
    local PlayerController PC;

    if (bInit || PRI == None || PRI.bOnlySpectator)
        return true;

    PC = PlayerOwner();
    SetSelectedCore();
    if ( SelectedCore == None )
        return True;

    if ( SelectedCore == PRI.StartCore )
        PRI.SetStartCore( None, false );
    else PRI.SetStartCore( SelectedCore, false );
}
*/

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

    SelectedSpawnPoint = DHGameReplicationInfo(PRI.Level.GRI).GetSpawnPointTest(PRI.Team.TeamIndex);

    if ( SelectedSpawnPoint == None )
    {
        Log("No spawn point found! Error!");
        return true;
    }

    //Spawn the pawn (for now just respawn the player?)
    TeleportPawn(PC.Pawn, SelectedSpawnPoint);

    Controller.CloseMenu(false);
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

/*
//Nothing likely needed to be done here!
function bool InternalOnClick(GUIComponent Sender)
{
    if (bInit || PRI == None)
        return true;

    PRI.RequestLinkDesigner();
    return true;
}
*/

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

//Need to find out when this is called and if it's important to use for DH
/*
function bool ValidSpawnPoint(ONSPowerCore Core)
{
    if ( Core == None )
        return false;

    if (Core.DefenderTeamIndex == PRI.Team.TeamIndex && Core.CoreStage == 0 && (!Core.bUnderAttack || Core.bFinalCore) && Core.PowerLinks.Length > 0)
        return true;

    return false;
}
*/

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

     Begin Object Class=moComboBox Name=MapComboBox
         bReadOnly=True
         CaptionWidth=0.300000
         Caption="Show Map:"
         OnCreateComponent=MapComboBox.InternalOnCreateComponent
         WinTop=0.866668
         WinLeft=0.032347
         WinWidth=0.628008
         WinHeight=0.038462
         TabOrder=2
     End Object
     co_MenuOptions=moComboBox'DH_Interface.DHDeploymentMapMenu.MapComboBox'

     Begin Object Class=GUIImage Name=BackgroundImage
         //Image=Texture'2K4Menus.Controls.outlinesquare'
         ImageStyle=ISTY_Stretched
         WinTop=0.070134
         WinLeft=0.029188
         WinWidth=0.634989
         WinHeight=0.747156
         bAcceptsInput=True
         OnPreDraw=DHDeploymentMapMenu.PreDrawMap
         OnDraw=DHDeploymentMapMenu.DrawMap
         OnClick=DHDeploymentMapMenu.SpawnClick
         //OnRightClick=DHDeploymentMapMenu.SelectClick
     End Object
     i_Background=GUIImage'DH_Interface.DHDeploymentMapMenu.BackgroundImage'

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
