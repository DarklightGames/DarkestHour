//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================
// TODO
// [ ] Exhaust position
// [ ] Fix waterline
// [ ] Add floating animation
// [ ] Fix karma collision box
// [ ] Fix turret collision attachments
// [ ] Add more passengers
// [ ] Add sound for ramp up/down
// [ ] Slow down ramp up/down animations
// [ ] New UI art
// [ ] Destroyed mesh
// [ ] Fix dirt/water effects
//==============================================================================

class DH_HigginsBoat extends DHBoatVehicle;

var     Texture     BinocsOverlay;

replication
{
    reliable if(Role < ROLE_Authority)
        ServerToggleRamp;
}

// Modified to handle binoculars overlay (same as in a vehicle weapon pawn)
simulated function DrawHUD(Canvas C)
{
    local PlayerController PC;
    local float            SavedOpacity, ScreenRatio;

    PC = PlayerController(Controller);

    if (PC != none && !PC.bBehindView)
    {
        // Draw binoculars overlay
        if (DriverPositions[DriverPositionIndex].bDrawOverlays && !IsInState('ViewTransition'))
        {
            SavedOpacity = C.ColorModulate.W;
            C.ColorModulate.W = 1.0;
            C.DrawColor.A = 255;
            C.Style = ERenderStyle.STY_Alpha;
            ScreenRatio = float(C.SizeY) / float(C.SizeX);
            C.SetPos(0.0, 0.0);

            C.DrawTile(BinocsOverlay, C.SizeX, C.SizeY,                         // screen drawing area (to fill screen)
                0.0, (1.0 - ScreenRatio) * float(BinocsOverlay.VSize) / 2.0,    // position in texture to begin drawing tile (from left edge, with vertical position to suit screen aspect ratio)
                BinocsOverlay.USize, float(BinocsOverlay.VSize) * ScreenRatio); // width & height of tile within texture

            C.ColorModulate.W = SavedOpacity; // reset HudOpacity to original value
        }

        // Draw vehicle & passenger list
        if (ROHud(PC.myHUD) != none)
        {
            ROHud(PC.myHUD).DrawVehicleIcon(C, self);
        }
    }
}

// Modified to add a hint for how to raise & lower the ramp.
simulated function ClientKDriverEnter(PlayerController PC)
{
    local DHPlayer DHPC;
    
    super.ClientKDriverEnter(PC);

    DHPC = DHPlayer(PC);

    if (DHPC != none)
    {
        // Send hint so the player is told how to raise and lower the ramp.
        DHPC.QueueHint(42, false);
    }
}

// Modified to avoid adding vehicle momentum from the Super, as can kill or injure driver & he's only stepping away from the controls, not actually jumping out
// TODO: perhaps add a bExitVelocity bool in DHVehicle, so we can simply set that to false in our defprops & won't need to re-state this long function
function bool KDriverLeave(bool bForceLeave)
{
    local Controller SavedController;
    local bool       bSwitchingVehiclePosition;

    // Prevent exit from vehicle if player is buttoned up (or if game type or mutator prevents exit)
    if (!bForceLeave && (!CanExit() || (Level.Game != none && !Level.Game.CanLeaveVehicle(self, Driver))))
    {
        return false;
    }

    bSwitchingVehiclePosition = bForceLeave && DHPawn(Driver) != none && DHPawn(Driver).SwitchingController != none;

    // Find an exit location for the player & try to move him there, unless we're only switching vehicle position
    if (!bSwitchingVehiclePosition && Driver != none && (!bRemoteControlled || bHideRemoteDriver))
    {
        Driver.bHardAttach = false;
        Driver.bCollideWorld = true;
        Driver.SetCollision(true, true);

        // If we couldn't move player to an exit location & we're not forcing exit, leave him inside (restoring his attachment & collision properties)
        if (!PlaceExitingDriver() && !bForceLeave)
        {
            Driver.bHardAttach = true;
            Driver.bCollideWorld = false;
            Driver.SetCollision(false, false);
            DisplayVehicleMessage(13); // no exit can be found

            return false;
        }
    }

    // Exit is successful, so stop controlling this vehicle pawn
    if (Controller != none)
    {
        if (Controller.RouteGoal == self)
        {
            Controller.RouteGoal = none;
        }

        if (Controller.MoveTarget == self)
        {
            Controller.MoveTarget = none;
        }

        SavedController = Controller;
        Controller.UnPossess();

        // If player is actually exiting the vehicle, not just switching positions, take control of the exiting player pawn
        if (!bSwitchingVehiclePosition && Driver != none && Driver.Health > 0)
        {
            SavedController.bVehicleTransition = true;
            SavedController.Possess(Driver);
            SavedController.bVehicleTransition = false;

            if (SavedController.IsA('PlayerController'))
            {
                PlayerController(SavedController).ClientSetViewTarget(Driver);
            }
        }

        if (Controller == SavedController)
        {
            Controller = none;
        }
    }

    if (Driver != none)
    {
        Instigator = Driver;

        // Update exiting player pawn if he has actually left the vehicle
        if (!bSwitchingVehiclePosition)
        {
            Driver.bSetPCRotOnPossess = Driver.default.bSetPCRotOnPossess;
            Driver.StopDriving(self);
/*
            // Give a player exiting the vehicle the same momentum as vehicle, with a little added height kick // REMOVED
            ExitVelocity = Velocity;
            ExitVelocity.Z += 60.0;
            Driver.Velocity = ExitVelocity; */
        }
        // Or if human player has only switched vehicle position, we just set PlayerStartTime, telling bots not to enter this vehicle position for a little while
        else if (PlayerController(SavedController) != none)
        {
            PlayerStartTime = Level.TimeSeconds + 12.0;
        }
    }

    DriverLeft();

    return true;
}

// Matt: hack fix because of the way the Higgins boat has been modelled, which completely screws up the normal use of a collision static mesh in the animation mesh
// Boat is modelled with the wrong rotation & Z location, so in the animation mesh it is given 90 degrees yaw, a little pitch & a Z axis translation
// But the engine doesn't apply the rotation & translation to the col mesh, & also a col mesh doesn't move with the boat animation as it pitches & rolls
// As a workaround, I've taken the col mesh out of the anim mesh, & instead added it as a col mesh actor, attached to the relevant bone
// With a separate col mesh actor for the bow ramp, attached to ramp hinge bone so it lowers & raises with ramp, providing protection to players inside when raised
// TODO - adjust Higgins animation mesh to remove unwanted rotation & translation (incl re-make/adjust its animations) - then delete this override & add back normal col static mesh
simulated function SpawnVehicleAttachments()
{
    super.SpawnVehicleAttachments();

    // Remove enough collision from the boat so it doesn't sink into the ground & it bumps into objects, but its crude collision boxes are ignored by projectiles
    // NB - can't just set in default props, as col meshes need to copy boat's intended collision settings when they spawn, so have to change these afterwards
    SetCollision(true, false); // bCollideActors true, but bBlockActors false
    bProjTarget = false;
}

// Emptied as Higgins boat can't stop/re-start its engine
function Fire(optional float F);
function ServerStartEngine();

// Emptied out so we don't damage things we run into
event RanInto(Actor Other);

exec function ROManualReload()
{
    ServerToggleRamp();
}

function ServerToggleRamp()
{
    VehicleComponentControllerActors[0].Toggle();
}

defaultproperties
{
    // Vehicle properties
    VehicleNameString="Higgins Boat"
    VehicleTeam=1
    bIsApc=true
    bKeyVehicle=true // means we skip usual check for nearby friendly players before resetting empty vehicle & making it respawn
    VehicleMass=6.0
    //CollisionAttachments(0)=(StaticMesh=StaticMesh'DH_allies_vehicles_stc.higgins.HigginsBoat_ramp_coll',AttachBone="Master2z00",Offset=(X=0.0,Y=-252.0,Z=-36.0)) // col mesh for bow ramp
    //CollisionAttachments(1)=(StaticMesh=StaticMesh'DH_allies_vehicles_stc.higgins.HigginsBoat_coll',AttachBone="Master1z00",Offset=(X=0.0,Y=0.0,Z=0.01)) // col mesh for rest of the boat
    bEngineOff=false
    bSavedEngineOff=false
    MaxDesireability=1.9

    MapIconMaterial=Texture'DH_InterfaceArt2_tex.craft_topdown'

    // Spawning
    bHasSpawnKillPenalty=false

    // Hull mesh
    Mesh=SkeletalMesh'DH_HigginsBoat_anm.LCVP_body_ext'
    //Skins(0)=Texture'DH_VehiclesUS_tex.ext_vehicles.HigginsBoat'
    BeginningIdleAnim="" // easy way to stop unwanted BeginningIdleAnim being played in several functions without having to override them

    // Vehicle weapons & passengers
    PassengerWeapons(0)=(WeaponPawnClass=class'DH_Vehicles.DH_HigginsBoatMGPawn',WeaponBone="TURRET_ATTACHMENT_L")
    PassengerWeapons(1)=(WeaponPawnClass=class'DH_Vehicles.DH_HigginsBoatMGPawn',WeaponBone="TURRET_ATTACHMENT_R")
    PassengerPawns(0)=(AttachBone="passenger_L1",DrivePos=(X=0.0,Y=0.0,Z=20.0),DriveAnim="higgins_rider1_idle")
    PassengerPawns(1)=(AttachBone="passenger_L2",DrivePos=(X=0.0,Y=0.0,Z=20.0),DriveAnim="higgins_rider2_idle")
    PassengerPawns(2)=(AttachBone="passenger_L3",DrivePos=(X=0.0,Y=0.0,Z=20.0),DriveAnim="higgins_rider3_idle")
    PassengerPawns(3)=(AttachBone="passenger_R1",DrivePos=(X=0.0,Y=0.0,Z=20.0),DriveAnim="higgins_rider4_idle")
    PassengerPawns(4)=(AttachBone="passenger_R2",DrivePos=(X=0.0,Y=0.0,Z=20.0),DriveAnim="higgins_rider5_idle")
    PassengerPawns(5)=(AttachBone="passenger_R3",DrivePos=(X=0.0,Y=0.0,Z=20.0),DriveAnim="higgins_rider6_idle")

    // Driver
    DriverPositions(0)=(PositionMesh=SkeletalMesh'DH_HigginsBoat_anm.LCVP_body_ext',ViewPitchUpLimit=10000,ViewPitchDownLimit=60000,ViewPositiveYawLimit=32768,ViewNegativeYawLimit=-32768,bExposed=true)
    BinocsOverlay=Texture'DH_VehicleOptics_tex.General.BINOC_overlay_6x30Allied'
    DriverAttachmentBone="driver_player"
    DrivePos=(X=0.0,Y=0.0,Z=10.0)
    FPCamPos=(X=0.0,Y=0.0,Z=6.0) //lift the view a bit higher than "camera_driver" which is low
    PlayerCameraBone="camera_driver"
    DriveAnim="stand_idlehip_satchel"

    // Movement
    GearRatios(2)=0.3
    GearRatios(3)=0.45
    GearRatios(4)=0.8
    TransRatio=0.1
    ChangeUpPoint=1990.0
    TorqueCurve=(Points=((InVal=0.0,OutVal=1.0),(InVal=200.0,OutVal=0.75),(InVal=1500.0,OutVal=10.0),(InVal=2200.0,OutVal=0.0)))
    ChassisTorqueScale=0.095
    WaterSpeed=80.0
    GroundSpeed=80.0
    SteerSpeed=20.0
    TurnDamping=50.0
    MaxSteerAngleCurve=(Points=((InVal=0.0,OutVal=45.0),(InVal=300.0,OutVal=30.0),(InVal=500.0,OutVal=20.0),(InVal=600.0,OutVal=15.0),(InVal=1000000000.0,OutVal=10.0)))

    // Physics wheels properties
    WheelLongFrictionFunc=(Points=((InVal=0.0,OutVal=0.0),(InVal=100.0,OutVal=1.0),(InVal=200.0,OutVal=0.9),(InVal=10000000000.0,OutVal=0.9)))
    WheelLatSlipFunc=(Points=((InVal=0.0,OutVal=0.0),(InVal=30.0,OutVal=0.009),(InVal=45.0,OutVal=0.0),(InVal=10000000000.0,OutVal=0.0)))
    WheelLatFrictionScale=1.55
    WheelSuspensionTravel=10.0
    WheelSuspensionMaxRenderTravel=5.0

    // Damage
    HealthMax=800.0
    Health=800
    VehHitpoints(0)=(PointRadius=50.0,PointBone="Master1z00",PointOffset=(X=-160.0,Y=0.0,Z=60.0)) // engine
    bCanCrash=false
    DamagedEffectOffset=(X=-170.0,Y=20.0,Z=50.0)
    DestroyedVehicleMesh=StaticMesh'DH_allies_vehicles_stc.higgins.HigginsBoat_destroyed'

    // Exit
    ExitPositions(0)=(X=-30.0,Y=-38.0,Z=100.0) // 'driver'
    ExitPositions(1)=(X=-30.0,Y=38.0,Z=100.0)  // 30 cal gunner
    ExitPositions(2)=(X=185.0,Y=-38.0,Z=100.0) // passengers
    ExitPositions(3)=(X=115.0,Y=-38.0,Z=100.0)
    ExitPositions(4)=(X=45.0,Y=-38.0,Z=100.0)
    ExitPositions(5)=(X=185.0,Y=38.0,Z=100.0)
    ExitPositions(6)=(X=115.0,Y=38.0,Z=100.0)
    ExitPositions(7)=(X=45.0,Y=38.0,Z=100.0)

    // Sounds
    IdleSound=Sound'DH_AlliedVehicleSounds.HigginsIdle01'
    StartUpSound=Sound'DH_AlliedVehicleSounds.higgins.HigginsStart01'
    ShutDownSound=Sound'DH_AlliedVehicleSounds.higgins.HigginsStop01'
    EngineSound=SoundGroup'DH_AlliedVehicleSounds.higgins.HigginsEngine_loop'
    EngineSoundBone="Engine"
    WashSound=Sound'DH_AlliedVehicleSounds.higgins.wash01'
    VehicleAttachments(0)=(AttachBone="Box01") // attachment bone for wash sound attachment

    // Visual effects
    ExhaustPipes(0)=(ExhaustPosition=(X=-280.0,Y=-31.0,Z=99.0),ExhaustRotation=(Pitch=31000))
    ExhaustEffectClass=class'ROEffects.ExhaustDieselEffect'
    ExhaustEffectLowClass=class'ROEffects.ExhaustDieselEffect_simple'
    SteerBoneName="STEERING_WHEEL"
    SteeringScaleFactor=2.0

    // HUD
    VehicleHudImage=Texture'DH_InterfaceArt_tex.Tank_Hud.higgins_body'
    VehicleHudEngineY=0.0
    VehicleHudOccupantsX(0)=0.43
    VehicleHudOccupantsX(1)=0.57
    VehicleHudOccupantsX(2)=0.43
    VehicleHudOccupantsX(3)=0.43
    VehicleHudOccupantsX(4)=0.43
    VehicleHudOccupantsX(5)=0.57
    VehicleHudOccupantsX(6)=0.57
    VehicleHudOccupantsX(7)=0.57
    VehicleHudOccupantsY(0)=0.67
    VehicleHudOccupantsY(1)=0.67
    VehicleHudOccupantsY(3)=0.4
    VehicleHudOccupantsY(4)=0.5
    VehicleHudOccupantsY(5)=0.3
    VehicleHudOccupantsY(6)=0.4
    VehicleHudOccupantsY(7)=0.5
    SpawnOverlay(0)=Material'DH_InterfaceArt_tex.Vehicles.higgins'
    
    VehicleComponentControllers(0)=(Channel=2,BoneName="RAMP",RaisingAnim="LCVP_RAMP_CLOSE",LoweringAnim="LCVP_RAMP_OPEN")

    //RampCloseSound=Sound'DH_AlliedVehicleSounds.higgins.HigginsRampClose01';
    //RampOpenSound=Sound'DH_AlliedVehicleSounds.higgins.HigginsRampOpen01';

    // Physics wheels
    Begin Object Class=SVehicleWheel Name=LFWheel
        bPoweredWheel=true
        SteerType=VST_Steered
        BoneName="WHEEL_F_L"
        BoneRollAxis=AXIS_Y
        BoneOffset=(Z=-6.0)
        WheelRadius=30.0
        bLeftTrack=true
    End Object
    Wheels(0)=LFWheel
    Begin Object Class=SVehicleWheel Name=RFWheel
        bPoweredWheel=true
        SteerType=VST_Steered
        BoneName="WHEEL_F_R"
        BoneRollAxis=AXIS_Y
        BoneOffset=(Z=-6.0)
        WheelRadius=30.0
    End Object
    Wheels(1)=RFWheel
    Begin Object Class=SVehicleWheel Name=LRWheel
        bPoweredWheel=true
        SteerType=VST_Inverted
        BoneName="WHEEL_B_L"
        BoneRollAxis=AXIS_Y
        BoneOffset=(Z=-6.0)
        WheelRadius=30.0
        bLeftTrack=true
    End Object
    Wheels(2)=LRWheel
    Begin Object Class=SVehicleWheel Name=RRWheel
        bPoweredWheel=true
        SteerType=VST_Inverted
        BoneName="WHEEL_B_R"
        BoneRollAxis=AXIS_Y
        BoneOffset=(Z=-6.0)
        WheelRadius=30.0
    End Object
    Wheels(3)=RRWheel

    // Karma
    Begin Object Class=KarmaParamsRBFull Name=KParams0
        KInertiaTensor(0)=1.3
        KInertiaTensor(3)=4.0
        KInertiaTensor(5)=4.5
        KLinearDamping=0.05
        KAngularDamping=0.05
        KStartEnabled=true
        bKNonSphericalInertia=true
        bHighDetailOnly=false
        bClientOnly=false
        bKDoubleTickRate=true
        bKStayUpright=true
        bKAllowRotate=true
        bDestroyOnWorldPenetrate=true
        bDoSafetime=true
        KFriction=0.5
        KImpactThreshold=850.0
    End Object
    KParams=KParams0
}
