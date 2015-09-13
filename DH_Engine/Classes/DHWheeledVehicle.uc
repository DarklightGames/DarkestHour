//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DHWheeledVehicle extends ROWheeledVehicle
    abstract;

#exec OBJ LOAD FILE=..\Textures\DH_InterfaceArt_tex.utx

enum ECarHitPointType
{
    CHP_Normal,
    CHP_RFTire,
    CHP_RRTire,
    CHP_LFTire,
    CHP_LRTire,
    CHP_Petrol,
};

var     ECarHitPointType    CarHitPointType;

struct CarHitpoint
{
    var float             PointRadius;           // squared radius of the head of the pawn that is vulnerable to headshots
    var float             PointHeight;           // distance from base of neck to center of head - used for headshot calculation
    var float             PointScale;            // scale factor for radius & height
    var name              PointBone;             // bone to reference in offset
    var vector            PointOffset;           // amount to offset the hitpoint from the bone
    var bool              bPenetrationPoint;     // this is a penetration point, open hatch, etc
    var float             DamageMultiplier;      // amount to scale damage to the vehicle if this point is hit
    var ECarHitPointType  CarHitPointType;       // what type of hit point this is
};

var     array<CarHitpoint>  CarVehHitpoints;     // an array of possible small points that can be hit (index zero is always the driver)

// General
var     bool        bIsSpawnVehicle;             // set by DHSpawnManager & used here for engine on/off hints
var     float       MinVehicleDamageModifier;    // minimum damage modifier (from DamageType) needed to damage this vehicle
var     float       PointValue;                  // used for scoring
var array<Material> DestroyedMeshSkins;          // option to skin destroyed vehicle static mesh to match camo variant (avoiding need for multiple destroyed meshes)
var     bool        bEmittersOn;                 // dust & exhaust effects are enabled
var     float       FriendlyResetDistance;       // used in CheckReset() as maximum range to check for friendly players, to avoid re-spawning vehicle
var     float       DriverTraceDistSquared;      // used in CheckReset() as range check on any friendly pawn found // Matt: seems to duplicate FriendlyResetDistance?
var     ObjectMap   NotifyParameters;            // an object that can hold references to several other objects, which can be used by messages to build a tailored message
var     bool        bNeedToInitializeDriver;     // clientside flag that we need to do some driver set up, once we receive the Driver actor
var     bool        bClientInitialized;          // clientside flag that replicated actor has completed initialization (set at end of PostNetBeginPlay)
                                                 // (allows client code to determine whether actor is just being received through replication, e.g. in PostNetReceive)
// Driver positions & view
var     name        PlayerCameraBone;            // just to avoid using literal references to 'Camera_driver' bone & allow extra flexibility
var     bool        bLockCameraDuringTransition; // lock the camera's rotation to the camera bone during view transitions
var     float       ViewTransitionDuration;      // used to control the time we stay in state ViewTransition

// Engine
var     bool        bEngineOff;                  // vehicle engine is simply switched off
var     bool        bSavedEngineOff;             // clientside record of current value, so PostNetReceive can tell if a new value has been replicated
var     float       IgnitionSwitchTime;          // records last time the engine was switched on/off - requires interval to stop people spamming the ignition switch
var     float       IgnitionSwitchInterval;      // how frequently the engine can be manually switched on/off

// Obstacle crushing & object collision
var     bool        bCrushedAnObject;            // vehicle has just crushed something, causing temporary movement stall
var     float       LastCrushedTime;             // records time object was crushed, so we know when the movement stall should end
var     float       ObjectCrushStallTime;        // how long the movement stall lasts
var     float       ObjectCollisionResistance;   // vehicle's resistance to colliding with other actors - a higher value reduces damage more

// Option to have mounted cannon - variables used by HUD (e.g. Sd.Kfz.251/22 - German half-track with mounted pak 40 AT gun)
var     ROTankCannon    Cannon;                  // reference to cannon actor
var     TexRotator      VehicleHudTurret;        // same as ROTreadCraft
var     TexRotator      VehicleHudTurretLook;    // same as ROTreadCraft

// New sounds & sound attachment actors
var     float               MaxPitchSpeed;
var     sound               EngineSound;
var     ROSoundAttachment   EngineSoundAttach;
var     name                EngineSoundBone;
var     sound               RumbleSound; // interior rumble sound
var     ROSoundAttachment   InteriorRumbleSoundAttach;
var     name                RumbleSoundBone;
var     sound               VehicleBurningSound;
var     sound               DestroyedBurningSound;
var     sound               DamagedStartUpSound;
var     float               LastBottomOutTime; // last time a bottom out sound was played

// Resupply attachments
var     class<RODummyAttachment>    ResupplyAttachmentClass;
var     RODummyAttachment           ResupplyAttachment;
var     name                        ResupplyAttachBone;
var     class<RODummyAttachment>    ResupplyDecoAttachmentClass;
var     RODummyAttachment           ResupplyDecoAttachment;
var     name                        ResupplyDecoAttachBone;

// Debugging
var     bool        bDebuggingText;
var     bool        bDebugExitPositions;
var     bool        bDrawExitPositions;

replication
{
    // Variables the server will replicate to all clients
    reliable if (bNetDirty && Role == ROLE_Authority)
        bEngineOff, bIsSpawnVehicle;
//      bEngineDead      // Matt: removed variable (EngineHealth <= 0 does the same thing)
//      EngineHealthMax  // Matt: removed variable (it never changed anyway & didn't need to be replicated)
//      bResupplyVehicle // Matt: removed variable (it never changed anyway & didn't need to be replicated)

    // Functions a client can call on the server
    reliable if (Role < ROLE_Authority)
        ServerStartEngine,
        ServerToggleDebugExits, ServerKillEngine; // these ones only during development
}

///////////////////////////////////////////////////////////////////////////////////////
//  ********************** ACTOR INITIALISATION & DESTRUCTION  ********************  //
///////////////////////////////////////////////////////////////////////////////////////

// Modified to spawn any sound or resuppply attachments & so net clients show unoccupied rider positions on the HUD vehicle icon
// Also to set up new NotifyParameters object, including this vehicle class, which gets passed to screen messages & allows them to display vehicle name
simulated function PostBeginPlay()
{
    super(Vehicle).PostBeginPlay(); // skip over Super in ROWheeledVehicle to avoid setting an initial timer, which we no longer use

    if (HasAnim(BeginningIdleAnim))
    {
        PlayAnim(BeginningIdleAnim);
    }

    if (Role == ROLE_Authority)
    {
        // If InitialPositionIndex is not zero, match position indexes now so when a player gets in, we don't trigger an up transition by changing DriverPositionIndex
        if (InitialPositionIndex > 0)
        {
            DriverPositionIndex = InitialPositionIndex;
            PreviousPositionIndex = InitialPositionIndex;
        }

        // Spawn the actual resupply actor - this is not the visual attachment, it's the real thing on the server
        if (ResupplyAttachmentClass != none && ResupplyAttachBone != '' && ResupplyAttachment == none)
        {
            ResupplyAttachment = Spawn(ResupplyAttachmentClass);
            AttachToBone(ResupplyAttachment, ResupplyAttachBone);
        }

        // For single player mode, we may as well set this here, as it's only intended to stop idiot players blowing up friendly vehicles in spawn
        if (Level.NetMode == NM_Standalone)
        {
            bDriverAlreadyEntered = true;
        }
    }
    else
    {
        // Matt: set this on a net client to work with our new rider pawn system, as rider pawns won't exist on client unless occupied
        // It forces client's WeaponPawns array to normal length, even though rider pawn slots may be empty - simply so we see all the grey rider position dots on HUD vehicle icon
        WeaponPawns.Length = PassengerWeapons.Length;
    }

    if (Level.NetMode != NM_DedicatedServer)
    {
        // Clientside sound & decorative attachments
        if (EngineSound != none && EngineSoundBone != '' && EngineSoundAttach == none)
        {
            EngineSoundAttach = Spawn(class'ROSoundAttachment');
            EngineSoundAttach.AmbientSound = EngineSound;
            AttachToBone(EngineSoundAttach, EngineSoundBone);
        }

        if (RumbleSound != none && RumbleSoundBone != '' && InteriorRumbleSoundAttach == none)
        {
            InteriorRumbleSoundAttach = Spawn(class'ROSoundAttachment');
            InteriorRumbleSoundAttach.AmbientSound = RumbleSound;
            AttachToBone(InteriorRumbleSoundAttach, RumbleSoundBone);
        }

        if (ResupplyDecoAttachmentClass != none && ResupplyDecoAttachBone != '' && ResupplyDecoAttachment == none)
        {
            ResupplyDecoAttachment = Spawn(ResupplyDecoAttachmentClass);
            AttachToBone(ResupplyDecoAttachment, ResupplyDecoAttachBone);
        }

        // Set up new NotifyParameters object
        NotifyParameters = new class'ObjectMap';
        NotifyParameters.Insert("VehicleClass", Class);
    }
}

// Modified to initialize engine-related properties
// Also on net client to flag if bNeedToInitializeDriver, to match clientside position indexes to replicated DriverPositionIndex, & to flag bClientInitialized when done
simulated function PostNetBeginPlay()
{
    super.PostNetBeginPlay();

    SetEngine();

    // Net client initialisation, based on replicated info about driving status/position
    if (Role < ROLE_Authority)
    {
        bSavedEngineOff = bEngineOff;

        if (bDriving)
        {
            bNeedToInitializeDriver = true;
        }

        SavedPositionIndex = DriverPositionIndex;
        PreviousPositionIndex = DriverPositionIndex;
        PendingPositionIndex = DriverPositionIndex;

        bClientInitialized = true;
    }
}

// Modified to destroy extra attachments & effects - including the DestructionEffect emitter
// That's because if an already exploded vehicle replicates to a net client, the vehicle gets Destroyed() before the natural LifeSpan of the emitter
// That left the DestructionEffect burning away in mid air after the vehicle has disappeared (the Super calls Kill() on the emitter, but it doesn't seem to work)
simulated function Destroyed()
{
    if (Role < ROLE_Authority && DestructionEffect != none)
    {
        DestructionEffect.Destroy(); // has to go before the Super, as that fails to destroy it, but does clear the actor reference
    }

    super.Destroyed();

    DestroyAttachments();
}

// Modified to score the vehicle kill
function Died(Controller Killer, class<DamageType> DamageType, vector HitLocation)
{
    super.Died(Killer, DamageType, HitLocation);

    if (Killer != none)
    {
        DarkestHourGame(Level.Game).ScoreVehicleKill(Killer, self, PointValue);
    }
}

///////////////////////////////////////////////////////////////////////////////////////
//  ***************************** KEY ENGINE EVENTS  ******************************  //
///////////////////////////////////////////////////////////////////////////////////////

// Matt: modified to handle engine on/off (including dust/exhaust emitters), instead of constantly checking in Tick
// Also to initialize driver-related stuff when we receive the Driver actor
simulated function PostNetReceive()
{
    // Driver has changed position
    // Checking bClientInitialized means we do nothing until PostNetBeginPlay() has matched position indexes, meaning we leave SetPlayerPosition() to handle any initial anims
    if (DriverPositionIndex != SavedPositionIndex && bClientInitialized)
    {
        PreviousPositionIndex = SavedPositionIndex;
        SavedPositionIndex = DriverPositionIndex;

        if (Driver != none) // no point playing transition anim if there's no driver (if he's just left, the BeginningIdleAnim will play)
        {
            NextViewPoint();
        }
    }

    // Engine has been switched on or off (but if not bClientInitialized, then actor has just replicated & SetEngine() will get called in PostBeginPlay)
    if (bEngineOff != bSavedEngineOff && bClientInitialized)
    {
        bSavedEngineOff = bEngineOff;
        IgnitionSwitchTime = Level.TimeSeconds; // so next time we can run a clientside time check to make sure engine toggle is valid, before sending call to ServerStartEngine()
        SetEngine();
    }

    // Initialize the driver
    if (bNeedToInitializeDriver && Driver != none)
    {
        bNeedToInitializeDriver = false;
        SetPlayerPosition();
    }
}

// Modified to handle engine & interior rumble sounds, object crushing, & stopping all movement if vehicle can't move
simulated function Tick(float DeltaTime)
{
    local float MotionSoundVolume;

    super(ROWheeledVehicle).Tick(DeltaTime);

    // Very heavy damage to engine limits speed
    if (EngineHealth <= (default.EngineHealth * 0.25) && EngineHealth > 0)
    {
        Throttle = FClamp(Throttle, -0.5, 0.5);
    }

    // Update engine & interior rumble sounds dependent on speed
    if (Level.NetMode != NM_DedicatedServer)
    {
        if (Abs(ForwardVel) > 0.1)
        {
            MotionSoundVolume = FClamp(Abs(ForwardVel) / MaxPitchSpeed * 255.0, 0.0, 255.0);
        }

        UpdateMovementSound(MotionSoundVolume);
    }

    // If we crushed an object, apply brake & clamp throttle (server only)
    if (bCrushedAnObject)
    {
        if (ROPlayer(Controller) != none)
        {
            ROPlayer(Controller).bPressedJump = true;
        }

        Throttle = FClamp(Throttle, -0.1, 0.1);

        // If our crush stall time is over, we are no longer crushing
        if (LastCrushedTime + ObjectCrushStallTime < Level.TimeSeconds)
        {
            bCrushedAnObject = false;
        }
    }

    // Stop all movement if engine off
    if (bEngineOff)
    {
        Velocity = vect(0.0, 0.0, 0.0);
        Throttle = 0.0;
        ThrottleAmount = 0.0;
        Steering = 0.0;
    }
}

// Matt: drops all RO stuff about bDriverAlreadyEntered, bDisableThrottle & CheckForCrew, as in DH we don't wait for crew anyway - so just set bDriverAlreadyEntered in KDriverEnter()
function Timer()
{
    // Check to see if we need to destroy a spiked, abandoned vehicle
    if (bSpikedVehicle)
    {
        if (Health > 0 && IsVehicleEmpty())
        {
            KilledBy(self);
        }
        else
        {
            bSpikedVehicle = false; // cancel spike timer if vehicle is now occupied or destroyed
        }
    }
}

///////////////////////////////////////////////////////////////////////////////////////
//  *******************************  VIEW/DISPLAY  ********************************  //
///////////////////////////////////////////////////////////////////////////////////////

// Modified to make locking of view during ViewTransition optional, to handle FPCamPos, & to optimise & simplify generally
simulated function SpecialCalcFirstPersonView(PlayerController PC, out Actor ViewActor, out vector CameraLocation, out rotator CameraRotation)
{
    local quat RelativeQuat, VehicleQuat, NonRelativeQuat;

    ViewActor = self;

    // Set CameraRotation
    if (IsInState('ViewTransition') && bLockCameraDuringTransition)
    {
        CameraRotation = GetBoneRotation(PlayerCameraBone); // if camera is locked during a current transition, lock rotation to PlayerCameraBone
    }
    else if (PC != none)
    {
        // Factor in the vehicle's rotation, as PC's rotation is relative to vehicle
        RelativeQuat = QuatFromRotator(Normalize(PC.Rotation));
        VehicleQuat = QuatFromRotator(Rotation);
        NonRelativeQuat = QuatProduct(RelativeQuat, VehicleQuat);
        CameraRotation = Normalize(QuatToRotator(NonRelativeQuat));
    }

    // Get camera location & adjust for any offset positioning (FPCamPos is set from any ViewLocation in DriverPositions)
    CameraLocation = GetBoneCoords(PlayerCameraBone).Origin;
    CameraLocation = CameraLocation + (FPCamPos >> Rotation);

    // Finalise the camera with any shake
    if (PC != none)
    {
        CameraRotation = Normalize(CameraRotation + PC.ShakeRot);
        CameraLocation = CameraLocation + (PC.ShakeOffset >> PC.Rotation);
    }
}

// Modified to remove irrelevant stuff about driver weapon crosshair & to optimise a little
// Includes omitting calling DrawVehicle (as is just a 1 liner that can be optimised) & DrawPassengers (as is just an empty function)
simulated function DrawHUD(Canvas C)
{
    local PlayerController PC;
    local vector           CameraLocation;
    local rotator          CameraRotation;
    local Actor            ViewActor;

    PC = PlayerController(Controller);

    if (PC != none && !PC.bBehindView)
    {
        // Player is in a position where an overlay should be drawn
        if (DriverPositions[DriverPositionIndex].bDrawOverlays && !IsInState('ViewTransition'))
        {
            if (HUDOverlay == none)
            {
                ActivateOverlay(true);
            }

            // Draw any HUD overlay
            if (HUDOverlay != none && !Level.IsSoftwareRendering())
            {
                CameraRotation = PC.Rotation;
                SpecialCalcFirstPersonView(PC, ViewActor, CameraLocation, CameraRotation);
                HUDOverlay.SetLocation(CameraLocation + (HUDOverlayOffset >> CameraRotation));
                HUDOverlay.SetRotation(CameraRotation);

                C.DrawActor(HUDOverlay, false, true, FClamp(HUDOverlayFOV * (PC.DesiredFOV / PC.DefaultFOV), 1.0, 170.0));
            }
        }

        // Draw vehicle, turret, ammo count, passenger list
        if (ROHud(PC.myHUD) != none)
        {
            ROHud(PC.myHUD).DrawVehicleIcon(C, self);
        }
    }
    else if (HUDOverlay != none)
    {
        ActivateOverlay(false);
    }
}

// Modified so we don't limit view yaw if in behind view
simulated function int LimitYaw(int yaw)
{
    local int NewYaw;

    if (!bLimitYaw || (IsHumanControlled() && PlayerController(Controller).bBehindView))
    {
        return yaw;
    }

    NewYaw = yaw;

    if (yaw > DriverPositions[DriverPositionIndex].ViewPositiveYawLimit)
    {
        NewYaw = DriverPositions[DriverPositionIndex].ViewPositiveYawLimit;
    }
    else if (yaw < DriverPositions[DriverPositionIndex].ViewNegativeYawLimit)
    {
        NewYaw = DriverPositions[DriverPositionIndex].ViewNegativeYawLimit;
    }

    return NewYaw;
}

// Modified to revert to Super in Pawn, skipping unnecessary stuff in ROWheeledVehicle & ROVehicle, as this is a many-times-a-second function & so should be optimised
function int LimitPitch(int pitch, optional float DeltaTime)
{
    return super(Pawn).LimitPitch(pitch, DeltaTime);
}

// Modified so we don't limit view pitch if in behind view
// Also to correct apparent error in ROVehicle, where PitchDownLimit was being used instead of DriverPositions[x].ViewPitchDownLimit in multi position weapon
function int LimitPawnPitch(int pitch)
{
    pitch = pitch & 65535;

    if (bLimitPitch && !(IsHumanControlled() && PlayerController(Controller).bBehindView) && DriverPositions.Length > 0)
    {
        if (pitch > DriverPositions[DriverPositionIndex].ViewPitchUpLimit && pitch < DriverPositions[DriverPositionIndex].ViewPitchDownLimit)
        {
            if (pitch - DriverPositions[DriverPositionIndex].ViewPitchUpLimit < DriverPositions[DriverPositionIndex].ViewPitchDownLimit - pitch)
            {
                pitch = DriverPositions[DriverPositionIndex].ViewPitchUpLimit;
            }
            else
            {
                pitch = DriverPositions[DriverPositionIndex].ViewPitchDownLimit;
            }
        }
    }

    return pitch;
}

// Modified to switch to external mesh & unzoomed FOV for behind view
simulated function POVChanged(PlayerController PC, bool bBehindViewChanged)
{
    if (PC.bBehindView)
    {
        if (bBehindViewChanged)
        {
            FixPCRotation(PC); // switching to behind view, so make rotation non-relative to vehicle

            // Switch to external vehicle mesh & unzoomed view
            SwitchMesh(-1, true); // -1 signifies switch to default external mesh
            PC.SetFOV(PC.DefaultFOV);
        }

        bOwnerNoSee = false;

        if (Driver != none)
        {
            Driver.bOwnerNoSee = !bDrawDriverInTP;
        }

        if (PC == Controller) // no overlays for spectators
        {
            ActivateOverlay(false);
        }
    }
    else
    {
        PC.SetRotation(rotator(vector(PC.Rotation) << Rotation)); // switching back from behind view, so make rotation relative to vehicle again

        // Switch back to position's normal vehicle mesh & view FOV
        if (bBehindViewChanged && DriverPositions.Length > 0)
        {
            SwitchMesh(DriverPositionIndex, true);
            PC.SetFOV(DriverPositions[DriverPositionIndex].ViewFOV);
        }

        bOwnerNoSee = !bDrawMeshInFP;

        if (Driver != none)
        {
            Driver.bOwnerNoSee = Driver.default.bOwnerNoSee;
        }

        if (bDriving && PC == Controller)
        {
            ActivateOverlay(true);
        }
    }
}

///////////////////////////////////////////////////////////////////////////////////////
//  ******************************** VEHICLE ENTRY  ******************************** //
///////////////////////////////////////////////////////////////////////////////////////

// Modified to simplify by removing the ClosestWeaponPawn stuff - it really doesn't matter which is closest
// We only check player distance vs EntryRadius for the vehicle itself & if it has a driver, we just loop through the weapon pawns in turn
function Vehicle FindEntryVehicle(Pawn P)
{
    local VehicleWeaponPawn WP;
    local Vehicle           VehicleGoal;
    local Bot               B;
    local bool              bPlayerIsTankCrew;
    local float             Distance;
    local int               i;

    B = Bot(P.Controller);

    // Bots know what they want
    if (B != none)
    {
        VehicleGoal = Vehicle(B.RouteGoal);

        if (VehicleGoal == none)
        {
            return none;
        }

        if (VehicleGoal == self)
        {
            if (Driver == none)
            {
                return self;
            }

            return none;
        }

        for (i = 0; i < WeaponPawns.Length; ++i)
        {
            WP = WeaponPawns[i];

            if (VehicleGoal == WP && WP != none)
            {
                if (WP.Driver == none)
                {
                    return WP;
                }

                if (Driver == none)
                {
                    return self;
                }

                return none;
            }
        }

        return none;
    }

    // Check whether we are in entry range of the vehicle
    Distance = VSize(P.Location - (Location + (EntryPosition >> Rotation)));

    if (Distance > EntryRadius)
    {
        return none; // not in range to enter
    }

    // Record whether player is allowed to use tanks
    bPlayerIsTankCrew = P != none && P.Controller != none && ROPlayerReplicationInfo(P.Controller.PlayerReplicationInfo) != none &&
        ROPlayerReplicationInfo(P.Controller.PlayerReplicationInfo).RoleInfo != none && ROPlayerReplicationInfo(P.Controller.PlayerReplicationInfo).RoleInfo.bCanBeTankCrew;

    // Enter driver position if it's empty & player isn't barred by tank crew restriction
    if (Driver == none && (bPlayerIsTankCrew || !bMustBeTankCommander))
    {
        return self;
    }

    // Otherwise loop through the weapon pawns to check if we can enter one
    for (i = 0; i < WeaponPawns.Length; ++i)
    {
        WP = WeaponPawns[i];

        // Enter weapon pawn position if it's empty & player isn't barred by tank crew restriction
        if (WP != none && WP.Driver == none && (bPlayerIsTankCrew || !WP.IsA('ROVehicleWeaponPawn') || !ROVehicleWeaponPawn(WP).bMustBeTankCrew))
        {
            return WP;
        }
    }

    return none; // there are no empty, usable vehicle positions
}

// Modified to prevent entry if player is on fire
function bool TryToDrive(Pawn P)
{
    local bool bCantEnterEnemyVehicle;
    local int  i;

    // Deny entry if vehicle has driver or is dead, or if player is crouching or on fire or reloading a weapon (plus several very obscure other reasons)
    if (Driver != none ||
        Health <= 0 ||
        P == none ||
        (DHPawn(P) != none && DHPawn(P).bOnFire) ||
        (P.Weapon != none && P.Weapon.IsInState('Reloading')) ||
        P.Controller == none ||
        !P.Controller.bIsPlayer ||
        P.DrivenVehicle != none ||
        P.IsA('Vehicle') ||
        bNonHumanControl ||
        !Level.Game.CanEnterVehicle(self, P))
    {
        return false;
    }

    if (bDebuggingText)
    {
        P.ClientMessage("Vehicle Health:" @ Health $ ", EngineHealth:" @ EngineHealth);
    }

    // Trying to enter a vehicle that isn't on our team
    if (P != none && P.GetTeamNum() != VehicleTeam)
    {
        if (bTeamLocked)
        {
            bCantEnterEnemyVehicle = true;
        }
        // If not team locked, check if already has an enemy occupant
        else if (Driver != none && P.GetTeamNum() != Driver.GetTeamNum())
        {
            bCantEnterEnemyVehicle = true;
        }
        else
        {
            for (i = 0; i < WeaponPawns.Length; ++i)
            {
                if (WeaponPawns[i].Driver != none && P.GetTeamNum() != WeaponPawns[i].Driver.GetTeamNum())
                {
                    bCantEnterEnemyVehicle = true;
                    break;
                }
            }
        }

        if (bCantEnterEnemyVehicle)
        {
            DenyEntry(P, 1); // can't use enemy vehicle

            return false;
        }
    }

    // Deny entry if vehicle can only be used by tank crew & player is not a tanker role
    if (bMustBeTankCommander && !(ROPlayerReplicationInfo(P.Controller.PlayerReplicationInfo) != none && ROPlayerReplicationInfo(P.Controller.PlayerReplicationInfo).RoleInfo != none
        && ROPlayerReplicationInfo(P.Controller.PlayerReplicationInfo).RoleInfo.bCanBeTankCrew) && P.IsHumanControlled())
    {
       DenyEntry(P, 0); // not qualified to operate vehicle

       return false;
    }

    // Passed all checks, so allow player to enter the vehicle
    if (bEnterringUnlocks && bTeamLocked)
    {
        bTeamLocked = false;
    }

    KDriverEnter(P);

    return true;
}

// Modified to avoid playing engine start sound when entering vehicle
function KDriverEnter(Pawn P)
{
    bDriverAlreadyEntered = true; // Matt: added here as a much simpler alternative to the Timer() in ROWheeledVehicle
    DriverPositionIndex = InitialPositionIndex;
    PreviousPositionIndex = InitialPositionIndex;
    Instigator = self;
    ResetTime = Level.TimeSeconds - 1.0;

    if (bEngineOff && !P.IsHumanControlled()) // lets bots start vehicle
    {
        ServerStartEngine();
    }

    super(Vehicle).KDriverEnter(P); // need to skip over Super from ROVehicle

    Driver.bSetPCRotOnPossess = false; // so when driver gets out he'll be facing the same direction as he was inside the vehicle
}

// Modified to add an engine start/stop hint & to enforce bDesiredBehindView = false (avoids a view rotation bug)
// Matt: also to work around a possible camera problem on net clients when deploying into spawn vehicle, caused by replication timing issues
simulated function ClientKDriverEnter(PlayerController PC)
{
    local DHPlayer P;

    // Fixes potential problem on net clients when deploying into a spawn vehicle (see notes in DHVehicleMGPawn.ClientKDriverEnter)
    if (Role < ROLE_Authority && PC != none && PC.IsInState('Spectating'))
    {
        PC.GotoState('PlayerWalking');
    }

    bDesiredBehindView = false; // true values can exist in user.ini config file, if player exited game while in behind view in same vehicle (config values change class defaults)

    P = DHPlayer(PC);

    if (P != none)
    {
        P.QueueHint(40, true);

        if (bIsSpawnVehicle)
        {
            P.QueueHint(14, true);
            P.QueueHint(16, true);
        }
    }

    super.ClientKDriverEnter(PC);
}

// Modified to use InitialPositionIndex & to play BeginningIdleAnim on internal mesh when entering vehicle
simulated state EnteringVehicle
{
    simulated function HandleEnter()
    {
        SwitchMesh(InitialPositionIndex);

        if (HasAnim(BeginningIdleAnim))
        {
            PlayAnim(BeginningIdleAnim); // shouldn't actually be necessary, but a reasonable fail-safe
        }

        if (IsHumanControlled())
        {
            PlayerController(Controller).SetFOV(DriverPositions[InitialPositionIndex].ViewFOV);
        }
    }
}

// Modified to avoid starting exhaust & dust effects just because we got in - now we need to wait until the engine is started
// Also to play idle animation for other net clients (not just owning client), so we reset visuals like hatches
// And to avoid unnecessary stuff on dedicated server & the call to Super in Vehicle class (it only duplicates)
simulated event DrivingStatusChanged()
{
    local PlayerController PC;

    if (Level.NetMode != NM_DedicatedServer)
    {
        // Player has exited
        if (!bDriving)
        {
            // Vehicle will now stop, so no motion sound
            UpdateMovementSound(0.0);

            // Play neutral idle animation
            if (HasAnim(BeginningIdleAnim))
            {
                PlayAnim(BeginningIdleAnim);
            }
        }

        PC = Level.GetLocalPlayerController();

        // Update bDropDetail, which if true will avoid dust & exhaust emitters as unnecessary detail
        bDropDetail = bDriving && PC != none && (PC.ViewTarget == none || !PC.ViewTarget.IsJoinedTo(self)) && (Level.bDropDetail || Level.DetailMode == DM_Low);
    }

    if (bDriving)
    {
        Enable('Tick');
    }
    else
    {
        Disable('Tick');
    }
}

///////////////////////////////////////////////////////////////////////////////////////
//  ***************************** DRIVER VIEW POINTS  ****************************** //
///////////////////////////////////////////////////////////////////////////////////////

// Modified to avoid wasting network resources by calling ServerChangeViewPoint on the server when it isn't valid
simulated function NextWeapon()
{
    if (DriverPositionIndex < DriverPositions.Length - 1 && DriverPositionIndex == PendingPositionIndex && !IsInState('ViewTransition') && bMultiPosition)
    {
        PendingPositionIndex = DriverPositionIndex + 1;
        ServerChangeViewPoint(true);
    }
}

simulated function PrevWeapon()
{
    if (DriverPositionIndex > 0 && DriverPositionIndex == PendingPositionIndex && !IsInState('ViewTransition') && bMultiPosition)
    {
        PendingPositionIndex = DriverPositionIndex -1;
        ServerChangeViewPoint(false);
    }
}

// Modified to call NextViewPoint() for all modes, including dedicated server
// New player hit detection system (basically using normal hit detection as for an infantry player pawn) relies on server playing same animations as net clients
function ServerChangeViewPoint(bool bForward)
{
    if (bForward)
    {
        if (DriverPositionIndex < (DriverPositions.Length - 1))
        {
            PreviousPositionIndex = DriverPositionIndex;
            DriverPositionIndex++;
            NextViewPoint();
        }
    }
    else
    {
        if (DriverPositionIndex > 0)
        {
            PreviousPositionIndex = DriverPositionIndex;
            DriverPositionIndex--;
            NextViewPoint();
        }
    }
}

// Modified to enter state ViewTransition for all modes except dedicated server where player is only moving between unexposed positions (so can't be shot & server doesn't need anims)
simulated function NextViewPoint()
{
    if (Level.NetMode != NM_DedicatedServer || DriverPositions[DriverPositionIndex].bExposed || DriverPositions[PreviousPositionIndex].bExposed)
    {
        GotoState('ViewTransition');
    }
}

// Modified to enable or disable player's hit detection when moving to or from an exposed position, to use Sleep to control exit from state,
// to add handling of FOV changes & better handling of locked camera, to avoid switching mesh & FOV if in behind view, & to avoid unnecessary stuff on a server
simulated state ViewTransition
{
    simulated function HandleTransition()
    {
        if (Level.NetMode != NM_DedicatedServer)
        {
            if (!(IsHumanControlled() && PlayerController(Controller).bBehindView))
            {
                // Switch to mesh for new position as may be different
                SwitchMesh(DriverPositionIndex);

                // If moving to a less zoomed position, we zoom out now, otherwise we wait until end of transition to zoom in
                if (DriverPositions[DriverPositionIndex].ViewFOV > DriverPositions[PreviousPositionIndex].ViewFOV && IsHumanControlled())
                {
                    if (DriverPositions[DriverPositionIndex].bDrawOverlays)
                    {
                        PlayerController(Controller).SetFOV(DriverPositions[DriverPositionIndex].ViewFOV);
                    }
                    else
                    {
                        PlayerController(Controller).DesiredFOV = DriverPositions[DriverPositionIndex].ViewFOV;
                    }
                }
            }
        }

        if (Driver != none)
        {
            // If moving to an exposed position, enable the driver's hit detection
            if (DriverPositions[DriverPositionIndex].bExposed && !DriverPositions[PreviousPositionIndex].bExposed && ROPawn(Driver) != none)
            {
                ROPawn(Driver).ToggleAuxCollision(true);
            }

            // Play any transition animation for the driver
            if (Driver.HasAnim(DriverPositions[DriverPositionIndex].DriverTransitionAnim) && Driver.HasAnim(DriverPositions[PreviousPositionIndex].DriverTransitionAnim))
            {
                Driver.PlayAnim(DriverPositions[DriverPositionIndex].DriverTransitionAnim);
            }
        }

        // Play any transition animation for the vehicle itself & set a duration to control when we exit this state
        ViewTransitionDuration = 0.0; // start with zero in case we don't have a transition animation

        if (PreviousPositionIndex < DriverPositionIndex)
        {
            if (HasAnim(DriverPositions[PreviousPositionIndex].TransitionUpAnim))
            {
                PlayAnim(DriverPositions[PreviousPositionIndex].TransitionUpAnim);
                ViewTransitionDuration = GetAnimDuration(DriverPositions[PreviousPositionIndex].TransitionUpAnim);
            }
        }
        else if (HasAnim(DriverPositions[PreviousPositionIndex].TransitionDownAnim))
        {
            PlayAnim(DriverPositions[PreviousPositionIndex].TransitionDownAnim);
            ViewTransitionDuration = GetAnimDuration(DriverPositions[PreviousPositionIndex].TransitionDownAnim);
        }
    }

    // Emptied out so that Sleep is the sole timing for exiting this state
    simulated function AnimEnd(int channel)
    {
    }

    // Reverted to global Timer as Sleep is now the sole means of exiting this state
    simulated function Timer()
    {
        global.Timer();
    }

    simulated function EndState()
    {
        if (Level.NetMode != NM_DedicatedServer && IsHumanControlled() && !PlayerController(Controller).bBehindView)
        {
            // If we have moved to a more zoomed position, we zoom in now, because we didn't do it earlier
            if (DriverPositions[DriverPositionIndex].ViewFOV < DriverPositions[PreviousPositionIndex].ViewFOV)
            {
                PlayerController(Controller).SetFOV(DriverPositions[DriverPositionIndex].ViewFOV);
            }

            // If camera was locked to PlayerCameraBone during transition, match rotation to that now, so the view can't snap to another rotation
            if (bLockCameraDuringTransition && ViewTransitionDuration > 0.0)
            {
                Controller.SetRotation(rotator(vector(GetBoneRotation(PlayerCameraBone)) << Rotation));
            }
        }

        // If moving to an unexposed position, disable the driver's hit detection
        if (!DriverPositions[DriverPositionIndex].bExposed && DriverPositions[PreviousPositionIndex].bExposed && ROPawn(Driver) != none)
        {
            ROPawn(Driver).ToggleAuxCollision(false);
        }
    }

Begin:
    HandleTransition();
    Sleep(ViewTransitionDuration);
    GotoState('');
}

///////////////////////////////////////////////////////////////////////////////////////
//  ******************************** VEHICLE EXIT  ********************************* //
///////////////////////////////////////////////////////////////////////////////////////

// Modified to add clientside checks before sending the function call to the server
simulated function SwitchWeapon(byte F)
{
    local VehicleWeaponPawn WeaponPawn;
    local bool              bMustBeTankerToSwitch;
    local byte              ChosenWeaponPawnIndex;

    if (Role == ROLE_Authority) // if we're not a net client, skip clientside checks & jump straight to the server function call
    {
        ServerChangeDriverPosition(F);
    }

    ChosenWeaponPawnIndex = F - 2;

    // Stop call to server if player has selected an invalid weapon position
    // Note that if player presses 0 or 1, which are invalid choices, the byte index will end up as 254 or 255 & so will still fail this test (which is what we want)
    if (ChosenWeaponPawnIndex >= PassengerWeapons.Length)
    {
        return;
    }

    // Stop call to server if weapon position already has a human player
    // Note we don't try to stop call to server if weapon pawn doesn't exist, as it may not on net client, but will get replicated if player enters position on server
    if (ChosenWeaponPawnIndex < WeaponPawns.Length)
    {
        WeaponPawn = WeaponPawns[ChosenWeaponPawnIndex];

        if (WeaponPawn != none && WeaponPawn.Driver != none && WeaponPawn.Driver.IsHumanControlled())
        {
            return;
        }
        else if (WeaponPawn == none && class<ROPassengerPawn>(PassengerWeapons[ChosenWeaponPawnIndex].WeaponPawnClass) == none) // TEMP DEBUG
            Log(Tag @ Caps("SwitchWeapon would have prevented switch to WeaponPawns[" $ ChosenWeaponPawnIndex $ "] as WP doesn't exist on client"));
    }

    if (class<ROVehicleWeaponPawn>(PassengerWeapons[ChosenWeaponPawnIndex].WeaponPawnClass).default.bMustBeTankCrew)
    {
        bMustBeTankerToSwitch = true;
    }

    // Stop call to server if player has selected a tank crew role but isn't a tanker
    if (bMustBeTankerToSwitch && !(Controller != none && ROPlayerReplicationInfo(Controller.PlayerReplicationInfo) != none
        && ROPlayerReplicationInfo(Controller.PlayerReplicationInfo).RoleInfo != none && ROPlayerReplicationInfo(Controller.PlayerReplicationInfo).RoleInfo.bCanBeTankCrew))
    {
        DenyEntry(self, 0); // not qualified to operate vehicle

        return;
    }

    ServerChangeDriverPosition(F);
}

// Modified to prevent moving to another vehicle position while moving between view points
function ServerChangeDriverPosition(byte F)
{
    if (IsInState('ViewTransition'))
    {
        return;
    }

    super.ServerChangeDriverPosition(F);
}

// Modified to give players the same momentum as the vehicle when exiting
// Also to remove overlap with DriverDied(), moving common features into DriverLeft(), which gets called by both functions
function bool KDriverLeave(bool bForceLeave)
{
    local vector ExitVelocity;

    if (!bForceLeave)
    {
        ExitVelocity = Velocity;
        ExitVelocity.Z += 60.0; // add a little height kick to allow for hacked in damage system
    }

    if (super(ROVehicle).KDriverLeave(bForceLeave))
    {
        if (!bForceLeave)
        {
            Instigator.Velocity = ExitVelocity;
        }

        return true;
    }

    return false;
}

// Modified to remove overlap with KDriverLeave(), moving common features into DriverLeft(), which gets called by both functions
function DriverDied()
{
    super(ROVehicle).DriverDied();
}

// Modified to avoid playing engine shut down sound when leaving vehicle & also to use IdleTimeBeforeReset
// Also to add common features from KDriverLeave() & DriverLeft(), which both call this function
function DriverLeft()
{
    DriverPositionIndex = InitialPositionIndex;
    PreviousPositionIndex = InitialPositionIndex;
    MaybeDestroyVehicle();
    DrivingStatusChanged(); // the Super from Vehicle, as we need to skip over Super in ROVehicle
}

// Modified to use new, simplified system with exit positions for all vehicle positions included in the vehicle class default properties
function bool PlaceExitingDriver()
{
    local int    i;
    local vector Extent, HitLocation, HitNormal, ZOffset, ExitPosition;

    if (Driver == none)
    {
        return false;
    }

    Extent = Driver.GetCollisionExtent();
    ZOffset = Driver.default.CollisionHeight * vect(0.0, 0.0, 0.5);

    // Debug exits - uses DHWheeledVehicle class default, allowing bDebugExitPositions to be toggled for all DHWheeledVehicles
    if (class'DHWheeledVehicle'.default.bDebugExitPositions)
    {
        for (i = 0; i < ExitPositions.Length; ++i)
        {
            ExitPosition = Location + (ExitPositions[i] >> Rotation) + ZOffset;

            Spawn(class'DHDebugTracer',,, ExitPosition);
        }
    }

    for (i = 0; i < ExitPositions.Length; ++i)
    {
        ExitPosition = Location + (ExitPositions[i] >> Rotation) + ZOffset;

        if (Trace(HitLocation, HitNormal, ExitPosition, Location + ZOffset, false, Extent) != none ||
            Trace(HitLocation, HitNormal, ExitPosition, ExitPosition + ZOffset, false, Extent) != none)
        {
            continue;
        }

        if (Driver.SetLocation(ExitPosition))
        {
            return true;
        }
    }

    return false;
}

///////////////////////////////////////////////////////////////////////////////////////
//  ************************* ENGINE START/STOP & EFFECTS ************************** //
///////////////////////////////////////////////////////////////////////////////////////

// Modified to use fire button to start or stop engine
simulated function Fire(optional float F)
{
    // Clientside checks to prevent unnecessary replicated function call to server if invalid (including clientside time check)
    if (Role == ROLE_Authority || (Throttle == 0.0 && (Level.TimeSeconds - IgnitionSwitchTime) > default.IgnitionSwitchInterval))
    {
        ServerStartEngine();
    }
}

// Emptied out to prevent unnecessary replicated function calls to server - vehicles don't use AltFire
function AltFire(optional float F)
{
}

// Server side function called to switch engine on/off
function ServerStartEngine()
{
    local DHGameReplicationInfo GRI;

    GRI = DHGameReplicationInfo(Level.Game.GameReplicationInfo);

    // Throttle must be zeroed & also a time check so people can't spam the ignition switch
    if (Throttle == 0.0 && (Level.TimeSeconds - IgnitionSwitchTime) > default.IgnitionSwitchInterval)
    {
        IgnitionSwitchTime = Level.TimeSeconds;

        if (EngineHealth > 0)
        {
            bEngineOff = !bEngineOff;

            SetEngine();

            if (bEngineOff)
            {
                if (ShutDownSound != none)
                {
                    PlaySound(ShutDownSound, SLOT_None, 1.0);
                }
            }
            else if (StartUpSound != none)
            {
                PlaySound(StartUpSound, SLOT_None, 1.0);
            }
        }
        else
        {
            PlaySound(DamagedStartUpSound, SLOT_None, 2.0);
        }
    }
}

// New function to set up the engine properties
simulated function SetEngine()
{
    if (bEngineOff)
    {
        TurnDamping = 0.0;

        // If engine is dead then start a fire
        if (EngineHealth <= 0)
        {
            DamagedEffectHealthFireFactor = 1.0;
            DamagedEffectHealthSmokeFactor = 1.0; // appears necessary to get native code to spawn a DamagedEffect if it doesn't already exist
                                                  // (presumably doesn't check for fire unless vehicle is at least damaged enough to smoke)

            if (DamagedEffect == none && Health == HealthMax) // clientside Health hack to get native code to spawn DamagedEffect (it won't unless vehicle has taken some damage)
            {
                Health--;
            }

            AmbientSound = VehicleBurningSound;
            SoundVolume = 255;
            SoundRadius = 200.0;
        }
        else
        {
            AmbientSound = none;
        }

        if (bEmittersOn)
        {
            StopEmitters();
        }
    }
    else
    {
        if (IdleSound != none)
        {
            AmbientSound = IdleSound;
        }

        if (!bEmittersOn)
        {
            StartEmitters();
        }
    }
}

// New function to spawn exhaust & wheel dust emitters
simulated function StartEmitters()
{
    local int    i;
    local coords WheelCoords;

    if (Level.NetMode != NM_DedicatedServer && !bDropDetail)
    {
        Dust.Length = Wheels.Length;

        for (i = 0; i < Wheels.Length; ++i)
        {
            if (Dust[i] != none)
            {
                Dust[i].Destroy();
            }

            // Create wheel dust emitters
            WheelCoords = GetBoneCoords(Wheels[i].BoneName);
            Dust[i] = Spawn(class'VehicleWheelDustEffect', self,, WheelCoords.Origin + ((vect(0.0, 0.0, -1.0) * Wheels[i].WheelRadius) >> Rotation));

            if (Level.bDropDetail || Level.DetailMode == DM_Low)
            {
                Dust[i].MaxSpritePPS = 3;
                Dust[i].MaxMeshPPS = 3;
            }

            Dust[i].SetBase(self);
            Dust[i].SetDirtColor(Level.DustColor);
        }

        for (i = 0; i < ExhaustPipes.Length; ++i)
        {
            if (ExhaustPipes[i].ExhaustEffect != none)
            {
                ExhaustPipes[i].ExhaustEffect.Destroy();
            }

            // Create exhaust emitters
            if (Level.bDropDetail || Level.DetailMode == DM_Low)
            {
                ExhaustPipes[i].ExhaustEffect = Spawn(ExhaustEffectLowClass, self,, Location + (ExhaustPipes[i].ExhaustPosition >> Rotation), ExhaustPipes[i].ExhaustRotation + Rotation);
            }
            else
            {
                ExhaustPipes[i].ExhaustEffect = Spawn(ExhaustEffectClass, self,, Location + (ExhaustPipes[i].ExhaustPosition >> Rotation), ExhaustPipes[i].ExhaustRotation + Rotation);
            }

            ExhaustPipes[i].ExhaustEffect.SetBase(self);

            if (!bDriving) // if bDriving, Tick will be enabled & ExhaustEffect will get updated anyway, based on vehicle speed
            {
                ExhaustPipes[i].ExhaustEffect.UpdateExhaust(0.0); // nil update just sets the lowest setting for an idling engine
            }
        }

        bEmittersOn = true;
    }
}

// New function to kill exhaust & wheel dust emitters
simulated function StopEmitters()
{
    local int i;

    if (Level.NetMode != NM_DedicatedServer && !bDropDetail)
    {
        for (i = 0; i < Dust.Length; ++i)
        {
            if (Dust[i] != none)
            {
                Dust[i].Kill();
            }
        }

        Dust.Length = 0;

        for (i = 0; i < ExhaustPipes.Length; ++i)
        {
            if (ExhaustPipes[i].ExhaustEffect != none)
            {
                ExhaustPipes[i].ExhaustEffect.Kill();
            }
        }
    }

    bEmittersOn = false;
}

///////////////////////////////////////////////////////////////////////////////////////
//  *********************************  DAMAGE  ************************************  //
///////////////////////////////////////////////////////////////////////////////////////

// Slightly modified to add randomised damage but mainly to tidy & standardise with TakeDamage in other vehicle classes
function TakeDamage(int Damage, Pawn InstigatedBy, vector HitLocation, vector Momentum, class<DamageType> DamageType, optional int HitIndex)
{
    local Controller InstigatorController;
    local float      VehicleDamageMod, HitCheckDistance;
    local int        InstigatorTeam, PossibleDriverDamage, i;
    local bool       bHitDriver;

    // Fix for suicide death messages
    if (DamageType == class'Suicided')
    {
        DamageType = class'ROSuicided';
        ROVehicleWeaponPawn(Owner).TakeDamage(Damage, InstigatedBy, HitLocation, Momentum, DamageType);
    }
    else if (DamageType == class'ROSuicided')
    {
        ROVehicleWeaponPawn(Owner).TakeDamage(Damage, InstigatedBy, HitLocation, Momentum, DamageType);
    }

    // Quick fix for the thing giving itself impact damage
    if (InstigatedBy == self)
    {
        return;
    }

    // Don't allow your own teammates to destroy vehicles in spawns (and you know some jerks would get off on doing that to their team :))
    if (!bDriverAlreadyEntered)
    {
        if (InstigatedBy != none)
        {
            InstigatorController = InstigatedBy.Controller;
        }

        if (InstigatorController == none && DamageType.default.bDelayedDamage)
        {
            InstigatorController = DelayedDamageInstigatorController;
        }

        if (InstigatorController != none)
        {
            InstigatorTeam = InstigatorController.GetTeamNum();

            if (GetTeamNum() != 255 && InstigatorTeam != 255 && GetTeamNum() == InstigatorTeam)
            {
                return;
            }
        }
    }

    // Set damage modifier from the DamageType, based on type of vehicle
    if (class<ROWeaponDamageType>(DamageType) != none)
    {
        if (bIsApc)
        {
            VehicleDamageMod = class<ROWeaponDamageType>(DamageType).default.APCDamageModifier;
        }
        else
        {
            VehicleDamageMod = class<ROWeaponDamageType>(DamageType).default.VehicleDamageModifier;
        }
    }
    else if (class<ROVehicleDamageType>(DamageType) != none)
    {
        if (bIsApc)
        {
            VehicleDamageMod = class<ROVehicleDamageType>(DamageType).default.APCDamageModifier;
        }
        else
        {
            VehicleDamageMod = class<ROVehicleDamageType>(DamageType).default.VehicleDamageModifier;
        }
    }

    // No damage, except possibly to driver, if less than MinVehicleDamageModifier for this vehicle
    if (VehicleDamageMod < MinVehicleDamageModifier)
    {
        VehicleDamageMod = 0.0;
    }

    // Add in the DamageType's vehicle damage modifier & a little damage randomisation
    Damage *= RandRange(0.75, 1.08);
    PossibleDriverDamage = Damage; // saved in case we need to damage driver, as VehicleDamageMod isn't relevant to driver
    Damage *= VehicleDamageMod;

    // Check RO VehHitPoints (driver, engine, ammo)
    for (i = 0; i < VehHitpoints.Length; ++i)
    {
        // Series of checks to see if we hit the vehicle driver
        if (VehHitpoints[i].HitPointType == HP_Driver)
        {
            if (Driver != none && DriverPositions[DriverPositionIndex].bExposed && !bHitDriver)
            {
                // Lower-powered rounds have a limited HitCheckDistance, as they won't rip through the vehicle
                // For more powerful rounds, HitCheckDistance will remain default zero, meaning no limit on check distance in IsPointShot()
                if (VehicleDamageMod <= 0.25)
                {
                    HitCheckDistance = DriverHitCheckDist;
                }

                if (IsPointShot(HitLocation,Momentum, 1.0, i, HitCheckDistance))
                {
                    Driver.TakeDamage(PossibleDriverDamage, InstigatedBy, HitLocation, Momentum, DamageType);
                    bHitDriver = true; // stops any possibility of multiple damage to driver by same projectile if there's more than 1 driver hit point (e.g. head & torso)
                }
            }
        }
        else if (Damage > 0 && IsPointShot(HitLocation, Momentum, 1.0, i))
        {
            // Engine hit
            if (VehHitpoints[i].HitPointType == HP_Engine)
            {
                if (bDebuggingText)
                {
                    Level.Game.Broadcast(self, "Hit vehicle engine");
                }

                DamageEngine(Damage, InstigatedBy, HitLocation, Momentum, DamageType);
            }
            // Hit ammo store
            else if (VehHitpoints[i].HitPointType == HP_AmmoStore)
            {
                if (bDebuggingText)
                {
                    Level.Game.Broadcast(self, "Hit vehicle ammo store");
                }

                Damage *= VehHitpoints[i].DamageMultiplier;
                break;
            }
        }
    }

    // Call the Super from Vehicle (skip over others)
    super(Vehicle).TakeDamage(Damage, InstigatedBy, HitLocation, Momentum, DamageType);
}

// Modified so if we hit a vehicle we use its velocity to calculate damage, & also to factor in an ObjectCollisionResistance for this vehicle
event TakeImpactDamage(float AccelMag)
{
    local int Damage;

    if (Vehicle(ImpactInfo.Other) != none) // collided with another vehicle
    {
        Damage = Int(VSize(ImpactInfo.Other.Velocity) * 20.0 * ImpactDamageModifier());
        TakeDamage(Damage, Vehicle(ImpactInfo.Other), ImpactInfo.Pos, vect(0.0, 0.0, 0.0), class'DHVehicleCollisionDamageType');
    }
    else // collided with something else
    {
        Damage = Int(AccelMag * ImpactDamageModifier() / ObjectCollisionResistance);
        TakeDamage(Damage, self, ImpactInfo.Pos, vect(0.0, 0.0, 0.0), class'DHVehicleCollisionDamageType');
    }

    // Play bottom out sound (modified to not play across level, lowered volume, and limit sound occurrence to every second)
    if (ImpactDamageSounds.Length > 0 && Level.TimeSeconds - LastBottomOutTime > 1.0)
    {
        PlaySound(ImpactDamageSounds[Rand(ImpactDamageSounds.Length - 1)], SLOT_None, TransientSoundVolume * 2.5, false, 120,, true);
        LastBottomOutTime = Level.TimeSeconds;
    }

    if (Health < 0 && (Level.TimeSeconds - LastImpactExplosionTime) > TimeBetweenImpactExplosions)
    {
        VehicleExplosion(Normal(ImpactInfo.ImpactNorm), 0.5);
        LastImpactExplosionTime = Level.TimeSeconds;
    }
}

// Emptied out as blast damage to exposed vehicle occupants is now handled from HurtRadius() in the projectile class
function DriverRadiusDamage(float DamageAmount, float DamageRadius, Controller EventInstigator, class<DamageType> DamageType, float Momentum, vector HitLocation)
{
    return;
}

// Modified to randomise explosion damage (except for resupply vehicles) & to add DestroyedBurningSound
function VehicleExplosion(vector MomentumNormal, float PercentMomentum)
{
    local vector LinearImpulse, AngularImpulse;
    local float  RandomExplModifier;

    RandomExplModifier = FRand();

    if (ResupplyAttachment != none)
    {
        HurtRadius(ExplosionDamage, ExplosionRadius, ExplosionDamageType, ExplosionMomentum, Location);
    }
    else
    {
        HurtRadius(ExplosionDamage * RandomExplModifier, ExplosionRadius * RandomExplModifier, ExplosionDamageType, ExplosionMomentum, Location);
    }

    AmbientSound = DestroyedBurningSound;
    SoundVolume = 255.0;
    SoundRadius = 600.0;

    if (!bDisintegrateVehicle)
    {
        ExplosionCount++;

        if (Level.NetMode != NM_DedicatedServer)
        {
            ClientVehicleExplosion(false);
        }

        LinearImpulse = PercentMomentum * RandRange(DestructionLinearMomentum.Min, DestructionLinearMomentum.Max) * MomentumNormal;
        AngularImpulse = PercentMomentum * RandRange(DestructionAngularMomentum.Min, DestructionAngularMomentum.Max) * VRand();

        NetUpdateTime = Level.TimeSeconds - 1.0;
        KAddImpulse(LinearImpulse, vect(0.0, 0.0, 0.0));
        KAddAngularImpulse(AngularImpulse);
    }
}

// Modified to prevent an already blown up vehicle from triggering an explosion on a net client, if the vehicle becomes net relevant & replicates to that client
// If vehicle has previously exploded, ExplosionCount will be 1, & when that replicates in the initial batch of variables, it triggers native code to call this function
// In that situation we just want to spawn the DestructionEffect, skipping the explosion sound & view shake
simulated event ClientVehicleExplosion(bool bFinal)
{
    local PlayerController PC;
    local float            Dist, Scale;

    // On net client, only do these things if bClientInitialized, meaning we haven't just received this actor through replication, so it must have just blown up
    if (bClientInitialized || Role == ROLE_Authority)
    {
        // View shake
        if (Level.NetMode != NM_DedicatedServer)
        {
            PC = Level.GetLocalPlayerController();

            if (PC != none && PC.ViewTarget != none)
            {
                Dist = VSize(Location - PC.ViewTarget.Location);

                if (Dist < (ExplosionRadius * 2.5))
                {
                    if (Dist < ExplosionRadius)
                    {
                        Scale = 1.0;
                    }
                    else
                    {
                        Scale = ((ExplosionRadius * 2.5) - Dist) / ExplosionRadius;
                    }

                    PC.ShakeView(ShakeRotMag * Scale, ShakeRotRate, ShakeRotTime, ShakeOffsetMag * Scale, ShakeOffsetRate, ShakeOffsetTime);
                }
            }
        }

        // Explosion sound
        if (ExplosionSounds.Length > 0)
        {
            PlaySound(ExplosionSounds[Rand(ExplosionSounds.Length)], SLOT_None, ExplosionSoundVolume * TransientSoundVolume,, ExplosionSoundRadius);
        }
    }

    if (Level.NetMode != NM_DedicatedServer)
    {
        // Low detail explosion effects
        if (Level.bDropDetail || Level.DetailMode == DM_Low)
        {
            if (bFinal)
            {
                DestructionEffect = Spawn(DisintegrationEffectLowClass,,, Location, Rotation);
            }
            else
            {
                DestructionEffect = Spawn(DestructionEffectLowClass, self);
            }
        }
        // Standard explosion effects
        else
        {
            if (bFinal)
            {
                DestructionEffect = Spawn(DisintegrationEffectClass,,, Location, Rotation);
            }
            else
            {
                DestructionEffect = Spawn(DestructionEffectClass, self);
            }
        }

        DestructionEffect.LifeSpan = TimeTilDissapear;
        DestructionEffect.SetBase(self);
    }
}

// Modified to kill engine if zero health
function DamageEngine(int Damage, Pawn InstigatedBy, vector HitLocation, vector Momentum, class<DamageType> DamageType)
{
    // Apply new damage
    if (EngineHealth > 0)
    {
        Damage = Level.Game.ReduceDamage(Damage, self, InstigatedBy, HitLocation, Momentum, DamageType);
        EngineHealth -= Damage;
    }

    // Kill the engine if its health has now fallen to zero
    if (EngineHealth <= 0)
    {
        if (bDebuggingText)
        {
            Level.Game.Broadcast(self, "Engine is dead");
        }

        bEngineOff = true;
        SetEngine();
    }
}

///////////////////////////////////////////////////////////////////////////////////////
//  *************************  SETUP, UPDATE, CLEAN UP  ***************************  //
///////////////////////////////////////////////////////////////////////////////////////

// Modified to include Skins array (so no need to add manually in each subclass) & to add extra material properties & remove obsolete stuff
// Also removes all literal material references, so they aren't repeated again & again - instead they are pre-cached once in DarkestHourGame.PrecacheGameTextures()
static function StaticPrecache(LevelInfo L)
{
    local int i;

    for (i = 0; i < default.PassengerWeapons.Length; ++i)
    {
        if (default.PassengerWeapons[i].WeaponPawnClass != none)
        {
            default.PassengerWeapons[i].WeaponPawnClass.static.StaticPrecache(L);
        }
    }

    for (i = 0; i < default.Skins.Length; ++i)
    {
        if (default.Skins[i] != none)
        {
            L.AddPrecacheMaterial(default.Skins[i]);
        }
    }

    for (i = 0; i < default.DestroyedMeshSkins.Length; ++i)
    {
        if (default.DestroyedMeshSkins[i] != none)
        {
            L.AddPrecacheMaterial(default.DestroyedMeshSkins[i]);
        }
    }

    L.AddPrecacheMaterial(default.VehicleHudImage);
    L.AddPrecacheMaterial(default.MPHMeterMaterial);

    if (default.HighDetailOverlay != none)
    {
        L.AddPrecacheMaterial(default.HighDetailOverlay);
    }

    if (default.DestroyedVehicleMesh != none)
    {
        L.AddPrecacheStaticMesh(default.DestroyedVehicleMesh);
    }

    if (default.ResupplyDecoAttachmentClass != none && default.ResupplyDecoAttachmentClass.default.StaticMesh != none)
    {
        L.AddPrecacheStaticMesh(default.ResupplyDecoAttachmentClass.default.StaticMesh);
    }
}

// Modified to removes all literal material references, so they aren't repeated again & again - instead they are pre-cached once in DarkestHourGame.PrecacheGameTextures()
// Also to add extra material properties & remove obsolete stuff
simulated function UpdatePrecacheMaterials()
{
    local int i;

    super(Actor).UpdatePrecacheMaterials(); // pre-caches the Skins array

    for (i = 0; i < DestroyedMeshSkins.Length; ++i)
    {
        if (DestroyedMeshSkins[i] != none)
        {
            Level.AddPrecacheMaterial(DestroyedMeshSkins[i]);
        }
    }

    Level.AddPrecacheMaterial(VehicleHudImage);
    Level.AddPrecacheMaterial(MPHMeterMaterial);

    if (HighDetailOverlay != none)
    {
        Level.AddPrecacheMaterial(HighDetailOverlay);
    }

    if (DestroyedVehicleMesh != none)
    {
        Level.AddPrecacheStaticMesh(DestroyedVehicleMesh);
    }

    if (ResupplyDecoAttachmentClass != none && ResupplyDecoAttachmentClass.default.StaticMesh != none)
    {
        Level.AddPrecacheStaticMesh(ResupplyDecoAttachmentClass.default.StaticMesh);
    }
}

// New function to set correct initial position of player & vehicle on a net client, when this actor is replicated
simulated function SetPlayerPosition()
{
    local name VehicleAnim, PlayerAnim;
    local int  i;

    // Put vehicle & player in correct animation pose - if player not in initial position, we need to recreate the up/down anims that will have played to get there
    if (DriverPositionIndex != InitialPositionIndex)
    {
        if (DriverPositionIndex > InitialPositionIndex)
        {
            // Step down through each position until we find the 'most recent' transition up anim & player transition anim (or have reached the initial position)
            for (i = DriverPositionIndex; i > InitialPositionIndex && (VehicleAnim == ''|| PlayerAnim == ''); --i)
            {
                if (VehicleAnim == '' && DriverPositions[i - 1].TransitionUpAnim != '')
                {
                    VehicleAnim = DriverPositions[i - 1].TransitionUpAnim;
                }

                // DriverTransitionAnim only relevant if there is also one in the position below
                if (PlayerAnim == '' && DriverPositions[i].DriverTransitionAnim != '' && DriverPositions[i - 1].DriverTransitionAnim != '')
                {
                    PlayerAnim = DriverPositions[i].DriverTransitionAnim;
                }
            }
        }
        else
        {
            // Step up through each position until we find the 'most recent' transition down anim & player transition anim (or have reached the initial position)
            for (i = DriverPositionIndex; i < InitialPositionIndex && (VehicleAnim == ''|| PlayerAnim == ''); ++i)
            {
                if (VehicleAnim == '' && DriverPositions[i + 1].TransitionDownAnim != '')
                {
                    VehicleAnim = DriverPositions[i + 1].TransitionDownAnim;
                }

                // DriverTransitionAnim only relevant if there is also one in the position above
                if (PlayerAnim == '' && DriverPositions[i].DriverTransitionAnim != '' && DriverPositions[i + 1].DriverTransitionAnim != '')
                {
                    PlayerAnim = DriverPositions[i].DriverTransitionAnim;
                }
            }
        }

        // Play the animations but freeze them at the end of the anim, so they effectively become an idle anim
        // These transitions already happened - we're playing catch up after actor replication, to recreate the position the player & cannon are already in
        if (VehicleAnim != '' && HasAnim(VehicleAnim))
        {
            PlayAnim(VehicleAnim);
            SetAnimFrame(1.0);
        }

        if (PlayerAnim != '' && Driver != none && !bHideRemoteDriver && bDrawDriverinTP && Driver.HasAnim(PlayerAnim))
        {
            // When vehicle replicates to net client, StartDriving() event gets called on player pawn if vehicle has a driver
            // StartDriving() plays DriveAnim on the driver, which is for the usual initial driver position, but that would override our correct PlayerAnim here
            // So if player pawn hasn't already played DriveAnim, set a flag to stop it playing DriveAnim in StartDriving(), although only this 1st time
            if (DHPawn(Driver) != none && !DHPawn(Driver).bClientPlayedDriveAnim)
            {
                DHPawn(Driver).bClientSkipDriveAnim = true;
            }

            Driver.StopAnimating(true); // stops the player's looping DriveAnim, otherwise it can blend with the new anim
            Driver.PlayAnim(PlayerAnim);
            Driver.SetAnimFrame(1.0);
        }
    }
}

// Modified to avoid "accessed none" errors on rider pawns that don't always exist on net clients
function SetTeamNum(byte NewTeam)
{
    local byte OriginalTeam;
    local int  i;

    OriginalTeam = Team;
    PrevTeam = NewTeam;
    Team = NewTeam;

    if (NewTeam != OriginalTeam)
    {
        TeamChanged();
    }

    for (i = 0; i < WeaponPawns.length; ++i)
    {
        if (WeaponPawns[i] != none)
        {
            WeaponPawns[i].SetTeamNum(NewTeam);
        }
    }
}

// New function to update movement sound volumes, similar to a tracked vehicle updating its tread sounds
// Although here we optimise by incorporating MotionSoundVolume as a passed function argument instead of a separate instance variable
simulated function UpdateMovementSound(float MotionSoundVolume)
{
    if (EngineSoundAttach != none)
    {
        EngineSoundAttach.SoundVolume = MotionSoundVolume * 0.75;
    }

    if (InteriorRumbleSoundAttach != none)
    {
        InteriorRumbleSoundAttach.SoundVolume = MotionSoundVolume * 2.5;
    }
}

// Modified to destroy extra attachments & effects, & to add option to skin destroyed vehicle static mesh to match camo variant (avoiding need for multiple destroyed meshes)
simulated event DestroyAppearance()
{
    local int i;

    super.DestroyAppearance();

    Disable('Tick'); // otherwise Tick spams "accessed none" errors for Left/RightTreadPanner & it's inconvenient to check != none in Tick

    DestroyAttachments();

    if (Level.NetMode != NM_DedicatedServer && DestroyedMeshSkins.Length > 0)
    {
        for (i = 0; i < DestroyedMeshSkins.Length; ++i)
        {
            if (DestroyedMeshSkins[i] != none)
            {
                Skins[i] = DestroyedMeshSkins[i];
            }
        }
    }
}

// New function to destroy effects & attachments when the vehicle gets destroyed
simulated function DestroyAttachments()
{
    if (ResupplyAttachment != none && Role == ROLE_Authority)
    {
        ResupplyAttachment.Destroy();
    }

    if (Level.NetMode != NM_DedicatedServer)
    {
        if (EngineSoundAttach != none)
        {
            EngineSoundAttach.Destroy();
        }

        if (InteriorRumbleSoundAttach != none)
        {
            InteriorRumbleSoundAttach.Destroy();
        }

        if (ResupplyDecoAttachment != none)
        {
            ResupplyDecoAttachment.Destroy();
        }

        if (bEmittersOn)
        {
            StopEmitters();
        }
    }
}

///////////////////////////////////////////////////////////////////////////////////////
//  *******************************  MISCELLANEOUS ********************************  //
///////////////////////////////////////////////////////////////////////////////////////

// New function to handle switching between external & internal mesh (just saves code repetition)
simulated function SwitchMesh(int PositionIndex, optional bool bUpdateAnimations)
{
    local mesh NewMesh;

    if (Role == ROLE_AutonomousProxy || Level.NetMode == NM_Standalone || Level.NetMode == NM_ListenServer)
    {
        // If switching to a valid driver position, get its PositionMesh
        if (PositionIndex >= 0 && PositionIndex < DriverPositions.Length)
        {
            NewMesh = DriverPositions[PositionIndex].PositionMesh;
        }
        // Else switch to default external mesh (pass PositionIndex of -1 to signify this, as it's an invalid position)
        else
        {
            NewMesh = default.Mesh;
        }

        // Only switch mesh if we actually have a different new mesh
        if (NewMesh != Mesh && NewMesh != none)
        {
            LinkMesh(NewMesh);

            // Option to play any necessary animations to get the new mesh in the correct position, e.g. with switching to/from behind view
            if (bUpdateAnimations)
            {
                SetPlayerPosition();
            }
        }
    }
}

// Modified to include setting ResetTime for an empty vehicle away from its spawn (moved from DriverLeft)
function MaybeDestroyVehicle()
{
    if (!bNeverReset && IsVehicleEmpty())
    {
        if (IsDisabled())
        {
            bSpikedVehicle = true;
            SetTimer(VehicleSpikeTime, false);

            if (bDebuggingText)
            {
                Level.Game.Broadcast(self, "Initiating" @ VehicleSpikeTime @ "sec spike timer for disabled vehicle" @ Tag);
            }
        }

        // If vehicle is now empty & some way from its spawn point (> 83m or out of sight), set a time for CheckReset() to maybe re-spawn the vehicle after a certain period
        // Changed from VSize > 5000 to VSizeSquared > 25000000, as is more efficient processing & does same thing
        if (ParentFactory != none && (VSizeSquared(Location - ParentFactory.Location) > 25000000.0 || !FastTrace(ParentFactory.Location, Location)))
        {
            ResetTime = Level.TimeSeconds + IdleTimeBeforeReset;
        }
    }
}

// Modified to use DriverTraceDistSquared instead of literal values (& add debug)
event CheckReset()
{
    local Pawn P;

    if (bIsSpawnVehicle)
    {
        return;
    }

    // Vehicle occupied, so reset ResetTime
    if (!IsVehicleEmpty())
    {
        ResetTime = Level.TimeSeconds + IdleTimeBeforeReset;

        return;
    }
    // Vehicle empty & is a bKeyVehicle, so destroy it now to make it respawn
    else if (bKeyVehicle)
    {
        Died(none, class'DamageType', Location);

        return;
    }

    // Check for friendlies nearby
    foreach CollidingActors(class'Pawn', P, FriendlyResetDistance)
    {
        if (P != self && P.Controller != none && P.GetTeamNum() == GetTeamNum()) // traces only work on friendly players nearby
        {
            if (ROPawn(P) != none && (VSizeSquared(P.Location - Location) < DriverTraceDistSquared)) // Matt: changed so compare squared values, as VSizeSquared is more efficient
            {
                if (bDebuggingText)
                {
                    Level.Game.Broadcast(self, Tag @ "is empty vehicle, but set new ResetTime as found friendly player nearby");
                }

                ResetTime = Level.TimeSeconds + IdleTimeBeforeReset;

                return;
            }
            else if (FastTrace(P.Location + P.CollisionHeight * vect(0.0, 0.0, 1.0), Location + CollisionHeight * vect(0.0, 0.0, 1.0)))
            {
                if (bDebuggingText)
                {
                    Level.Game.Broadcast(self, Tag @ "is empty vehicle, but set new ResetTime as found friendly pawn nearby");
                }

                ResetTime = Level.TimeSeconds + IdleTimeBeforeReset;

                return;
            }
        }
    }

    // If factory is active, we want it to spawn new vehicle NOW
    if (ParentFactory != none)
    {
        if (bDebuggingText)
        {
            Level.Game.Broadcast(self, Tag @ "is empty vehicle & re-spawned as no friendly player nearby");
        }

        ParentFactory.VehicleDestroyed(self);
        ParentFactory.Timer();
        ParentFactory = none; // so doesn't call ParentFactory.VehicleDestroyed() again in Destroyed()
    }

    Destroy();
}

// Modified to add an impact effect for running someone over (will slow vehicle down)
function bool EncroachingOn(Actor Other)
{
    // If its a player pawn, do lots of damage & call ObjectCrushed()
    if (Pawn(Other) != none && Vehicle(Other) == none && Other != Instigator && Other.Role == ROLE_Authority && (Other.bCollideActors || Other.bBlockActors) && VSizeSquared(Velocity) >= 100.0)
    {
        Other.TakeDamage(10000, Instigator, Other.Location, Velocity * Other.Mass, CrushedDamageType);
        ObjectCrushed(4.0);
    }

    return false;
}

// Informs Tick() that we crushed an object and it should apply brake & affect server throttle
simulated function ObjectCrushed(float ReductionTime)
{
    ObjectCrushStallTime = ReductionTime;
    LastCrushedTime = Level.TimeSeconds;
    bCrushedAnObject = true;
}

// Modified to prevent "enter vehicle" screen messages if vehicle is destroyed & to pass new NotifyParameters to message, allowing it to display both the use/enter key & vehicle name
simulated event NotifySelected(Pawn User)
{
    if (Level.NetMode != NM_DedicatedServer && User != none && User.IsHumanControlled() && ((Level.TimeSeconds - LastNotifyTime) >= TouchMessageClass.default.LifeTime) && Health > 0)
    {
        NotifyParameters.Insert("Controller", User.Controller);
        User.ReceiveLocalizedMessage(TouchMessageClass, 0,,, NotifyParameters);
        LastNotifyTime = Level.TimeSeconds;
    }
}

// Modified to eliminate "Waiting for additional crew members" message (Matt: now only used by bots)
function bool CheckForCrew()
{
    return true;
}

// Modified to avoid "accessed none" errors
function bool IsVehicleEmpty()
{
    local int i;

    if (Driver != none)
    {
        return false;
    }

    for (i = 0; i < WeaponPawns.Length; ++i)
    {
        if (WeaponPawns[i] != none && WeaponPawns[i].Driver != none)
        {
            return false;
        }
    }

    return true;
}

// Modified to add WeaponPawns != none check to avoid "accessed none" errors, now rider pawns won't exist on client unless occupied
simulated function int NumPassengers()
{
    local int i, Num;

    if (Driver != none)
    {
        Num = 1;
    }

    for (i = 0; i < WeaponPawns.Length; ++i)
    {
        if (WeaponPawns[i] != none && WeaponPawns[i].Driver != none)
        {
            ++Num;
        }
    }

    return Num;
}

// Matt: added as when player is in a vehicle, the HUD keybinds to GrowHUD & ShrinkHUD will now call these same named functions in the vehicle classes
// When player is in a vehicle, these functions do nothing to the HUD, but they can be used to add useful vehicle functionality in subclasses, especially as keys are -/+ by default
simulated function GrowHUD();
simulated function ShrinkHUD();

///////////////////////////////////////////////////////////////////////////////////////
//  ****************************** EXEC FUNCTIONS  ********************************  //
///////////////////////////////////////////////////////////////////////////////////////

// New exec function to toggle between external & internal meshes (mostly useful with behind view if want to see internal mesh)
exec function ToggleMesh()
{
    local int i;

    if ((Level.NetMode == NM_Standalone || class'DH_LevelInfo'.static.DHDebugMode()) && DriverPositions.Length > 0)
    {
        if (Mesh == default.DriverPositions[DriverPositionIndex].PositionMesh)
        {
            for (i = 0; i < DriverPositions.Length; ++i)
            {
                DriverPositions[i].PositionMesh = default.Mesh;
            }
        }
        else
        {
            for (i = 0; i < DriverPositions.Length; ++i)
            {
                DriverPositions[i].PositionMesh = default.DriverPositions[i].PositionMesh;
            }
        }

        SwitchMesh(DriverPositionIndex, true);
    }
}

// Modified to work with DHDebugMode & restricted to changing view limits & nothing to do with behind view (which is handled by exec functions BehindView & ToggleBehindView)
exec function ToggleViewLimit()
{
    if (Level.NetMode == NM_Standalone || class'DH_LevelInfo'.static.DHDebugMode()) // removed requirement to be in single player mode, as valid in multi-player if in DHDebugMode
    {
        if (bLimitYaw == default.bLimitYaw && bLimitPitch == default.bLimitPitch)
        {
            bLimitYaw = false;
            bLimitPitch = false;
        }
        else
        {
            bLimitYaw = true;
            bLimitPitch = true;
        }
    }
}

// New exec function that allows debugging exit positions to be toggled for all DHWheeledVehicles
exec function ToggleDebugExits()
{
    if (Level.NetMode == NM_Standalone || class'DH_LevelInfo'.static.DHDebugMode())
    {
        ServerToggleDebugExits();
    }
}

function ServerToggleDebugExits()
{
    if (Level.NetMode == NM_Standalone || class'DH_LevelInfo'.static.DHDebugMode())
    {
        class'DHWheeledVehicle'.default.bDebugExitPositions = !class'DHWheeledVehicle'.default.bDebugExitPositions;
        Log("DHWheeledVehicle.bDebugExitPositions =" @ class'DHWheeledVehicle'.default.bDebugExitPositions);
    }
}

// New function to debug location of exit positions for the vehicle, which are drawn as different coloured cylinders
exec function DrawExits()
{
    local vector ExitPosition, ZOffset, X, Y, Z;
    local color  C;
    local int    i;

    if (Level.NetMode == NM_Standalone || class'DH_LevelInfo'.static.DHDebugMode())
    {
        bDrawExitPositions = !bDrawExitPositions;
        ClearStayingDebugLines();

        if (bDrawExitPositions)
        {
            ZOffset = class'DHPawn'.default.CollisionHeight * vect(0.0, 0.0, 0.5);
            GetAxes(Rotation, X, Y, Z);

            for (i = ExitPositions.Length - 1; i >= 0; --i)
            {
                if (i == 0)
                {
                    C = class'HUD'.default.BlueColor; // driver
                }
                else
                {
                    if (i - 1 < WeaponPawns.Length)
                    {
                        if (ROTankCannonPawn(WeaponPawns[i - 1]) != none)
                        {
                            C = class'HUD'.default.RedColor; // commander
                        }
                        else if (ROMountedTankMGPawn(WeaponPawns[i - 1]) != none)
                        {
                            C = class'HUD'.default.GoldColor; // machine gunner
                        }
                        else
                        {
                            C = class'HUD'.default.WhiteColor; // rider
                        }
                    }
                    else
                    {
                        C = class'HUD'.default.GrayColor; // something outside of WeaponPawns array, so not representing a particular vehicle position
                    }
                }

                ExitPosition = Location + (ExitPositions[i] >> Rotation) + ZOffset;
                class'DHLib'.static.DrawStayingDebugCylinder(self, ExitPosition, X, Y, Z, class'DHPawn'.default.CollisionRadius, class'DHPawn'.default.CollisionHeight, 10, C.R, C.G, C.B);
            }
        }
    }
}

// New debugging exec function to set ExitPositions (use it in single player; it's too much hassle on a server)
exec function SetExitPos(int Index, int NewX, int NewY, int NewZ)
{
    if (Role == ROLE_Authority && (Level.NetMode == NM_Standalone || class'DH_LevelInfo'.static.DHDebugMode()) && Index >= 0 && Index < ExitPositions.Length)
    {
        ExitPositions[Index].X = NewX;
        ExitPositions[Index].Y = NewY;
        ExitPositions[Index].Z = NewZ;
        Log(VehicleNameString @ "new ExitPositions[" $ Index $ "] =" @ ExitPositions[Index]);
    }
}

// Handy new execs during development for testing engine damage
function exec KillEngine()
{
    if ((Level.NetMode == NM_Standalone || class'DH_LevelInfo'.static.DHDebugMode()) && EngineHealth > 0)
    {
        ServerKillEngine();
    }
}

function ServerKillEngine()
{
    DamageEngine(EngineHealth, none, vect(0.0, 0.0, 0.0), vect(0.0, 0.0, 0.0), none);
}

defaultproperties
{
    PointValue=1.0
    PlayerCameraBone="Camera_driver"
    bEngineOff=true
    bSavedEngineOff=true
    IgnitionSwitchInterval=4.0
    EngineHealth=30
    HealthMax=175.0
    Health=175
    DamagedEffectHealthSmokeFactor=0.75
    DamagedEffectHealthMediumSmokeFactor=0.5
    DamagedEffectHealthHeavySmokeFactor=0.25
    DamagedEffectHealthFireFactor=0.15
    DestructionEffectClass=class'AHZ_ROVehicles.ATCannonDestroyedEmitter'
    DisintegrationEffectClass=class'ROEffects.ROVehicleDestroyedEmitter'
    DisintegrationEffectLowClass=class'ROEffects.ROVehicleDestroyedEmitter_simple'
    ExplosionDamage=325.0
    ExplosionRadius=700.0
    ExplosionSoundRadius=1000.0
    VehicleBurningSound=sound'Amb_Destruction.Fire.Krasnyi_Fire_House02'
    DestroyedBurningSound=sound'Amb_Destruction.Fire.Kessel_Fire_Small_Barrel'
    DamagedStartUpSound=sound'DH_AlliedVehicleSounds2.Damaged.engine_start_damaged'
    VehicleSpikeTime=30.0
    IdleTimeBeforeReset=90.0
    FriendlyResetDistance=4000.0
    DriverTraceDistSquared=20250000.0 // increased from 4500 as made variable into a squared value (VSizeSquared is more efficient than VSize)
    ObjectCrushStallTime=1.0
    ObjectCollisionResistance=1.0
    SparkEffectClass=none // removes the odd spark effects when vehicle drags bottom
    ImpactDamageTicks=2.0
    ImpactDamageThreshold=20.0
    ImpactDamageMult=0.5
    TouchMessageClass=class'DHVehicleTouchMessage'
    ObjectiveGetOutDist=1500.0
    VehHitpoints(0)=(PointRadius=25.0,PointBone="Engine",bPenetrationPoint=false,DamageMultiplier=1.0,HitPointType=HP_Engine) // no.0 becomes engine instead of driver
    VehHitpoints(1)=(PointRadius=0.0,PointScale=0.0,PointBone="",HitPointType=) // no.1 is no longer engine (neutralised by default, or overridden as required in subclass)

    // These variables are effectively deprecated & should not be used - they are either ignored or values below are assumed & hard coded into functionality:
    bPCRelativeFPRotation=true
    bFPNoZFromCameraPitch=false
    FPCamViewOffset=(X=0.0,Y=0.0,Z=0.0)
    bDesiredBehindView=false
    bDisableThrottle=false
    bKeepDriverAuxCollision=true // Matt: necessary for new player hit detection system, which basically uses normal hit detection as for an infantry player pawn
}
