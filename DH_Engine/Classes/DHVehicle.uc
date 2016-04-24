//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DHVehicle extends ROWheeledVehicle
    abstract;

#exec OBJ LOAD FILE=..\Textures\DH_InterfaceArt_tex.utx

// Structs
struct PassengerPawn
{
    var name    AttachBone;
    var vector  DrivePos;
    var rotator DriveRot;
    var name    DriveAnim;
    var vector  FPCamPos;
};

struct VehicleAttachment
{
    var class<Actor> AttachClass;
    var Actor        Actor;
    var StaticMesh   StaticMesh;
    var name         AttachBone;
    var vector       Offset;
    var material     Skin;
    var bool         bHasCollision;
};

struct RandomAttachOption
{
    var StaticMesh  StaticMesh; // a possible random decorative attachment mesh
    var byte        PercentChance;    // the % chance of this attachment being the one spawned
};

// General
var DHVehicleCannon Cannon;                      // reference to the vehicle's cannon weapon
var DHVehicleMG     MGun;                        // reference to the vehicle's mounted MG weapon
var array<material> CannonSkins;                 // option to specify cannon's camo skins in vehicle class, avoiding need for separate cannon pawn & cannon classes just for different camo
var     array<PassengerPawn> PassengerPawns;     // array with properties usually specified in separate passenger pawn classes, just to avoid need for lots of classes
var     byte        FirstRiderPositionIndex;     // used by passenger pawn to find its position in PassengerPawns array
var     bool        bIsSpawnVehicle;             // set by DHSpawnManager & used here for engine on/off hints
var     float       PointValue;                  // used for scoring
var     float       SpikeTime;                   // time (seconds) before an empty, disabled vehicle will be automatically blown up
var     float       FriendlyResetDistance;       // used in CheckReset() as maximum range to check for friendly pawns, to avoid re-spawning vehicle
var     float       DriverTraceDistSquared;      // used in CheckReset() as range check on any friendly player pawn found (ignoring line of sight check)
var     TreeMap_string_Object   NotifyParameters;            // an object that can hold references to several other objects, which can be used by messages to build a tailored message
var     bool        bClientInitialized;          // clientside flag that replicated actor has completed initialization (set at end of PostNetBeginPlay)
                                                 // (allows client code to determine whether actor is just being received through replication, e.g. in PostNetReceive)
// Driver & driving
var     bool        bNeedToInitializeDriver;     // clientside flag that we need to do some driver set up, once we receive the Driver actor
var     float       MaxCriticalSpeed;            // if vehicle goes over max speed, it forces player to pull back on throttle
var     name        PlayerCameraBone;            // just to avoid using literal references to 'Camera_driver' bone & allow extra flexibility
var     float       ViewTransitionDuration;      // used to control the time we stay in state ViewTransition
var     bool        bLockCameraDuringTransition; // lock the camera's rotation to the camera bone during view transitions

// Damage
var     float       FrontLeftAngle, FrontRightAngle, RearRightAngle, RearLeftAngle; // used by the hit detection system to determine which side of the vehicle was hit
var     float       HeavyEngineDamageThreshold;  // proportion of remaining engine health below which the engine is so badly damaged it limits speed
var array<material> DestroyedMeshSkins;          // option to skin destroyed vehicle static mesh to match camo variant (avoiding need for multiple destroyed meshes)
var     sound       DamagedStartUpSound;         // sound played when trying to start a damaged engine
var     sound       DamagedShutDownSound;        // sound played when damaged engine shuts down
var     sound       VehicleBurningSound;         // ambient sound when vehicle's engine is burning
var     sound       DestroyedBurningSound;       // ambient sound when vehicle is destroyed and burning

// Engine
var     bool        bEngineOff;                  // vehicle engine is simply switched off
var     bool        bSavedEngineOff;             // clientside record of current value, so PostNetReceive can tell if a new value has been replicated
var     float       IgnitionSwitchTime;          // records last time the engine was switched on/off - requires interval to stop people spamming the ignition switch
var     float       IgnitionSwitchInterval;      // how frequently the engine can be manually switched on/off

// Driving effects
var     bool        bEmittersOn;                 // dust & exhaust effects are enabled
var     float       MaxPitchSpeed;               // used to set movement sounds volume, based on vehicle's speed
var     sound       RumbleSound;                 // interior rumble sound
var     name        RumbleSoundBone;             // attachment bone for rumble sound attachment
var     Actor       RumbleSoundAttach;           // reference to rumble sound attachment actor
var     float       RumbleSoundVolumeModifier;   // allows adjustment of interior rumble sound volume
var     sound       EngineSound;                 // engine sound - rarely used as sound is already played using IdleSound, with its pitch related to speed by native code,
var     name        EngineSoundBone;             // but EngineSound is overlaid on IdleSound, so can give greater depth of sound & serves some purpose, although not much
var     Actor       EngineSoundAttach;
var     float       LastImpactSound;             // last time an impact damage sound was played (used to limit constant sounds as vehicle 'bottoms out' on ground)

// Treads & track wheels
var     bool                bHasTreads;
var     int                 LeftTreadIndex, RightTreadIndex;   // index position of treads in Skins array
var     VariableTexPanner   LeftTreadPanner, RightTreadPanner; // texture panners used to make it look like the treads are moving
var     float               TreadVelocityScale;                // allows adjustment of treads rotation speed for each vehicle
var     rotator             LeftTreadPanDirection, RightTreadPanDirection; // make sure the treads move the correct way!
var     sound               LeftTreadSound, RightTreadSound;               // tread movement sound
var     name                LeftTrackSoundBone, RightTrackSoundBone;       // attachment bone names for tread sound attachments
var     Actor               LeftTreadSoundAttach, RightTreadSoundAttach;   // references to sound attachments used to make tread sounds
var     array<name>         LeftWheelBones, RightWheelBones; // bone names for the track wheels on each side, used to animate wheels (visual only, no driving effect)
var     rotator             LeftWheelRot, RightWheelRot;     // keep track of the wheel rotational speed for animation
var     int                 WheelRotationScale;              // allows adjustment of wheel rotation speed for each vehicle

// Damaged treads
var     float               TreadHitMaxHeight;     // height (in Unreal units) of the top of treads above hull mesh origin, used to detect tread hits (see notes in TakeDamage)
var     float               TreadHitMinAngle;      // old, buggy system before TreadHitMaxHeight, where hit angle (radians) determined tread hits - to be deprecated in time
var     float               TreadDamageThreshold;  // minimum TreadDamageModifier in DamageType to possibly break treads
var     bool                bLeftTrackDamaged;     // the left track has been damaged
var     bool                bRightTrackDamaged;    // the left track has been damaged
var     sound               TrackDamagedSound;     // alternative tread sound to play when a track is damaged
var     material            DamagedTreadPanner;    // replacement skin used for a damaged tread
var     StaticMesh          DamagedTrackStaticMeshLeft, DamagedTrackStaticMeshRight; // static meshes to use for damaged left & right tracks
var     name                DamagedTrackAttachBone; // bone name for attaching damaged tracks
var     Actor               DamagedTrackLeft, DamagedTrackRight; // static mesh attachment to show damaged track, e.g. broken track links (clientside only)

// Vehicle HUD icon
var     TexRotator          VehicleHudTurret;        // rotating icon representing the vehicle's cannon
var     TexRotator          VehicleHudTurretLook;
var     float               VehicleHudTreadsPosX[2]; // 0.0 to 1.0 X positioning of tread damage indicators (index 0 = left, 1 = right)
var     float               VehicleHudTreadsPosY;    // 0.0 to 1.0 Y positioning of tread damage indicators
var     float               VehicleHudTreadsScale;   // drawing scale of tread damage indicators

// Vehicle attachments
var     array<VehicleAttachment>  VehicleAttachments;      // vehicle attachments, generally decorative, that won't be spawned on a server
var     array<VehicleAttachment>  CollisionAttachments;    // collision mesh attachments for a moving part of vehicle that should have collision, e.g. a ramp or driver's armoured visor
var     VehicleAttachment         RandomAttachment;        // option for a visual attachment with a random selection of static mesh type, e.g. schurzen with different stages of damage
var     array<RandomAttachOption> RandomAttachOptions;     // possible static meshes to use with the random decorative attachment
var     byte                      RandomAttachmentIndex;   // the attachment index number selected randomly to be spawned for this vehicle
var     class<Actor>              ResupplyAttachmentClass; // option for a functioning (not decorative) resupply actor attachment
var     name                      ResupplyAttachBone;      // bone name for attaching resupply attachment
var     Actor                     ResupplyAttachment;      // reference to any resupply actor

// Debugging
var     bool        bDebuggingText;
var     bool        bDebugExitPositions;
var     bool        bDebugTreadText;

replication
{
    // Variables the server will replicate to all clients
    reliable if (bNetDirty && Role == ROLE_Authority)
        bEngineOff, bIsSpawnVehicle, bRightTrackDamaged, bLeftTrackDamaged;

    // Variables the server will replicate to clients when this actor is 1st replicated
    reliable if (bNetInitial && bNetDirty && Role == ROLE_Authority)
        RandomAttachmentIndex;

    // Functions a client can call on the server
    reliable if (Role < ROLE_Authority)
        ServerStartEngine,
        ServerToggleDebugExits, ServerDamTrack, ServerKillEngine; // these ones in debug mode only
}

///////////////////////////////////////////////////////////////////////////////////////
//  ********************** ACTOR INITIALISATION & DESTRUCTION  ********************  //
///////////////////////////////////////////////////////////////////////////////////////

// Modified to create passenger pawn classes from PassengerWeapons array, to make net clients show empty rider positions on HUD vehicle icon,
// to match position indexes to initial position, to set bDriverAlreadyEntered in single player, to avoid setting initial timer RO's 'waiting for crew' system is deprecated,
// and to set up new NotifyParameters object (including this vehicle class, which gets passed to screen messages & allows them to display vehicle name
simulated function PostBeginPlay()
{
    local byte StartIndex, Index, i;

    super(Vehicle).PostBeginPlay(); // skip over Super in ROWheeledVehicle to avoid setting an initial timer, which we no longer use

    // Play neutral idle animation
    if (HasAnim(BeginningIdleAnim))
    {
        PlayAnim(BeginningIdleAnim);
    }

    // Create passenger pawn classes from the PassengerWeapons array
    if (PassengerPawns.Length > 0)
    {
        if (FirstRiderPositionIndex == 255)
        {
            FirstRiderPositionIndex = PassengerWeapons.Length; // set automatically, unless has been set specifically
        }

        StartIndex = PassengerWeapons.Length;
        PassengerWeapons.Length = PassengerWeapons.Length + PassengerPawns.Length;

        for (i = 0; i < PassengerPawns.Length; ++i)
        {
            Index = StartIndex + i;
            PassengerWeapons[Index].WeaponPawnClass = class'DHPassengerPawn'.default.PassengerClasses[Index];
            PassengerWeapons[Index].WeaponBone = PassengerPawns[i].AttachBone;
        }
    }

    if (Role == ROLE_Authority)
    {
        // If InitialPositionIndex is not zero, match position indexes now so when a player gets in, we don't trigger an up transition by changing DriverPositionIndex
        if (InitialPositionIndex > 0)
        {
            DriverPositionIndex = InitialPositionIndex;
            PreviousPositionIndex = InitialPositionIndex;
        }

        // For single player mode, we may as well set this here, as it's only intended to stop idiot net players blowing up friendly vehicles in spawn
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
        // Set up new NotifyParameters object
        NotifyParameters = new class'TreeMap_string_Object';
        NotifyParameters.Put("VehicleClass", Class);
    }
}

// Modified to initialize engine-related properties, & also on a net client to flag if bNeedToInitializeDriver, to match clientside position indexes to replicated DriverPositionIndex,
// to flag bClientInitialized, & to skip lots of pointless stuff if an already destroyed vehicle gets replicated
simulated function PostNetBeginPlay()
{
    super.PostNetBeginPlay();

    // Net client initialisation, based on replicated info about driving status/position
    if (Role < ROLE_Authority)
    {
        bSavedEngineOff = bEngineOff;
        bClientInitialized = true;

        // If an already destroyed vehicle gets replicated, there's nothing more we want to do here; it will only turn the engine on & set irrelevant variables
        if (Health <= 0)
        {
            return;
        }

        if (bDriving)
        {
            bNeedToInitializeDriver = true;
        }

        SavedPositionIndex = DriverPositionIndex;
        PreviousPositionIndex = DriverPositionIndex;
        PendingPositionIndex = DriverPositionIndex;
    }

    // Set up the engine (all modes)
    SetEngine();

    // Spawn a variety of vehicle attachment options
    SpawnVehicleAttachments();
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

// Matt: modified to handle engine on/off (including dust/exhaust emitters), damaged tracks & fire effects, instead of constantly checking in Tick
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

    // One of the tracks has been damaged (uses DamagedTreadPanner as an effective flag that net client hasn't already done this)
    if (((bLeftTrackDamaged && Skins.Length > LeftTreadIndex && Skins[LeftTreadIndex] != DamagedTreadPanner) ||
        (bRightTrackDamaged && Skins.Length > LeftTreadIndex && Skins[RightTreadIndex] != DamagedTreadPanner)) && Health > 0)
    {
        SetDamagedTracks();
    }

    // Initialize the driver
    if (bNeedToInitializeDriver && Driver != none)
    {
        bNeedToInitializeDriver = false;
        SetPlayerPosition();
    }
}

// Modified to handle treads (including damaged treads), engine & interior rumble sounds, & MaxCriticalSpeed,
// to prevent all movement if vehicle can't move (engine off or both tracks disabled), & to disable Tick if vehicle is stationary & has no driver
// Also to remove (from deprecated ROTreadCraft version) RO disabled throttle stuff & modifying value of WheelLatFrictionScale based on speed (did nothing)
simulated function Tick(float DeltaTime)
{
    local KRigidBodyState BodyState;
    local float           VehicleSpeed, MotionSoundVolume, LinTurnSpeed;
    local int             i;

    // Stop all movement if engine off or both tracks damaged
    if (bEngineOff || (bLeftTrackDamaged && bRightTrackDamaged))
    {
        Velocity = vect(0.0, 0.0, 0.0);
        Throttle = 0.0;
        ThrottleAmount = 0.0;
        Steering = 0.0;
        ForwardVel = 0.0;
    }
    else if (Controller != none)
    {
        // Damaged treads mean vehicle can only turn one way & speed is limited
        if (bLeftTrackDamaged)
        {
            Throttle = FClamp(Throttle, -0.5, 0.5);

            if (IsHumanControlled())
            {
                PlayerController(Controller).aStrafe = -32768.0;
            }
            else
            {
                Steering = 1.0;
            }
        }
        else if (bRightTrackDamaged)
        {
            Throttle = FClamp(Throttle, -0.5, 0.5);

            if (IsHumanControlled())
            {
                PlayerController(Controller).aStrafe = 32768.0;
            }
            else
            {
                Steering = -1.0;
            }
        }
        // Heavy damage to engine limits speed
        else if (EngineHealth <= (default.EngineHealth * HeavyEngineDamageThreshold))
        {
            Throttle = FClamp(Throttle, -0.5, 0.5);
        }
    }

    if (Level.NetMode != NM_DedicatedServer)
    {
        VehicleSpeed = Abs(ForwardVel); // don't need VSize(Velocity), as already have ForwardVel

        // Vehicle is moving
        if (VehicleSpeed > 0.1)
        {
            // Force player to pull back on throttle if over max speed
            if (VehicleSpeed >= MaxCriticalSpeed && MaxCriticalSpeed > 0.0 && IsHumanControlled())
            {
                PlayerController(Controller).aForward = -32768.0;
            }

            // Update tread, interior rumble & engine sound volumes, based on speed
            MotionSoundVolume = FClamp(VehicleSpeed / MaxPitchSpeed * 255.0, 0.0, 255.0);
            UpdateMovementSound(MotionSoundVolume);

            // Update tread & wheel movement, based on speed
            if (bHasTreads)
            {
                KGetRigidBodyState(BodyState);
                LinTurnSpeed = 0.5 * BodyState.AngVel.Z;

                if (LeftTreadPanner != none)
                {
                    LeftTreadPanner.PanRate = (ForwardVel / TreadVelocityScale) + LinTurnSpeed;
                    LeftWheelRot.Pitch += LeftTreadPanner.PanRate * WheelRotationScale;

                    for (i = 0; i < LeftWheelBones.Length; ++i)
                    {
                        SetBoneRotation(LeftWheelBones[i], LeftWheelRot);
                    }
                }

                if (RightTreadPanner != none)
                {
                    RightTreadPanner.PanRate = (ForwardVel / TreadVelocityScale) - LinTurnSpeed;
                    RightWheelRot.Pitch += RightTreadPanner.PanRate * WheelRotationScale;

                    for (i = 0; i < RightWheelBones.Length; ++i)
                    {
                        SetBoneRotation(RightWheelBones[i], RightWheelRot);
                    }
                }
            }
        }
        // If vehicle isn't moving, zero the movement sounds & tread movement
        else
        {
            UpdateMovementSound(0.0);

            if (LeftTreadPanner != none)
            {
                LeftTreadPanner.PanRate = 0.0;
            }

            if (RightTreadPanner != none)
            {
                RightTreadPanner.PanRate = 0.0;
            }
        }
    }

    super.Tick(DeltaTime);

    // Disable Tick if vehicle isn't moving & has no driver
    if (!bDriving && ForwardVel ~= 0.0)
    {
        Disable('Tick');
    }
}

// Modified to remove RO stuff about bDriverAlreadyEntered, bDisableThrottle & CheckForCrew, as DH doesn't wait for crew anyway - so just set bDriverAlreadyEntered in KDriverEnter()
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

// Modified to fix bug where any HUDOverlay would be destroyed if function called before net client received Controller reference through replication
// Also to remove irrelevant stuff about driver weapon crosshair & to optimise a little
// Includes omitting calling DrawVehicle (as is just a 1 liner that can be optimised) & DrawPassengers (as is just an empty function)
simulated function DrawHUD(Canvas C)
{
    local PlayerController PC;

    PC = PlayerController(Controller);

    if (PC != none && !PC.bBehindView)
    {
        // Player is in a position where a HUDOverlay should be drawn
        if (DriverPositions[DriverPositionIndex].bDrawOverlays && (!IsInState('ViewTransition') || DriverPositions[PreviousPositionIndex].bDrawOverlays)
            && HUDOverlay != none && !Level.IsSoftwareRendering())
        {
            HUDOverlay.SetLocation(PC.CalcViewLocation + (HUDOverlayOffset >> PC.CalcViewRotation));
            HUDOverlay.SetRotation(PC.CalcViewRotation);
            C.DrawActor(HUDOverlay, false, true, FClamp(HUDOverlayFOV * (PC.DesiredFOV / PC.DefaultFOV), 1.0, 170.0));
        }

        // Draw vehicle, turret, ammo count, passenger list
        if (ROHud(PC.myHUD) != none)
        {
            ROHud(PC.myHUD).DrawVehicleIcon(C, self);
        }
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

// Modified to simplify by removing the check on player distance vs EntryRadius & the ClosestWeaponPawn stuff (it really doesn't matter which is closest)
// If player is close enough to see the 'enter vehicle' message, he should always be able to enter, otherwise it's confusing & contradictory
function Vehicle FindEntryVehicle(Pawn P)
{
    local VehicleWeaponPawn WP;
    local Vehicle           VehicleGoal;
    local bool              bPlayerIsTankCrew;
    local int               i;

    if (P != none && P.IsHumanControlled())
    {
        // Record whether player is allowed to use tanks
        bPlayerIsTankCrew = ROPlayerReplicationInfo(P.Controller.PlayerReplicationInfo) != none
            && ROPlayerReplicationInfo(P.Controller.PlayerReplicationInfo).RoleInfo != none
            && ROPlayerReplicationInfo(P.Controller.PlayerReplicationInfo).RoleInfo.bCanBeTankCrew;

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

    // Otherwise it must be a bot entering, & bots know what they want
    VehicleGoal = Vehicle(P.Controller.RouteGoal);

    if (VehicleGoal == self)
    {
        if (Driver == none)
        {
            return self;
        }
    }
    else if (VehicleGoal != none)
    {
        for (i = 0; i < WeaponPawns.Length; ++i)
        {
            WP = WeaponPawns[i];

            if (VehicleGoal == WP)
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
    }

    return none;
}

// Modified to prevent entry if player is on fire
function bool TryToDrive(Pawn P)
{
    local bool bCantEnterEnemyVehicle;
    local int  i;

    // Deny entry if vehicle has driver or is dead, or if player is crouching or on fire or reloading a weapon (plus several very obscure other reasons)
    if (Driver != none || Health <= 0 || P == none || (DHPawn(P) != none && DHPawn(P).bOnFire) || (P.Weapon != none && P.Weapon.IsInState('Reloading')) ||
        P.Controller == none || !P.Controller.bIsPlayer || P.DrivenVehicle != none || P.IsA('Vehicle') || bNonHumanControl || !Level.Game.CanEnterVehicle(self, P))
    {
        return false;
    }

    if (bDebuggingText)
    {
        P.ClientMessage("Vehicle Health:" @ Health $ ", EngineHealth:" @ EngineHealth);
    }

    // Trying to enter a vehicle that isn't on our team
    if (P.GetTeamNum() != VehicleTeam)
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
            DisplayVehicleMessage(1, P); // can't use enemy vehicle

            return false;
        }
    }

    // If vehicle can only be used by tank crew & player is not a tanker role, check if there are any available rider positions before denying entry
    if (bMustBeTankCommander && !(ROPlayerReplicationInfo(P.Controller.PlayerReplicationInfo) != none && ROPlayerReplicationInfo(P.Controller.PlayerReplicationInfo).RoleInfo != none
        && ROPlayerReplicationInfo(P.Controller.PlayerReplicationInfo).RoleInfo.bCanBeTankCrew) && P.IsHumanControlled())
    {
        // Check first that this vehicle has rider position(s)
        if (FirstRiderPositionIndex >= WeaponPawns.Length)
        {
            DisplayVehicleMessage(3, P); // can't ride on this vehicle

            return false;
        }

        // Cycle through the available passenger positions
        for (i = FirstRiderPositionIndex; i < WeaponPawns.Length; ++i)
        {
            // If it's a passenger pawn & the position is free, then climb aboard
            if (DHPassengerPawn(WeaponPawns[i]) != none && WeaponPawns[i].Driver == none)
            {
                WeaponPawns[i].KDriverEnter(P);

                return true;
            }
        }

        DisplayVehicleMessage(8, P); // all rider positions full

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
    bDriverAlreadyEntered = true; // added here as a much simpler alternative to the Timer() in ROWheeledVehicle
    DriverPositionIndex = InitialPositionIndex;
    PreviousPositionIndex = InitialPositionIndex;
    Instigator = self;
    ResetTime = Level.TimeSeconds - 1.0;

    if (bEngineOff && !P.IsHumanControlled()) // lets bots start vehicle
    {
        ServerStartEngine();
    }

    super(Vehicle).KDriverEnter(P); // need to skip over Super from ROVehicle

    Driver.bSetPCRotOnPossess = false; // so when player gets out he'll be facing the same direction as he was inside the vehicle
}

// Modified to add an engine start/stop hint & to enforce bDesiredBehindView = false (avoids a view rotation bug)
// Matt: also to work around various net client problems caused by replication timing issues
simulated function ClientKDriverEnter(PlayerController PC)
{
    local DHPlayer P;

    // Fix possible replication timing problems on a net client
    if (Role < ROLE_Authority && PC != none)
    {
        // Server passed the PC with this function, so we can safely set new Controller here, even though may take a little longer for new Controller value to replicate
        // And we know new Owner will also be the PC & new net Role will AutonomousProxy, so we can set those too, avoiding problems caused by variable replication delay
        // e.g. DrawHUD() can be called before Controller is replicated; SwitchMesh() may fail because new Role isn't received until later
        Controller = PC;
        SetOwner(PC);
        Role = ROLE_AutonomousProxy;

        // Fix for possible camera problem when deploying into spawn vehicle (see notes in DHVehicleMGPawn.ClientKDriverEnter)
        if (PC.IsInState('Spectating'))
        {
            PC.GotoState('PlayerWalking');
        }
    }

    // bDesiredBehindView may be true in user.ini config file, if player exited game while in behind view in same vehicle (config values change class defaults)
    bDesiredBehindView = false;

    // Hints re engine start/stop & use of deploy vehicles
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
// We no longer disable Tick when driver exits, as vehicle may still be moving & dust effects need updating as vehicle slows
// Instead we disable Tick at the end of Tick itself, if vehicle isn't moving & has no driver
simulated event DrivingStatusChanged()
{
    // Enable Tick if we have a driver (necessary even if engine is off, to prevent vehicle from being driven)
    if (bDriving)
    {
        Enable('Tick');
    }
    // Play neutral idle animation if player has exited, but not on a server
    else if (Level.NetMode != NM_DedicatedServer && HasAnim(BeginningIdleAnim))
    {
        PlayAnim(BeginningIdleAnim);
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
// Server also needs to be in state ViewTransition if player is unbuttoning to prevent player exiting until fully unbuttoned
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
        if (Level.NetMode != NM_DedicatedServer && IsHumanControlled() && !PlayerController(Controller).bBehindView)
        {
            // Switch to mesh for new position as may be different
            SwitchMesh(DriverPositionIndex);

            // If moving to a less zoomed position, we zoom out now, otherwise we wait until end of transition to zoom in
            if (DriverPositions[DriverPositionIndex].ViewFOV > DriverPositions[PreviousPositionIndex].ViewFOV)
            {
                if (DriverPositions[DriverPositionIndex].bDrawOverlays)
                {
                    PlayerController(Controller).SetFOV(DriverPositions[DriverPositionIndex].ViewFOV);
                }
                else
                {
                    PlayerController(Controller).DesiredFOV = DriverPositions[DriverPositionIndex].ViewFOV; // WV was doing this if not an OL position - AV was not
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

    if (Role < ROLE_Authority) // only do these clientside checks on a net client
    {
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
        }

        if (class<ROVehicleWeaponPawn>(PassengerWeapons[ChosenWeaponPawnIndex].WeaponPawnClass).default.bMustBeTankCrew)
        {
            bMustBeTankerToSwitch = true;
        }

        // Stop call to server if player has selected a tank crew role but isn't a tanker
        if (bMustBeTankerToSwitch && !(Controller != none && ROPlayerReplicationInfo(Controller.PlayerReplicationInfo) != none
            && ROPlayerReplicationInfo(Controller.PlayerReplicationInfo).RoleInfo != none && ROPlayerReplicationInfo(Controller.PlayerReplicationInfo).RoleInfo.bCanBeTankCrew))
        {
            DisplayVehicleMessage(0); // not qualified to operate vehicle

            return;
        }
    }

    ServerChangeDriverPosition(F);
}

// Modified to prevent exit if player is buttoned up, & to give player the same momentum as the vehicle when exiting
// Also to remove overlap with DriverDied(), moving common features into DriverLeft(), which gets called by both functions
function bool KDriverLeave(bool bForceLeave)
{
    local vector ExitVelocity;

    if (!bForceLeave)
    {
        if (!CanExit()) // bForceLeave means so player is trying to exit not just switch position, so no risk of locking someone in one slot
        {
            return false;
        }

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

// New function to check if player can exit - implement in subclass as required
simulated function bool CanExit()
{
    return true;
}

// Modified to use new, simplified system with exit positions for all vehicle positions included in the vehicle class default properties
// Also to trace from player's actual world location, with a smaller trace extent so player is less likely to snag on objects that wouldn't really block his exit
function bool PlaceExitingDriver()
{
    local vector Extent, ZOffset, ExitPosition, HitLocation, HitNormal;
    local int    i;

    if (Driver == none)
    {
        return false;
    }

    // Set extent & ZOffset, using a smaller extent than original
    Extent.X = Driver.default.DrivingRadius;
    Extent.Y = Driver.default.DrivingRadius ;
    Extent.Z = Driver.default.DrivingHeight;
    ZOffset = Driver.default.CollisionHeight * vect(0.0, 0.0, 0.5);

    // Debug exits - uses DHVehicle class default, allowing bDebugExitPositions to be toggled for all DHVehicles
    if (class'DHVehicle'.default.bDebugExitPositions)
    {
        for (i = 0; i < ExitPositions.Length; ++i)
        {
            ExitPosition = Location + (ExitPositions[i] >> Rotation) + ZOffset;
            Spawn(class'DHDebugTracer',,, ExitPosition);
        }
    }

    // Check whether player can be moved to each exit position & use the 1st valid one we find
    for (i = 0; i < ExitPositions.Length; ++i)
    {
        ExitPosition = Location + (ExitPositions[i] >> Rotation) + ZOffset;

        if (Trace(HitLocation, HitNormal, ExitPosition, Driver.Location + ZOffset - Driver.default.PrePivot, false, Extent) == none
            && Trace(HitLocation, HitNormal, ExitPosition, ExitPosition + ZOffset, false, Extent) == none
            && Driver.SetLocation(ExitPosition))
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
    if (bEngineOff || Health <= 0 || EngineHealth <= 0)
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
    local PlayerController PC;
    local coords           WheelCoords;
    local bool             bLowDetail;
    local int              i;

    if (Level.NetMode != NM_DedicatedServer)
    {
        // Update bDropDetail, which if true will avoid dust & exhaust emitters as unnecessary detail
        // Note - won't drop detail if player's ViewTarget is the vehicle or anything joined to it, including a VehicleWeaponPawn (will be the case for player in a vehicle position)
        if (Level.bDropDetail || Level.DetailMode == DM_Low)
        {
            PC = Level.GetLocalPlayerController();

            if (PC != none && (PC.ViewTarget == none || !PC.ViewTarget.IsJoinedTo(self)))
            {
                bDropDetail = true;

                return;
            }

            bLowDetail = true; // we may not be dropping detail, but we've established that we're on low detail settings, so we'll use this later to avoid checking again
        }

        bDropDetail = false;

        // Create wheel dust emitters
        Dust.Length = Wheels.Length;

        for (i = 0; i < Wheels.Length; ++i)
        {
            if (Dust[i] != none)
            {
                Dust[i].Destroy();
            }

            WheelCoords = GetBoneCoords(Wheels[i].BoneName);
            Dust[i] = Spawn(class'VehicleWheelDustEffect', self,, WheelCoords.Origin + ((vect(0.0, 0.0, -1.0) * Wheels[i].WheelRadius) >> Rotation));

            if (bLowDetail)
            {
                Dust[i].MaxSpritePPS = 3;
                Dust[i].MaxMeshPPS = 3;
            }

            Dust[i].SetBase(self);

            // Boat vehicle uses different 'dirt' colour (white-grey) to simulate a spray effect instead of the usual wheel dust
            if (IsA('DHBoatVehicle'))
            {
                Dust[i].SetDirtColor(Level.WaterDustColor);
            }
            else
            {
                Dust[i].SetDirtColor(Level.DustColor);
            }
        }

        // Create exhaust emitters
        for (i = 0; i < ExhaustPipes.Length; ++i)
        {
            if (ExhaustPipes[i].ExhaustEffect != none)
            {
                ExhaustPipes[i].ExhaustEffect.Destroy();
            }

            if (bLowDetail)
            {
                ExhaustPipes[i].ExhaustEffect = Spawn(ExhaustEffectLowClass, self,, Location + (ExhaustPipes[i].ExhaustPosition >> Rotation), ExhaustPipes[i].ExhaustRotation + Rotation);
            }
            else
            {
                ExhaustPipes[i].ExhaustEffect = Spawn(ExhaustEffectClass, self,, Location + (ExhaustPipes[i].ExhaustPosition >> Rotation), ExhaustPipes[i].ExhaustRotation + Rotation);
            }

            ExhaustPipes[i].ExhaustEffect.SetBase(self);

            // If we don't have a driver, we do a nil update that just sets the lowest exhaust setting for an idling engine
            // Note - don't need to do anything if we do have a driver, as Tick will be enabled & exhaust will get updated anyway, based on vehicle speed
            if (!bDriving)
            {
                ExhaustPipes[i].ExhaustEffect.UpdateExhaust(0.0);
            }
        }

        bEmittersOn = true;
    }
}

// New function to kill exhaust & wheel dust emitters
simulated function StopEmitters()
{
    local int i;

    if (Level.NetMode != NM_DedicatedServer)
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
    bDropDetail = true; // an optimisation as makes the Super in Tick skip over updating dust & exhaust emitters
}

///////////////////////////////////////////////////////////////////////////////////////
//  *********************************  DAMAGE  ************************************  //
///////////////////////////////////////////////////////////////////////////////////////

// Modified to handle possible tread damage, to add randomised damage, & to add engine fire to APCs
function TakeDamage(int Damage, Pawn InstigatedBy, vector HitLocation, vector Momentum, class<DamageType> DamageType, optional int HitIndex)
{
    local Controller InstigatorController;
    local float      VehicleDamageMod, TreadDamageMod;
    local int        InstigatorTeam, i;

    // Suicide/self-destruction
    if (DamageType == class'Suicided' || DamageType == class'ROSuicided')
    {
        super(Vehicle).TakeDamage(Damage, InstigatedBy, HitLocation, Momentum, class'ROSuicided');

        return;
    }

    // Quick fix for the vehicle giving itself impact damage
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

        if (bHasTreads)
        {
            TreadDamageMod = class<ROWeaponDamageType>(DamageType).default.TreadDamageModifier;
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

        if (bHasTreads)
        {
            TreadDamageMod = class<ROVehicleDamageType>(DamageType).default.TreadDamageModifier;
        }
    }

    // Add in the DamageType's vehicle damage modifier & a little damage randomisation
    Damage *= (VehicleDamageMod * RandRange(0.75, 1.08));

    // Exit if no damage
    if (Damage < 1)
    {
        return;
    }

    // Check RO VehHitpoints (engine, ammo)
    // Note driver hit check is deprecated as we use a new player hit detection system, which basically uses normal hit detection as for an infantry player pawn
    for (i = 0; i < VehHitpoints.Length; ++i)
    {
        if (IsPointShot(HitLocation, Momentum, 1.0, i))
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

    // Check if we hit & damaged either track
    if (bHasTreads && TreadDamageMod >= TreadDamageThreshold)
    {
        CheckTreadDamage(HitLocation, Momentum);
    }

    // Call the Super from Vehicle (skip over others)
    super(Vehicle).TakeDamage(Damage, InstigatedBy, HitLocation, Momentum, DamageType);

    // If an APC's health is very low, kill the engine (which will start an engine fire)
    if (bIsApc && Health <= (HealthMax / 3) && Health > 0)
    {
        EngineHealth = 0;
        bEngineOff = true;
        SetEngine();
    }
}

// New function to remove a very long functionality from the already very long TakeDamage() function
// Matt UK July 2015: added a modified alternative method for track hit detection that works properly
// Problem with original RO method above is the InAngle calculation is distorted by the position of the hit along the vehicle mesh's X axis
// New method is simpler & works, producing consistent results along the length of the hull
// To implement, it needs each tracked vehicle to have TreadHitMaxHeight set, being the height (in Unreal units) of the top of the tracks above the hull mesh origin
// I don't have time to do this for the 6.0 release, so will add later
// Both methods are functional - just add a TreadHitMaxHeight that isn't zero to use the new method
function CheckTreadDamage(vector HitLocation, vector Momentum)
{
    local vector HitDir, LocDir, X, Y, Z;
    local float  HitHeight, InAngle, HitAngleDegrees, Side, InAngleDegrees;
    local bool   bUsingTreadHitMaxHeight, bHitLowEnoughToHitTrack;

    // Work out the height of the HitLocation, in relation to the hull mesh origin
    if (TreadHitMaxHeight != 0.0)
    {
        // New, better method - straightforward height in units (difference in Z axis, having factored in hull's rotation)
        bUsingTreadHitMaxHeight = true;
        HitDir = HitLocation - Location;
        HitHeight = (HitDir << Rotation).Z;

        if (HitHeight <= TreadHitMaxHeight)
        {
            bHitLowEnoughToHitTrack = true;
        }
    }
    else
    {
        // Old, flawed method - height expressed as an angle in radians
        HitDir = HitLocation - Location;
        GetAxes(Rotation, X, Y, Z);
        InAngle = Acos(Normal(HitDir) dot Normal(Z));

        if (InAngle > TreadHitMinAngle)
        {
            bHitLowEnoughToHitTrack = true;
        }
    }

    // We hit low enough to possibly hit one of the tracks
    if (bHitLowEnoughToHitTrack)
    {
        // Now figure out which side of the vehicle we hit
        if (bUsingTreadHitMaxHeight)
        {
            GetAxes(Rotation, X, Y, Z);
        }

        LocDir = vector(Rotation);
        LocDir.Z = 0.0;
        HitDir.Z = 0.0;
        HitAngleDegrees = class'UUnits'.static.RadiansToDegrees(Acos(Normal(LocDir) dot Normal(HitDir)));
        Side = Y dot HitDir;

        if (Side < 0.0)
        {
            HitAngleDegrees = 360.0 - HitAngleDegrees;
        }

        // Right track hit
        if (HitAngleDegrees >= FrontRightAngle && HitAngleDegrees < RearRightAngle)
        {
            // Calculate the direction the shot came from, so we can check for possible 'hit detection bug' (opposite side collision detection error)
            InAngleDegrees = class'UUnits'.static.RadiansToDegrees(Acos(Normal(-Momentum) dot Normal(Y)));

            // InAngle over 90 degrees is impossible, so it's a hit detection bug & we need to switch to left side (same as in DHShouldPenetrate)
            if (InAngleDegrees > 90.0)
            {
                if (!bLeftTrackDamaged)
                {
                    DamageTrack(true);

                    if (bDebugTreadText && Role == ROLE_Authority)
                    {
                        if (bUsingTreadHitMaxHeight)
                        {
                            Level.Game.Broadcast(self, "Hit bug: switching from right to LEFT track damaged (HitHeight =" @ HitHeight $ ")");
                        }
                        else
                        {
                            Level.Game.Broadcast(self, "Hit bug: switching from right to LEFT track damaged");
                        }
                    }
                }
            }
            // Otherwise it's a valid hit on the right track
            else if (!bRightTrackDamaged)
            {
                DamageTrack(false);

                if (bDebugTreadText && Role == ROLE_Authority)
                {
                    if (bUsingTreadHitMaxHeight)
                    {
                        Level.Game.Broadcast(self, "Right track damaged (HitHeight =" @ HitHeight $ ")");
                    }
                    else
                    {
                        Level.Game.Broadcast(self, "Right track damaged");
                    }
                }
            }
        }
        // Left track hit
        else if (HitAngleDegrees >= RearLeftAngle && HitAngleDegrees < FrontLeftAngle)
        {
            InAngleDegrees = class'UUnits'.static.RadiansToDegrees(Acos(Normal(-Momentum) dot Normal(-Y)));

            // InAngle over 90 degrees is impossible, so it's a hit detection bug & we need to switch to right side
            if (InAngleDegrees > 90.0)
            {
                if (!bRightTrackDamaged)
                {
                    DamageTrack(false);

                    if (bDebugTreadText && Role == ROLE_Authority)
                    {
                        if (bUsingTreadHitMaxHeight)
                        {
                            Level.Game.Broadcast(self, "Hit bug: switching from left to RIGHT track damaged (HitHeight =" @ HitHeight $ ")");
                        }
                        else
                        {
                            Level.Game.Broadcast(self, "Hit bug: switching from left to RIGHT track damaged");
                        }
                    }
                }
            }
            // Otherwise it's a valid hit on the left track
            else if (!bLeftTrackDamaged)
            {
                DamageTrack(true);

                if (bDebugTreadText && Role == ROLE_Authority)
                {
                    if (bUsingTreadHitMaxHeight)
                    {
                        Level.Game.Broadcast(self, "Left track damaged (HitHeight =" @ HitHeight $ ")");
                    }
                    else
                    {
                        Level.Game.Broadcast(self, "Left track damaged");
                    }
                }
            }
        }
    }
}

// Modified to call SetDamagedTracks() for single player or listen server, as we no longer use Tick (net client gets that via PostNetReceive)
function DamageTrack(bool bLeftTrack)
{
    if (bLeftTrack)
    {
        bLeftTrackDamaged = true;
    }
    else
    {
        bRightTrackDamaged = true;
    }

    SetDamagedTracks();
}

// Emptied out as blast damage to exposed vehicle occupants is now handled from HurtRadius() in the projectile class
function DriverRadiusDamage(float DamageAmount, float DamageRadius, Controller EventInstigator, class<DamageType> DamageType, float Momentum, vector HitLocation)
{
}

// Modified to randomise explosion damage (except for resupply vehicles) & to add DestroyedBurningSound
function VehicleExplosion(vector MomentumNormal, float PercentMomentum)
{
    local vector LinearImpulse, AngularImpulse;
    local float  ExplosionModifier;

    if (ResupplyAttachment != none)
    {
        ExplosionModifier = 1.0;
    }
    else
    {
        ExplosionModifier = FRand();
    }

    HurtRadius(ExplosionDamage * ExplosionModifier, ExplosionRadius * ExplosionModifier, ExplosionDamageType, ExplosionMomentum, Location);
    AmbientSound = DestroyedBurningSound;
    SoundVolume = 255;
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

    // Spawn destroyed vehicle effect
    if (Level.NetMode != NM_DedicatedServer)
    {
        // If vehicle disintegrates (falls below DisintegrationHealth), this function gets called twice & two effects get spawned
        // The 1st call spawns a normal effect, but this is followed by a 2nd disintegration call (with bFinal), which spawns a disintegration effect
        // This is handled by native code so we can't change what happens - a fix is to destroy the 1st effect if a 2nd is going to be spawned
        if (DestructionEffect != none)
        {
            DestructionEffect.Destroy();
        }

        // Low detail effect
        if (Level.bDropDetail || Level.DetailMode == DM_Low)
        {
            if (bFinal)
            {
                DestructionEffect = Spawn(DisintegrationEffectLowClass, self,, Location, Rotation);
            }
            else
            {
                DestructionEffect = Spawn(DestructionEffectLowClass, self);
            }
        }
        // Standard detail effect
        else
        {
            if (bFinal)
            {
                DestructionEffect = Spawn(DisintegrationEffectClass, self,, Location, Rotation);
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

        if (!bEngineOff)
        {
            bEngineOff = true;
            PlaySound(DamagedShutDownSound, SLOT_None, FClamp(Abs(Throttle), 0.3, 0.75));
        }

        SetEngine();
    }
}

// Modified to tone down the sounds played when the vehicle impacts on something, as often caused constant 'bottoming out' sounds on the ground
event TakeImpactDamage(float AccelMag)
{
    local int Damage;

    Damage = int(AccelMag * ImpactDamageModifier());
    TakeDamage(Damage, self, ImpactInfo.Pos, vect(0.0, 0.0, 0.0), class'DHVehicleCollisionDamageType');

    // Play impact sound (often vehicle 'bottoming out' on ground)
    // Modified to reduce sound radius so doesn't play across level, & limited sound occurrence to every second
    if (ImpactDamageSounds.Length > 0 && (Level.TimeSeconds - LastImpactSound) > 1.0)
    {
        PlaySound(ImpactDamageSounds[Rand(ImpactDamageSounds.Length - 1)], SLOT_None, TransientSoundVolume * 2.5, false, 120.0,, true);
        LastImpactSound = Level.TimeSeconds;
    }

    // Make vehicle explode if it's now dead
    if (Health < 0 && (Level.TimeSeconds - LastImpactExplosionTime) > TimeBetweenImpactExplosions)
    {
        VehicleExplosion(Normal(ImpactInfo.ImpactNorm), 0.5);
        LastImpactExplosionTime = Level.TimeSeconds;
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

    for (i = 0; i < default.CannonSkins.Length; ++i)
    {
        if (default.CannonSkins[i] != none)
        {
            L.AddPrecacheMaterial(default.CannonSkins[i]);
        }
    }

    L.AddPrecacheMaterial(default.VehicleHudImage);
    L.AddPrecacheMaterial(default.MPHMeterMaterial);
    L.AddPrecacheMaterial(default.DamagedTreadPanner);

    if (default.HighDetailOverlay != none)
    {
        L.AddPrecacheMaterial(default.HighDetailOverlay);
    }

    if (default.DestroyedVehicleMesh != none)
    {
        L.AddPrecacheStaticMesh(default.DestroyedVehicleMesh);
    }

    if (default.DamagedTrackStaticMeshLeft != none)
    {
        L.AddPrecacheStaticMesh(default.DamagedTrackStaticMeshLeft);
    }

    if (default.DamagedTrackStaticMeshRight != none)
    {
        L.AddPrecacheStaticMesh(default.DamagedTrackStaticMeshRight);
    }

    for (i = 0; i < default.VehicleAttachments.Length; ++i)
    {
        if (default.VehicleAttachments[i].StaticMesh != none)
        {
            L.AddPrecacheStaticMesh(default.VehicleAttachments[i].StaticMesh);
        }
    }

    for (i = 0; i < default.RandomAttachOptions.Length; ++i)
    {
        if (default.RandomAttachOptions[i].StaticMesh != none)
        {
            L.AddPrecacheStaticMesh(default.RandomAttachOptions[i].StaticMesh);
        }
    }

    for (i = 0; i < default.CollisionAttachments.Length; ++i)
    {
        if (default.CollisionAttachments[i].StaticMesh != none)
        {
            L.AddPrecacheStaticMesh(default.CollisionAttachments[i].StaticMesh);
        }
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

    for (i = 0; i < CannonSkins.Length; ++i)
    {
        if (CannonSkins[i] != none)
        {
            Level.AddPrecacheMaterial(CannonSkins[i]);
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

    if (DamagedTrackStaticMeshLeft != none)
    {
        Level.AddPrecacheStaticMesh(DamagedTrackStaticMeshLeft);
    }

    if (DamagedTrackStaticMeshRight != none)
    {
        Level.AddPrecacheStaticMesh(DamagedTrackStaticMeshRight);
    }

    for (i = 0; i < VehicleAttachments.Length; ++i)
    {
        if (VehicleAttachments[i].StaticMesh != none)
        {
            Level.AddPrecacheStaticMesh(VehicleAttachments[i].StaticMesh);
        }
    }

    for (i = 0; i < RandomAttachOptions.Length; ++i)
    {
        if (RandomAttachOptions[i].StaticMesh != none)
        {
            Level.AddPrecacheStaticMesh(RandomAttachOptions[i].StaticMesh);
        }
    }

    for (i = 0; i < CollisionAttachments.Length; ++i)
    {
        if (CollisionAttachments[i].StaticMesh != none)
        {
            Level.AddPrecacheStaticMesh(CollisionAttachments[i].StaticMesh);
        }
    }
}

// New function to spawn specific attachments & variety of possible generic vehicle attachments (which avoid need for subclassed common functionality & lots of instance variables)
simulated function SpawnVehicleAttachments()
{
    local VehicleAttachment VA;
    local class<Actor>      AttachClass;
    local Actor             A;
    local int               RandomNumber, CumulativeChance, i;

    // Treads & movement sound attachments
    if (Level.NetMode != NM_DedicatedServer)
    {
        if (bHasTreads)
        {
            SetupTreads();
        }

        if (EngineSound != none && EngineSoundBone != '' && EngineSoundAttach == none)
        {
            EngineSoundAttach = SpawnAttachment(class'ROSoundAttachment', EngineSoundBone);
            EngineSoundAttach.AmbientSound = EngineSound;
        }

        if (RumbleSound != none && RumbleSoundBone != '' && RumbleSoundAttach == none)
        {
            RumbleSoundAttach = SpawnAttachment(class'ROSoundAttachment', RumbleSoundBone);
            RumbleSoundAttach.AmbientSound = RumbleSound;
        }
    }

    if (Role == ROLE_Authority)
    {
        if (ResupplyAttachmentClass != none && ResupplyAttachBone != '' && ResupplyAttachment == none)
        {
            ResupplyAttachment = SpawnAttachment(ResupplyAttachmentClass, ResupplyAttachBone);
        }

        // If vehicle has possible random decorative attachments, select which one (if any at all, depending on specified chances)
        if (RandomAttachOptions.Length > 0 && RandomAttachmentIndex >= RandomAttachOptions.Length)
        {
            RandomNumber = RAND(100);

            for (i = 0; i < RandomAttachOptions.Length; ++i)
            {
                CumulativeChance += RandomAttachOptions[i].PercentChance;

                if (RandomNumber < CumulativeChance)
                {
                    RandomAttachmentIndex = i; // set replicated variable so clients know which random attachment to spawn
                    break;
                }
            }
        }
    }

    // If a valid random attachment type has been selected, copy it to the VehicleAttachments array, so it gets spawned next like a standard vehicle attachment
    if (RandomAttachmentIndex < RandomAttachOptions.Length && RandomAttachOptions[RandomAttachmentIndex].StaticMesh != none)
    {
        RandomAttachment.StaticMesh = RandomAttachOptions[RandomAttachmentIndex].StaticMesh;
        VehicleAttachments[VehicleAttachments.Length] = RandomAttachment;
    }

    // Spawn any decorative attachments
    for (i = 0; i < VehicleAttachments.Length; ++i)
    {
        VA = VehicleAttachments[i];

        // Spawn on a server only if attachment has collision, & only spawn if either has specified static mesh or a specified actor class
        if ((Level.NetMode != NM_DedicatedServer || VA.bHasCollision) && (VA.StaticMesh != none || VA.AttachClass != none))
        {
            // Default is base deco attachment class, but a specialised subclass can be specified if desired
            if (VA.AttachClass != none)
            {
                AttachClass = VA.AttachClass;
            }
            else
            {
                AttachClass = class'DHDecoAttachment';
            }

            A = SpawnAttachment(AttachClass, VA.AttachBone, VA.StaticMesh, VA.Offset);

            // Apply any specified options for static mesh, attachment bone, offset, or collision
            if (A != none)
            {
                if (VA.Skin != none)
                {
                    A.Skins[0] = VA.Skin;
                }

                if (VA.bHasCollision)
                {
                    A.SetCollision(true, true); // bCollideActors & bBlockActors both true, so attachment block players walking through & stop projectiles
                    A.bWorldGeometry = true;    // means we get appropriate projectile impact effects, as if we'd hit a normal static mesh actor
                    // TODO - modify ProcessTouch() in projectiles to play hit effects on things other than VehicleWeapons & DHPawns, so we don't need to make this world geometry
                }

                VehicleAttachments[i].Actor = A; // save a reference to this actor in the VehicleAttachments slot
            }
        }
    }

    // Spawn any collision static mesh attachments
    for (i = 0; i < CollisionAttachments.Length; ++i)
    {
        CollisionAttachments[i].Actor = class'DHCollisionMeshActor'.static.AttachCollisionMesh
            (self, CollisionAttachments[i].StaticMesh, CollisionAttachments[i].AttachBone, CollisionAttachments[i].Offset, class<DHCollisionMeshActor>(CollisionAttachments[i].AttachClass));
    }
}

// New helper function to handle spawning an actor to attach to this vehicle, just to avoid code repetition
simulated function Actor SpawnAttachment(class<Actor> AttachClass, optional name AttachBone, optional StaticMesh AttachStaticMesh, optional vector AttachOffset)
{
    local Actor A;

    if (AttachClass != none)
    {
        A = Spawn(AttachClass);

        if (A != none)
        {
            if (AttachStaticMesh != none && A.DrawType == DT_StaticMesh)
            {
                A.SetStaticMesh(AttachStaticMesh);
            }

            if (AttachBone != '')
            {
                AttachToBone(A, AttachBone);
            }
            else
            {
                A.SetBase(self);
            }

            if (AttachOffset != vect(0.0, 0.0, 0.0))
            {
                A.SetRelativeLocation(AttachOffset);
            }
        }
    }

    return A;
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

// Modified from ROTreadCraft to replace literal for pan direction, so can be easily subclassed, & to incorporate extra tread sounds that were spawned in PostBeginPlay()
// Also made tread sounds have same sound radius as engine, so we can actually hear that sound - makes tanks seem more "in the same world"
simulated function SetupTreads()
{
    LeftTreadPanner = VariableTexPanner(Level.ObjectPool.AllocateObject(class'VariableTexPanner'));

    if (LeftTreadPanner != none)
    {
        LeftTreadPanner.Material = Skins[LeftTreadIndex];
        LeftTreadPanner.PanDirection = LeftTreadPanDirection;
        LeftTreadPanner.PanRate = 0.0;
        Skins[LeftTreadIndex] = LeftTreadPanner;
    }

    RightTreadPanner = VariableTexPanner(Level.ObjectPool.AllocateObject(class'VariableTexPanner'));

    if (RightTreadPanner != none)
    {
        RightTreadPanner.Material = Skins[RightTreadIndex];
        RightTreadPanner.PanDirection = RightTreadPanDirection;
        RightTreadPanner.PanRate = 0.0;
        Skins[RightTreadIndex] = RightTreadPanner;
    }

    if (LeftTreadSound != none && LeftTrackSoundBone != '' && LeftTreadSoundAttach == none)
    {
        LeftTreadSoundAttach = SpawnAttachment(class'ROSoundAttachment', LeftTrackSoundBone);
        LeftTreadSoundAttach.AmbientSound = LeftTreadSound;
        LeftTreadSoundAttach.SoundRadius = SoundRadius;
        LeftTreadSoundAttach.TransientSoundRadius = TransientSoundRadius;
    }

    if (RightTreadSound != none && RightTrackSoundBone != '' && RightTreadSoundAttach == none)
    {
        RightTreadSoundAttach = SpawnAttachment(class'ROSoundAttachment', RightTrackSoundBone);
        RightTreadSoundAttach.AmbientSound = RightTreadSound;
        RightTreadSoundAttach.SoundRadius = SoundRadius;
        RightTreadSoundAttach.TransientSoundRadius = TransientSoundRadius;
    }
}

// Modified from ROTreadCraft to change sound volumes, including damaged treads being quieter, & to include an engine sound
// Also optimised by incorporating MotionSoundVolume as a passed function argument instead of a separate instance variable
simulated function UpdateMovementSound(float MotionSoundVolume)
{
    if (EngineSoundAttach != none)
    {
        EngineSoundAttach.SoundVolume = MotionSoundVolume * 0.75;
    }

    if (RumbleSoundAttach != none)
    {
        RumbleSoundAttach.SoundVolume = MotionSoundVolume * RumbleSoundVolumeModifier;
    }

    if (LeftTreadSoundAttach != none)
    {
        if (bLeftTrackDamaged)
        {
            LeftTreadSoundAttach.SoundVolume = MotionSoundVolume * 0.25; // damaged tracks are quieter
        }
        else
        {
            LeftTreadSoundAttach.SoundVolume = MotionSoundVolume * 0.9; // was only 0.75 in RO
        }
    }

    if (RightTreadSoundAttach != none)
    {
        if (bRightTrackDamaged)
        {
            RightTreadSoundAttach.SoundVolume = MotionSoundVolume * 0.25;
        }
        else
        {
            RightTreadSoundAttach.SoundVolume = MotionSoundVolume * 0.9;
        }
    }
}

// New function to set up damaged tracks
simulated function SetDamagedTracks()
{
    if (Level.NetMode == NM_DedicatedServer || !bHasTreads)
    {
        return;
    }

    if (bLeftTrackDamaged)
    {
        Skins[LeftTreadIndex] = DamagedTreadPanner;

        if (LeftTreadSoundAttach != none)
        {
            LeftTreadSoundAttach.AmbientSound = TrackDamagedSound;
        }

        // Matt: added support for spawning damaged track model as decorative static mesh
        if (DamagedTrackStaticMeshLeft != none && DamagedTrackLeft == none)
        {
            DamagedTrackLeft = SpawnAttachment(class'DHDecoAttachment', DamagedTrackAttachBone, DamagedTrackStaticMeshLeft);
            DamagedTrackLeft.Skins[0] = default.Skins[LeftTreadIndex]; // sets damaged tread skin to match treads for this tank (i.e. whether normal or snowy)
        }
    }

    if (bRightTrackDamaged)
    {
        Skins[RightTreadIndex] = DamagedTreadPanner;

        if (RightTreadSoundAttach != none)
        {
            RightTreadSoundAttach.AmbientSound = TrackDamagedSound;
        }

        if (DamagedTrackStaticMeshRight != none && DamagedTrackRight == none)
        {
            DamagedTrackRight = SpawnAttachment(class'DHDecoAttachment', DamagedTrackAttachBone, DamagedTrackStaticMeshRight);
            DamagedTrackRight.Skins[0] = default.Skins[RightTreadIndex];
        }
    }
}

// Modified to destroy extra attachments & effects, & to add option to skin destroyed vehicle static mesh to match camo variant (avoiding need for multiple destroyed meshes)
simulated event DestroyAppearance()
{
    local int i;

    super.DestroyAppearance();

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
    local int i;

    if (ResupplyAttachment != none && Role == ROLE_Authority)
    {
        ResupplyAttachment.Destroy();
    }

    for (i = 0; i < VehicleAttachments.Length; ++i)
    {
        if (VehicleAttachments[i].Actor != none)
        {
            VehicleAttachments[i].Actor.Destroy();
        }
    }

    for (i = 0; i < CollisionAttachments.Length; ++i)
    {
        if (CollisionAttachments[i].Actor != none)
        {
            CollisionAttachments[i].Actor.Destroy();
        }
    }

    if (Level.NetMode != NM_DedicatedServer)
    {
        if (EngineSoundAttach != none)
        {
            EngineSoundAttach.Destroy();
        }

        if (RumbleSoundAttach != none)
        {
            RumbleSoundAttach.Destroy();
        }

        if (bHasTreads)
        {
            if (LeftTreadPanner != none)
            {
                Level.ObjectPool.FreeObject(LeftTreadPanner);
                LeftTreadPanner = none;
            }

            if (RightTreadPanner != none)
            {
                Level.ObjectPool.FreeObject(RightTreadPanner);
                RightTreadPanner = none;
            }

            if (LeftTreadSoundAttach != none)
            {
                LeftTreadSoundAttach.Destroy();
            }

            if (RightTreadSoundAttach != none)
            {
                RightTreadSoundAttach.Destroy();
            }

            if (DamagedTrackLeft != none)
            {
                DamagedTrackLeft.Destroy();
            }

            if (DamagedTrackRight != none)
            {
                DamagedTrackRight.Destroy();
            }
        }

        StopEmitters();
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

// Modified so spawn vehicles never respawn when left empty, to use DriverTraceDistSquared instead of literal values,
// to include a nearby friendly vehicle that has an occupied vehicle weapon position, & to add debug
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
        // Found a friendly pawn within rang (ignoring an empty vehicle), but now make further checks
        if (P != self && (P.Controller != none || (P.IsA('ROVehicle') && !ROVehicle(P).IsVehicleEmpty())) && P.GetTeamNum() == GetTeamNum())
        {
            // Don't reset if it's a friendly player pawn within DriverTraceDistSquared, without line of sight check (using squared values as VSizeSquared is more efficient)
            if (ROPawn(P) != none && (VSizeSquared(P.Location - Location) < DriverTraceDistSquared))
            {
                if (bDebuggingText)
                {
                    Level.Game.Broadcast(self, Tag @ "is empty vehicle, but set new ResetTime as found friendly player pawn nearby");
                }

                ResetTime = Level.TimeSeconds + IdleTimeBeforeReset;

                return;
            }
            // Don't reset if it's a friendly player pawn  that's within line of sight
            else if (FastTrace(P.Location + P.CollisionHeight * vect(0.0, 0.0, 1.0), Location + CollisionHeight * vect(0.0, 0.0, 1.0)))
            {
                if (bDebuggingText)
                {
                    Level.Game.Broadcast(self, Tag @ "is empty vehicle, but set new ResetTime as found friendly pawn nearby & in line of sight");
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

// Modified to prevent "enter vehicle" screen messages if vehicle is destroyed & to pass new NotifyParameters to message, allowing it to display both the use/enter key & vehicle name
simulated event NotifySelected(Pawn User)
{
    if (Level.NetMode != NM_DedicatedServer && User != none && User.IsHumanControlled() && ((Level.TimeSeconds - LastNotifyTime) >= TouchMessageClass.default.LifeTime) && Health > 0)
    {
        NotifyParameters.Put("Controller", User.Controller);
        User.ReceiveLocalizedMessage(TouchMessageClass, 0,,, NotifyParameters);
        LastNotifyTime = Level.TimeSeconds;
    }
}

// New function, replacing RO's DenyEntry() function so we use the DH message class (also re-factored slightly to makes passed Pawn optional)
function DisplayVehicleMessage(int MessageNumber, optional Pawn P, optional bool bPassController)
{
    if (P == none)
    {
        P = self;
    }

    if (bPassController) // option to pass pawn's controller as the OptionalObject, so it can be used in building the message
    {
        P.ReceiveLocalizedMessage(class'DHVehicleMessage', MessageNumber,,, Controller);
    }
    else
    {
        P.ReceiveLocalizedMessage(class'DHVehicleMessage', MessageNumber);
    }
}

// Modified to require both tracks to be damaged for vehicle to be disabled, not just one
// Also to disable an APC if it takes major damage, as well as if engine is dead - this should give time for troops to bail out & escape before vehicle blows
simulated function bool IsDisabled()
{
    return EngineHealth <= 0 || (bLeftTrackDamaged && bRightTrackDamaged) || (bIsApc && Health <= (HealthMax / 3));
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

// Added as when player is in a vehicle, the HUD keybinds to GrowHUD & ShrinkHUD will now call these same named functions in the vehicle classes
// When player is in a vehicle, these functions do nothing to the HUD, but they can be used to add useful vehicle functionality in subclasses, especially as keys are -/+ by default
simulated function GrowHUD();
simulated function ShrinkHUD();

///////////////////////////////////////////////////////////////////////////////////////
//  *************************** DEBUG EXEC FUNCTIONS  *****************************  //
///////////////////////////////////////////////////////////////////////////////////////

// New debug exec to toggle between external & internal meshes (mostly useful with behind view if want to see internal mesh)
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
            bLimitYaw = default.bLimitYaw;
            bLimitPitch = default.bLimitPitch;
        }
    }
}

// New exec that allows debugging exit positions to be toggled for all DHVehicles
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
        class'DHVehicle'.default.bDebugExitPositions = !class'DHVehicle'.default.bDebugExitPositions;
        Log("DHVehicle.bDebugExitPositions =" @ class'DHVehicle'.default.bDebugExitPositions);
    }
}

// New debug exec to quickly damage the vehicle
exec function DamageVehicle()
{
    if (Level.NetMode == NM_Standalone || class'DH_LevelInfo'.static.DHDebugMode())
    {
        Health /= 2;
        EngineHealth /= 2;
    }
}

// New debug exec for testing engine damage
exec function KillEngine()
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

// New debug exec for testing track damage
exec function DamTrack(string Track)
{
    if ((Level.NetMode == NM_Standalone || class'DH_LevelInfo'.static.DHDebugMode()) && bHasTreads)
    {
        ServerDamTrack(Track);
    }
}

function ServerDamTrack(string Track)
{
    if ((Level.NetMode == NM_Standalone || class'DH_LevelInfo'.static.DHDebugMode()) && bHasTreads)
    {
        if (Track ~= "L" || Track ~= "Left")
        {
            DamageTrack(true);
        }
        else if (Track ~= "R" || Track ~= "Right")
        {
            DamageTrack(false);
        }
        else if (Track ~= "B" || Track ~= "Both")
        {
            DamageTrack(true);
            DamageTrack(false);
        }
    }
}

// New debug exec to toggle showing any optional collision mesh attachment
exec function ShowColMesh()
{
    local int i;

    if (Level.NetMode == NM_Standalone || class'DH_LevelInfo'.static.DHDebugMode())
    {
        for (i = 0; i < CollisionAttachments.Length; ++i)
        {
            if (CollisionAttachments[i].Actor != none)
            {
                CollisionAttachments[i].Actor.bHidden = !CollisionAttachments[i].Actor.bHidden;
            }
        }
    }
}

// New debug exec to adjust the volume of the interior rumble sound
exec function SetRumbleVol(float NewValue)
{
    Log(Tag @ "RumbleSoundVolumeModifier =" @ NewValue @ "(was" @ RumbleSoundVolumeModifier $ ")");
    RumbleSoundVolumeModifier = NewValue;
}

defaultproperties
{
    // Engine
    bEngineOff=true
    bSavedEngineOff=true
    IgnitionSwitchInterval=4.0
    ChangeUpPoint=2000.0
    ChangeDownPoint=1000.0
    EngineHealth=30

    // Damage
    Health=175
    HealthMax=175.0
    ImpactDamageMult=0.5
    VehHitpoints(0)=(PointRadius=25.0,PointBone="Engine",bPenetrationPoint=false,DamageMultiplier=1.0,HitPointType=HP_Engine) // no.0 becomes engine instead of driver
    VehHitpoints(1)=(PointRadius=0.0,PointScale=0.0,PointBone="",HitPointType=) // no.1 is no longer engine (neutralised by default, or overridden as required in subclass)
    FrontLeftAngle=333.0
    FrontRightAngle=28.0
    RearRightAngle=152.0
    RearLeftAngle=207.0
    ImpactDamageThreshold=20.0

    // Smoking/burning engine effect
    HeavyEngineDamageThreshold=0.25
    DamagedEffectHealthSmokeFactor=0.75
    DamagedEffectHealthMediumSmokeFactor=0.5
    DamagedEffectHealthHeavySmokeFactor=0.25
    DamagedEffectHealthFireFactor=0.15

    // Sounds
    RumbleSoundVolumeModifier=2.5
    DamagedStartUpSound=sound'DH_AlliedVehicleSounds2.Damaged.engine_start_damaged'
    DamagedShutDownSound=sound'DH_AlliedVehicleSounds2.Damaged.engine_stop_damaged'
    VehicleBurningSound=sound'Amb_Destruction.Fire.Krasnyi_Fire_House02'
    DestroyedBurningSound=sound'Amb_Destruction.Fire.Kessel_Fire_Small_Barrel'

    // Vehicle destruction
    DestructionEffectClass=class'AHZ_ROVehicles.ATCannonDestroyedEmitter'
    DestructionEffectLowClass=class'AHZ_ROVehicles.ATCannonDestroyedEmitter'
    DisintegrationEffectClass=class'ROEffects.ROVehicleDestroyedEmitter'
    DisintegrationEffectLowClass=class'ROEffects.ROVehicleDestroyedEmitter_simple'
    ExplosionDamage=325.0
    ExplosionRadius=700.0
    ExplosionSoundRadius=750.0

    // Treads
    TreadDamageThreshold=0.3
    DamagedTreadPanner=texture'DH_VehiclesGE_tex2.ext_vehicles.Alpha'
    VehicleHudTreadsPosX(0)=0.35
    VehicleHudTreadsPosX(1)=0.65
    VehicleHudTreadsPosY=0.5
    VehicleHudTreadsScale=0.65

    // Vehicle reset/respawn
    VehicleSpikeTime=30.0    // if disabled
    IdleTimeBeforeReset=90.0 // if empty & no friendlies nearby
    FriendlyResetDistance=4000.0 // 66m
    DriverTraceDistSquared=20250000.0 // increased from 4500 as made variable into a squared value (VSizeSquared is more efficient than VSize)

    // Miscellaneous
    VehicleMass=3.0
    PointValue=1.0
    VehicleNameString="ADD VehicleNameString !!"
    TouchMessageClass=class'DHVehicleTouchMessage'
    PlayerCameraBone="Camera_driver"
    MinRunOverSpeed=300 // increased from 0 to roughly 20km/h so that players don't get killed by slow moving (probably friendly) vehicles
    ObjectiveGetOutDist=1500.0
    RandomAttachmentIndex=255 // an invalid starting value, so will only get changed & replicated if a valid selection is made for a random decorative attachment
    SparkEffectClass=none // removes the odd spark effects when vehicle drags bottom on ground

    // These variables are effectively deprecated & should not be used - they are either ignored or values below are assumed & hard coded into functionality:
    bPCRelativeFPRotation=true
    bFPNoZFromCameraPitch=false
    FPCamViewOffset=(X=0.0,Y=0.0,Z=0.0)
    bDesiredBehindView=false
    bDisableThrottle=false
    bKeepDriverAuxCollision=true // Matt: necessary for new player hit detection system, which basically uses normal hit detection as for an infantry player pawn
//  EntryRadius=375.0 // deprecated variable
}
