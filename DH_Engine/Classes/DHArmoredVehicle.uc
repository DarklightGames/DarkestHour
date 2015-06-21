//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DHArmoredVehicle extends ROTreadCraft
    abstract;

#exec OBJ LOAD FILE=..\Textures\DH_InterfaceArt_tex.utx
#exec OBJ LOAD FILE=..\sounds\Amb_Destruction.uax
#exec OBJ LOAD FILE=..\sounds\DH_AlliedVehicleSounds2.uax
#exec OBJ LOAD FILE=..\Textures\DH_VehicleOptics_tex.utx
#exec OBJ LOAD FILE=..\Textures\DH_VehiclesGE_tex2.utx

enum ENewHitPointType
{
    NHP_Normal,
    NHP_GunOptics,
    NHP_PeriscopeOptics,
    NHP_Traverse,
    NHP_GunPitch,
    NHP_Hull,
};

var     ENewHitPointType    NewHitPointType;   // array of new DH special vehicle hit points that may be hit & damaged

struct NewHitpoint
{
    var   float             PointRadius;       // squared radius of the head of the pawn that is vulnerable to headshots
    var   float             PointHeight;       // distance from base of neck to center of head - used for headshot calculation
    var   float             PointScale;        // scale factor for radius & height
    var   name              PointBone;         // bone to reference in offset
    var   vector            PointOffset;       // amount to offset the hitpoint from the bone
    var   bool              bPenetrationPoint; // this is a penetration point, open hatch, etc
    var   float             DamageMultiplier;  // amount to scale damage to the vehicle if this point is hit
    var   ENewHitPointType  NewHitPointType;   // what type of hit point this is
};
var     array<NewHitpoint>  NewVehHitpoints;   // an array of possible small points that can be hit. Index zero is always the driver

// General
var     byte        SpawnVehicleType;       // set by DHSpawnManager & used here for engine on/off hints
var     float       PointValue;             // used for scoring - 1 = Jeeps/Trucks; 2 = Light Tank/Recon Vehicle/AT Gun; 3 = Medium Tank; 4 = Medium Heavy (Pz V,JP), 5 = Heavy Tank
var     float       MaxCriticalSpeed;       // if vehicle goes over max speed, it forces player to pull back on throttle
var     float       SpikeTime;              // the time an empty, disabled vehicle will be automatically blown up
var     float       DriverTraceDistSquared; // CheckReset() variable // Matt: changed to a squared value, as VSizeSquared is more efficient than VSize
var     bool        bEmittersOn;            // dust & exhaust emitters are active (engine on/off)
var     ObjectMap   NotifyParameters;       // an object that can hold references to several other objects, which can be used by messages to build a tailored message
var     bool        bClientInitialized;     // clientside flag that replicated actor has completed initialization (set at end of PostNetBeginPlay)
                                            // (allows client code to determine whether actor is just being received through replication, e.g. in PostNetReceive)
// Obstacle crushing
var     bool        bCrushedAnObject;       // vehicle has just crushed something, causing temporary movement stall
var     float       LastCrushedTime;        // records time object was crushed, so we know when the movement stall should end
var     float       ObjectCrushStallTime;   // how long the movement stall lasts

// Positions & view
var     int         UnbuttonedPositionIndex;      // lowest DriverPositions index where driver is unbuttoned & exposed
var     int         FirstRiderPositionIndex;      // lowest DriverPositions index that is a vehicle rider position, i.e. riding on the outside of the vehicle
var     name        UnbuttonedIdleAnim;           // starting idle animation for net client to play on vehicle if driver is unbuttoned (when actor 1st replicated)
var     name        UnbuttonedDriverIdleAnim;     // starting idle animation for net client to play on driver if he is unbuttoned (when actor 1st replicated)
var     bool        bAllowRiders;                 // players, including non-tankers, can ride on the back or top of the vehicle
var     bool        bMustUnbuttonToSwitchToRider; // stops driver 'teleporting' outside to rider position while buttoned up
var     bool        bPlayerCollisionBoxMoves;     // driver's collision box moves with animations (e.g. raised/lowered on unbuttoning/buttoning), so we need to play anims on server
var     name        PlayerCameraBone;             // just to avoid using literal references to 'Camera_driver' bone & allow extra flexibility
var     bool        bLockCameraDuringTransition;  // lock the camera's rotation to the camera bone during view transitions
var     float       ViewTransitionDuration;       // used to control the time we stay in state ViewTransition
var     texture     PeriscopeOverlay;             // driver's periscope overlay texture

// Armor penetration
var     float       UFrontArmorFactor, URightArmorFactor, ULeftArmorFactor, URearArmorFactor; // upper hull armor thickness (actually used for whole hull, for now)
var     float       UFrontArmorSlope, URightArmorSlope, ULeftArmorSlope, URearArmorSlope;     // upper hull armor slope
var     bool        bProjectilePenetrated;     // shell has passed penetration tests & has entered the vehicle (used in TakeDamage)
var     bool        bTurretPenetration;        // shell has penetrated the turret (used in TakeDamage)
var     bool        bRearHullPenetration;      // shell has penetrated the rear hull (so TakeDamage can tell if an engine hit should stop the round penetrating any further)

// Damage (allows for adjustment for indivudual vehicles in subclasses)
var     float       AmmoIgnitionProbability;   // chance that direct hit on ammo store will ignite it
var     float       TurretDetonationThreshold; // chance that shrapnel will detonate turret ammo
var     float       DriverKillChance;          // chance that shrapnel will kill driver
var     float       CommanderKillChance;       // chance that shrapnel will kill commander
var     float       GunnerKillChance;          // chance that shrapnel will kill bow gunner
var     float       GunDamageChance;           // chance that shrapnel will damage gun pivot mechanism
var     float       TraverseDamageChance;      // chance that shrapnel will damage gun traverse mechanism or turret ring is jammed
var     float       OpticsDamageChance;        // chance that shrapnel will break gunsight optics
var     texture     DamagedPeriscopeOverlay;   // gunsight overlay to show if optics have been broken
var     float       TreadDamageThreshold;      // minimum TreadDamageModifier in DamageType to possibly break treads
var array<Material> DestroyedMeshSkins;        // option to skin destroyed vehicle static mesh to match camo variant (avoiding need for multiple destroyed meshes)

// Engine
var     bool        bEngineOff;                // tank engine is simply switched off
var     bool        bSavedEngineOff;           // clientside record of current value, so PostNetReceive can tell if a new value has been replicated
var     float       IgnitionSwitchInterval;    // interval in seconds before engine can be switched on/off again, used to stop players spamming the ignition
var     float       IgnitionSwitchTime;        // records last engine on/off time, so we can check IgnitionSwitchInterval
var     sound       DamagedStartUpSound;       // sound played when trying to start a damaged engine
var     sound       DamagedShutDownSound;      // sound played when damaged engine shuts down

// Treads
//var   float       TreadHitMaxHeight; // the height (in Unreal units) of the top of the treads above the hull mesh origin, used to detect tread hits // NEW METHOD FOR LATER (see notes in TakeDamage)
var     int         LeftTreadIndex, RightTreadIndex;
var     rotator     LeftTreadPanDirection, RightTreadPanDirection;
var     material    DamagedTreadPanner;
var     class<RODummyAttachment>  DamagedTrackLeftClass, DamagedTrackRightClass; // class for static mesh showing damaged track, e.g. broken track links (clientside only)
var     RODummyAttachment         DamagedTrackLeft, DamagedTrackRight;

// Fire stuff- Shurek & Ch!cKeN (modified by Matt)
var     class<DamageType>           VehicleBurningDamType;
var     class<VehicleDamagedEffect> FireEffectClass;
var     VehicleDamagedEffect        DriverHatchFireEffect;
var     name        FireAttachBone;
var     vector      FireEffectOffset;
var     float       HullFireChance;
var     float       HullFireHEATChance;
var     bool        bOnFire;               // the vehicle itself is on fire
var     float       HullFireDamagePer2Secs;
var     float       PlayerFireDamagePer2Secs;
var     float       NextHullFireDamageTime;
var     float       EngineFireChance;
var     float       EngineFireHEATChance;
var     bool        bEngineOnFire;
var     float       EngineFireDamagePer3Secs;
var     float       NextEngineFireDamageTime;
var     bool        bSetHullFireEffects;
var     bool        bDriverHatchFireNeeded;
var     float       DriverHatchFireSpawnTime;
var     bool        bTurretFireNeeded;
var     float       TurretHatchFireSpawnTime;
var     bool        bHullMGFireNeeded;
var     float       HullMGHatchFireSpawnTime;
var     float       FireDetonationChance;   // chance of a fire blowing a tank up, runs each time the fire does damage
var     float       EngineToHullFireChance; // chance of an engine fire spreading to the rest of the tank, runs each time engine takes fire damage
var     bool        bFirstPenetratingHit;
var     bool        bHEATPenetration;       // a penetrating round is a HEAT round
var     Controller  WhoSetOnFire;
var     int         HullFireStarterTeam;
var     Controller  WhoSetEngineOnFire;
var     int         EngineFireStarterTeam;
var     sound       SmokingEngineSound;
var     sound       VehicleBurningSound;
var     sound       DestroyedBurningSound;

// Schurzen
struct SchurzenType
{
    var class<RODummyAttachment> SchurzenClass; // a possible schurzen decorative attachment class, with different degrees of damage
    var byte                     PercentChance; // the % chance of this deco attachment being the one spawned
};

var     SchurzenType        SchurzenTypes[4]; // an array of possible schurzen attachments
var     byte                SchurzenIndex;    // the schurzen index number selected randomly to be spawned for this vehicle
var     RODummyAttachment   Schurzen;         // actor reference to the schurzen deco attachment, so it can be destroyed when the vehicle gets destroyed
var     vector              SchurzenOffset;   // the positional offset from the attachment bone
var     Material            SchurzenTexture;  // the camo skin for the schurzen attachment

// Debugging help & customizable stuff
var     bool        bDrawPenetration;
var     bool        bDebuggingText;
var     bool        bPenetrationText;
var     bool        bDebugTreadText;
var     bool        bLogPenetration;
var     bool        bDebugExitPositions;
var     bool        bBypassClientSwitchWeaponChecks; // TEMP

replication
{
    // Variables the server will replicate to clients when this actor is 1st replicated
    reliable if (bNetInitial && bNetDirty && Role == ROLE_Authority)
        SchurzenIndex;

    // Variables the server will replicate to the client that owns this actor
//    reliable if (bNetOwner && bNetDirty && Role == ROLE_Authority)
//        MaxCriticalSpeed; // Matt: removed as it never changes & doesn't need to be replicated

    // Variables the server will replicate to all clients
    reliable if (bNetDirty && Role == ROLE_Authority)
        bEngineOff, bOnFire, bEngineOnFire, SpawnVehicleType;
//      bEngineDead                                 // Matt: removed variable (EngineHealth <= 0 does the same thing)
//      EngineHealthMax                             // Matt: removed variable (it never changed anyway & didn't need to be replicated)
//      UnbuttonedPositionIndex,                    // Matt: removed as never changes & doesn't need to be replicated
//      bProjectilePenetrated, bFirstPenetratingHit // Matt: removed as not even used clientside
//      bPeriscopeDamaged                           // Matt: removed variable as is part of functionality never implemented

    // Functions a client can call on the server
    reliable if (Role < ROLE_Authority)
        ServerStartEngine,
        ServerToggleDebugExits, ServerDamTrack, ServerHullFire, ServerEngineFire, ServerKillEngine, // these ones only during development
        ServerLogSwitch; // DEBUG (temp)
//      TakeFireDamage // Matt: removed as doesn't need to be replicated as is only called from Tick, which server gets anyway (tbh replication every Tick is pretty heinous)

    reliable if (Role == ROLE_Authority) // DEBUG (temp)
        ClientLogSwitch;
}

///////////////////////////////////////////////////////////////////////////////////////
//  ********************** ACTOR INITIALISATION & DESTRUCTION  ********************  //
///////////////////////////////////////////////////////////////////////////////////////

// Modified to set fire damage properties, to select any random schurzen model, & so net clients show unoccupied rider positions on the HUD vehicle icon
// Also to set up new NotifyParameters object, including this vehicle class, which gets passed to screen messages & allows them to display vehicle name
simulated function PostBeginPlay()
{
    local byte RandomNumber, CumulativeChance, i;

    super(Vehicle).PostBeginPlay(); // skip over Super in ROWheeledVehicle to avoid setting an initial timer, which we no longer use

    if (HasAnim(BeginningIdleAnim))
    {
        PlayAnim(BeginningIdleAnim);
    }

    if (Role == ROLE_Authority)
    {
        // Set fire damage rates
        HullFireDamagePer2Secs = HealthMax * 0.02;             // so approx 100 seconds from full vehicle health to detonation due to fire
        EngineFireDamagePer3Secs = default.EngineHealth * 0.1; // so approx 30 seconds engine fire until engine destroyed

        // For single player mode, we may as well set this here, as it's only intended to stop idiot players blowing up friendly vehicles in spawn
        if (Level.NetMode == NM_Standalone)
        {
            bDriverAlreadyEntered = true;
        }

        // If vehicle has schurzen (tex != none is flag) then randomise model selection (different degrees of damage, or maybe none at all)
        if (SchurzenTexture != none)
        {
            RandomNumber = RAND(100);

            for (i = 0; i < arraycount(SchurzenTypes); ++i)
            {
                CumulativeChance += SchurzenTypes[i].PercentChance;

                if (RandomNumber < CumulativeChance)
                {
                    SchurzenIndex = i; // set replicated variable so clients know which schurzen to spawn
                    break;
                }
            }
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
        // Clientside treads & sound attachments
        SetupTreads();

        if (RumbleSound != none && RumbleSoundBone != '' && InteriorRumbleSoundAttach == none)
        {
            InteriorRumbleSoundAttach = Spawn(class'ROSoundAttachment');
            InteriorRumbleSoundAttach.AmbientSound = RumbleSound;
            AttachToBone(InteriorRumbleSoundAttach, RumbleSoundBone);
        }

        // Set up new NotifyParameters object
        NotifyParameters = new class'ObjectMap';
        NotifyParameters.Insert("VehicleClass", Class);
    }
}

// Modified to initialize engine-related properties, to spawn any decorative schurzen attachment & to set bClientInitialized flag
// Also so when a vehicle with driver unbuttoned gets replicated to a net client, we animate the vehicle & the driver into the correct position
simulated function PostNetBeginPlay()
{
    super(ROWheeledVehicle).PostNetBeginPlay(); // skip over bugged Super in ROTreadCraft (just tries to get CannonTurret ref from non-existent driver weapons)

    // Initialize engine-related properties
    SetEngine();

    // Only spawn schurzen if a valid attachment class has been selected
    if (SchurzenTexture != none && Level.NetMode != NM_DedicatedServer && SchurzenIndex < arraycount(SchurzenTypes) && SchurzenTypes[SchurzenIndex].SchurzenClass != none)
    {
        Schurzen = Spawn(SchurzenTypes[SchurzenIndex].SchurzenClass);

        if (Schurzen != none)
        {
            Schurzen.Skins[0] = SchurzenTexture; // set the deco attachment's camo skin
            AttachToBone(Schurzen, 'body');
            Schurzen.SetRelativeLocation(SchurzenOffset);
        }
    }

    if (Role < ROLE_Authority)
    {
        // Flags on net client that we've completed initialization of replicated actor
        bClientInitialized = true;

        // Driver is unbuttoned, so animate the vehicle & the driver into the correct position
        if (Driver != none && DriverPositionIndex >= UnbuttonedPositionIndex)
        {
            if (HasAnim(UnbuttonedIdleAnim))
            {
                PlayAnim(UnbuttonedIdleAnim);
            }

            if (Driver.HasAnim(UnbuttonedDriverIdleAnim))
            {
                Driver.PlayAnim(UnbuttonedDriverIdleAnim);
            }
        }
    }
}

// Modified to destroy extra attachments & effects
simulated function Destroyed()
{
    super(ROVehicle).Destroyed();

    DestroyAttachments();
}

// Modified to score the vehicle kill
function Died(Controller Killer, class<DamageType> DamageType, vector HitLocation)
{
    super.Died(Killer, DamageType, HitLocation);

    if (Killer == none)
    {
        return;
    }

    DarkestHourGame(Level.Game).ScoreVehicleKill(Killer, self, PointValue);
}

///////////////////////////////////////////////////////////////////////////////////////
//  ***************************** KEY ENGINE EVENTS  ******************************  //
///////////////////////////////////////////////////////////////////////////////////////

// Matt: modified to handle engine on/off (including manual/powered turret & dust/exhaust emitters), damaged tracks & fire effects, instead of constantly checking in Tick
simulated function PostNetReceive()
{
    // Player has changed position
    if (DriverPositionIndex != SavedPositionIndex)
    {
        PreviousPositionIndex = SavedPositionIndex;
        SavedPositionIndex = DriverPositionIndex;

        // Matt: added 'if' to avoid duplication/conflict with PostNetBeginPlay(), which now handles the starting anims when vehicle replicates to a net client
        // Also no point playing transition anim if there's no Driver (if he's just left, the BeginningIdleAnim will play)
        if (Driver != none && bClientInitialized)
        {
            NextViewPoint();
        }
    }

    // Engine has been switched on or off (but if not bClientInitialized, then actor has just replicated & SetEngine() will get called in PostBeginPlay)
    if (bEngineOff != bSavedEngineOff && bClientInitialized)
    {
        bSavedEngineOff = bEngineOff;
        SetEngine();
    }

    // One of the tracks has been damaged (uses DamagedTreadPanner as an effective flag that net client hasn't already done this)
    if (((bLeftTrackDamaged && Skins.Length > LeftTreadIndex && Skins[LeftTreadIndex] != DamagedTreadPanner) ||
        (bRightTrackDamaged && Skins.Length > LeftTreadIndex && Skins[RightTreadIndex] != DamagedTreadPanner)) && Health > 0)
    {
        SetDamagedTracks();
    }

    if (bOnFire)
    {
        // Vehicle fire has started
        if (!bSetHullFireEffects && Health > 0)
        {
            SetFireEffects();
        }
    }
    else if (bEngineOnFire)
    {
        // Engine fire has started (DEHFireFactor of 1.0 would flag that the engine fire effect is already on)
        if (DamagedEffectHealthFireFactor != 1.0 && Health > 0)
        {
            SetFireEffects();
        }
    }
    // Engine is dead & engine fire has burned out, so set it to smoke instead of burn
    else if (EngineHealth <= 0 && (DamagedEffectHealthFireFactor != 0.0 || DamagedEffectHealthHeavySmokeFactor != 1.0) && Health > 0)
    {
        SetFireEffects();
    }
}

// Modified to remove RO disabled throttle stuff & add handling of jammed steering for a damaged track, MaxCriticalSpeed, object crushing, & stopping all movement if vehicle can't move
simulated function Tick(float DeltaTime)
{
    local KRigidBodyState BodyState;
    local float MotionSoundTemp, MySpeed;
    local int   i;

    if (Controller != none)
    {
        // Damaged treads mean vehicle can only turn one way & speed is limited
        if (bLeftTrackDamaged)
        {
            Throttle = FClamp(Throttle, -0.5, 0.5);

            if (Controller.IsA('ROPlayer'))
            {
                ROPlayer(Controller).aStrafe = -32768.0;
            }
            else if (Controller.IsA('ROBot'))
            {
                Steering = 1.0;
            }
        }
        else if (bRightTrackDamaged)
        {
            Throttle = FClamp(Throttle, -0.5, 0.5);

            if (Controller.IsA('ROPlayer'))
            {
                ROPlayer(Controller).aStrafe = 32768.0;
            }
            else if (Controller.IsA('ROBot'))
            {
                Steering = -1.0;
            }
        }
        // Heavy damage to engine limits speed
        else if (EngineHealth <= (default.EngineHealth * 0.5) && EngineHealth > 0)
        {
            Throttle = FClamp(Throttle, -0.5, 0.5);
        }
    }

    // Only need these effects client side
    if (Level.NetMode != NM_DedicatedServer)
    {
        MySpeed = Abs(ForwardVel); // don't need VSize(Velocity), as already have ForwardVel

        // Update tread & interior rumble sounds dependent on speed
        if (MySpeed > 0.1)
        {
            MotionSoundTemp =  MySpeed / MaxPitchSpeed * 255.0;
            MotionSoundVolume = FClamp(MotionSoundTemp, 0.0, 255.0);
        }
        else
        {
            MotionSoundVolume = 0.0;
        }

        UpdateMovementSound();

        // Set tread & wheel movement rates
        KGetRigidBodyState(BodyState);
        LinTurnSpeed = 0.5 * BodyState.AngVel.Z;

        if (LeftTreadPanner != none)
        {
            LeftTreadPanner.PanRate = MySpeed / TreadVelocityScale;

            if (Velocity dot vector(Rotation) < 0.0)
            {
                LeftTreadPanner.PanRate = -1.0 * LeftTreadPanner.PanRate;
            }

            LeftTreadPanner.PanRate += LinTurnSpeed;
            LeftWheelRot.Pitch += LeftTreadPanner.PanRate * WheelRotationScale;
        }

        if (RightTreadPanner != none)
        {
            RightTreadPanner.PanRate = MySpeed / TreadVelocityScale;

            if (Velocity dot vector(Rotation) < 0.0)
            {
                RightTreadPanner.PanRate = -1.0 * RightTreadPanner.PanRate;
            }

            RightTreadPanner.PanRate -= LinTurnSpeed;
            RightWheelRot.Pitch += RightTreadPanner.PanRate * WheelRotationScale;
        }

        // Animate the tank wheels
        for (i = 0; i < LeftWheelBones.Length; ++i)
        {
            SetBoneRotation(LeftWheelBones[i], LeftWheelRot);
        }

        for (i = 0; i < RightWheelBones.Length; ++i)
        {
            SetBoneRotation(RightWheelBones[i], RightWheelRot);
        }

        // Force player to pull back on throttle if over max speed
        if (MySpeed >= MaxCriticalSpeed && ROPlayer(Controller) != none)
        {
            ROPlayer(Controller).aForward = -32768.0;
        }
    }

    // Slow the tank way down when it tries to turn at high speeds
    if (ForwardVel > 0.0)
    {
        WheelLatFrictionScale = InterpCurveEval(AddedLatFriction, ForwardVel);
    }
    else
    {
        WheelLatFrictionScale = default.WheelLatFrictionScale;
    }

    super(ROWheeledVehicle).Tick(DeltaTime);

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

    // Stop all movement if engine off or both tracks damaged
    if (bEngineOff || (bLeftTrackDamaged && bRightTrackDamaged))
    {
        Velocity = vect(0.0, 0.0, 0.0);
        Throttle = 0.0;
        ThrottleAmount = 0.0;
        Steering = 0.0;
    }
}

// Matt: modified to use a system of interwoven timers instead of constantly checking for things in Tick() - fire damage, spiked vehicle timer
// Drops all RO stuff about bDriverAlreadyEntered, bDisableThrottle & CheckForCrew, as in DH we don't wait for crew anyway - so just set bDriverAlreadyEntered in KDriverEnter()
simulated function Timer()
{
    local float Now;

    if (Health <= 0)
    {
        return;
    }

    Now = Level.TimeSeconds;

    if (Role == ROLE_Authority)
    {
        // Handle any hull fire damage due
        if (bOnFire && Now >= NextHullFireDamageTime)
        {
            TakeFireDamage();
        }

        // Handle any engine fire damage due
        if (bEngineOnFire && Now >= NextEngineFireDamageTime)
        {
            TakeEngineFireDamage();
        }

        // Check to see if we need to destroy a spiked, abandoned vehicle
        if (bSpikedVehicle && Now >= SpikeTime)
        {
            if (IsVehicleEmpty() && !bOnFire)
            {
                KilledBy(self);
            }
            else
            {
                bSpikedVehicle = false; // cancel spike timer if vehicle is now occupied or burning (just let the fire destroy it)
            }
        }
    }

    // Vehicle is burning, so check if we need to spawn any hatch fire effects
    if (bOnFire && Level.NetMode != NM_DedicatedServer)
    {
        if (bDriverHatchFireNeeded && Now >= DriverHatchFireSpawnTime && DriverHatchFireSpawnTime != 0.0)
        {
            StartDriverHatchFire();
        }

        if (bTurretFireNeeded && Now >= TurretHatchFireSpawnTime && TurretHatchFireSpawnTime != 0.0)
        {
            bTurretFireNeeded = false;

            if (DHVehicleCannon(CannonTurret) != none)
            {
                DHVehicleCannon(CannonTurret).StartTurretFire();
            }
        }

        if (bHullMGFireNeeded && Now >= HullMGHatchFireSpawnTime && HullMGHatchFireSpawnTime != 0.0)
        {
            bHullMGFireNeeded = false;

            if (DHVehicleMG(HullMG) != none)
            {
                DHVehicleMG(HullMG).StartMGFire();
            }
        }
    }

    // Engine is dead, but there's no fire, so make sure it is set to smoke instead of burn
    if (EngineHealth <= 0 && !bEngineOnFire && !bOnFire && (DamagedEffectHealthFireFactor != 0.0 || DamagedEffectHealthHeavySmokeFactor != 1.0))
    {
        SetFireEffects();
    }

    SetNextTimer(Now);
}

// New function as we are using timers for different things in different net modes, so work out which one (if any) is due next
simulated function SetNextTimer(optional float Now)
{
    local float NextTimerTime;

    if (Now == 0.0)
    {
        Now = Level.TimeSeconds;
    }

    if (Role == ROLE_Authority)
    {
        if (bOnFire && NextHullFireDamageTime > Now)
        {
            NextTimerTime = NextHullFireDamageTime;
        }

        if (bEngineOnFire && (NextEngineFireDamageTime < NextTimerTime || NextTimerTime == 0.0) && NextEngineFireDamageTime > Now)
        {
            NextTimerTime = NextEngineFireDamageTime;
        }

        if (bSpikedVehicle && (SpikeTime < NextTimerTime || NextTimerTime == 0.0) && SpikeTime > Now)
        {
            NextTimerTime = SpikeTime;
        }
    }

    if (Level.NetMode != NM_DedicatedServer && bOnFire)
    {
        if (bDriverHatchFireNeeded && (DriverHatchFireSpawnTime < NextTimerTime || NextTimerTime == 0.0) && DriverHatchFireSpawnTime > Now)
        {
            NextTimerTime = DriverHatchFireSpawnTime;
        }

        if (bTurretFireNeeded && (TurretHatchFireSpawnTime < NextTimerTime || NextTimerTime == 0.0) && TurretHatchFireSpawnTime > Now)
        {
            NextTimerTime = TurretHatchFireSpawnTime;
        }

        if (bHullMGFireNeeded && (HullMGHatchFireSpawnTime < NextTimerTime || NextTimerTime == 0.0) && HullMGHatchFireSpawnTime > Now)
        {
            NextTimerTime = HullMGHatchFireSpawnTime;
        }
    }

    // Finally set the next timer, if we need one
    if (NextTimerTime > Now)
    {
        SetTimer(NextTimerTime - Now, false);
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

// Modified to add support for periscope overlay & to remove irrelevant stuff about driver weapon crosshair
// Also to optimise a little, including to omit calling DrawVehicle (as is just a 1 liner that can be optimised) & DrawPassengers (as is just an empty function)
simulated function DrawHUD(Canvas C)
{
    local PlayerController PC;
    local vector           CameraLocation;
    local rotator          CameraRotation;
    local Actor            ViewActor;
    local float            SavedOpacity;

    PC = PlayerController(Controller);

    if (PC != none && !PC.bBehindView)
    {
        // Player is in a position where an overlay should be drawn
        if (DriverPositions[DriverPositionIndex].bDrawOverlays && !IsInState('ViewTransition'))
        {
            if (HUDOverlay == none)
            {
                // Draw periscope overlay
                if (DriverPositionIndex == 0 && PeriscopeOverlay != none)
                {
                    // Save current HUD opacity & then set up for drawing overlays
                    SavedOpacity = C.ColorModulate.W;
                    C.ColorModulate.W = 1.0;
                    C.DrawColor.A = 255;
                    C.Style = ERenderStyle.STY_Alpha;

                    DrawPeriscopeOverlay(C);

                    C.ColorModulate.W = SavedOpacity; // reset HudOpacity to original value
                }
            }
            // Draw any HUD overlay
            else if (!Level.IsSoftwareRendering())
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

// New function to draw any textured driver's periscope overlay
simulated function DrawPeriscopeOverlay(Canvas C)
{
    local float ScreenRatio;

    ScreenRatio = Float(C.SizeY) / Float(C.SizeX);
    C.SetPos(0.0, 0.0);
    C.DrawTile(PeriscopeOverlay, C.SizeX, C.SizeY, 0.0, (1.0 - ScreenRatio) * Float(PeriscopeOverlay.VSize) / 2.0, PeriscopeOverlay.USize, Float(PeriscopeOverlay.VSize) * ScreenRatio);
}

// Modified to revert to Super in Pawn, skipping unnecessary stuff in ROWheeledVehicle & ROVehicle, as this is a many-times-a-second function & so should be optimised
function int LimitPitch(int pitch, optional float DeltaTime)
{
    return super(Pawn).LimitPitch(pitch, DeltaTime);
}

// Modified to correct apparent error in ROVehicle, where PitchDownLimit was being used instead of DriverPositions[x].ViewPitchDownLimit in multi position weapon
function int LimitPawnPitch(int pitch)
{
    pitch = pitch & 65535;

    if (!bLimitPitch)
    {
        return pitch;
    }

    if (DriverPositions.Length > 0)
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

// Modified to switch to external mesh & default FOV for behind view
simulated function POVChanged(PlayerController PC, bool bBehindViewChanged)
{
    local int i;

    if (PC.bBehindView)
    {
        if (bBehindViewChanged)
        {
            FixPCRotation(PC); // switching to behind view, so make rotation non-relative to vehicle

            for (i = 0; i < DriverPositions.Length; ++i)
            {
                DriverPositions[i].PositionMesh = default.Mesh;
                DriverPositions[i].ViewFOV = PC.DefaultFOV;
            }

            bDontUsePositionMesh = true;

            if (DriverPositions[DriverPositionIndex].PositionMesh != Mesh && (Role == ROLE_AutonomousProxy || Level.NetMode == NM_Standalone || Level.NetMode == NM_ListenServer))
            {
                LinkMesh(DriverPositions[DriverPositionIndex].PositionMesh);
            }

            PC.SetFOV(DriverPositions[DriverPositionIndex].ViewFOV);

            bLimitYaw = false;
            bLimitPitch = false;
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

        if (bBehindViewChanged)
        {
            for (i = 0; i < DriverPositions.Length; ++i)
            {
                DriverPositions[i].PositionMesh = default.DriverPositions[i].PositionMesh;
                DriverPositions[i].ViewFOV = default.DriverPositions[i].ViewFOV;
            }

            bDontUsePositionMesh = default.bDontUsePositionMesh;

            if (DriverPositions[DriverPositionIndex].PositionMesh != Mesh && (Role == ROLE_AutonomousProxy || Level.NetMode == NM_Standalone || Level.NetMode == NM_ListenServer))
            {
                LinkMesh(DriverPositions[DriverPositionIndex].PositionMesh);
            }

            PC.SetFOV(DriverPositions[DriverPositionIndex].ViewFOV);

            bLimitYaw = default.bLimitYaw;
            bLimitPitch = default.bLimitPitch;
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

// Modified to fix RO bug where players can't get into a rider position on a driven tank if 1st rider position is already occupied
// Original often returned MG as ClosestWeaponPawn, which infantry cannot use, so we now check player can use weapon pawn & it's available)
function Vehicle FindEntryVehicle(Pawn P)
{
    local  float              DistSquared, ClosestDistSquared, BackupDistSquared; // use distance squared to compare to VSizeSquared (faster than VSize)
    local  int                x;
    local  VehicleWeaponPawn  ClosestWeaponPawn, BackupWeaponPawn;
    local  Bot                B;
    local  Vehicle            VehicleGoal;
    local  bool               bPlayerIsTankCrew;

    B = Bot(P.Controller);

    // Bots know what they want
    if (B != none)
    {
        // This is what's added in ROTreadCraft, worked into main function from ROVehicle ("code to get the bots using tanks better")
        if (WeaponPawns.Length != 0 && IsVehicleEmpty())
        {
            for (x = WeaponPawns.Length -1; x >= 0; x--)
            {
                if (WeaponPawns[x].Driver == none)
                {
                    return WeaponPawns[x];
                }
            }
        }

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

        for (x = 0; x < WeaponPawns.Length; ++x)
        {
            if (VehicleGoal == WeaponPawns[x])
            {
                if (WeaponPawns[x].Driver == none)
                {
                    return WeaponPawns[x];
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

    // Always go with driver's seat if no driver (even if player isn't tank crew, TryToDrive puts them in any available rider slot)
    if (Driver == none)
    {
        DistSquared = VSizeSquared(P.Location - (Location + (EntryPosition >> Rotation)));

        if (DistSquared < Square(EntryRadius))
        {
            return self;
        }

        for (x = 0; x < WeaponPawns.Length; ++x)
        {
            DistSquared = VSizeSquared(P.Location - (WeaponPawns[x].Location + (WeaponPawns[x].EntryPosition >> Rotation)));

            if (DistSquared < Square(WeaponPawns[x].EntryRadius))
            {
                return self;
            }
        }

        return none;
    }

    // Record if player is allowed to use tanks
    if (P.IsHumanControlled() && ROPlayerReplicationInfo(P.Controller.PlayerReplicationInfo) != none &&
        ROPlayerReplicationInfo(P.Controller.PlayerReplicationInfo).RoleInfo != none && ROPlayerReplicationInfo(P.Controller.PlayerReplicationInfo).RoleInfo.bCanBeTankCrew)
    {
        bPlayerIsTankCrew = true;
    }

    // Set some high starting values so we can record when we find a closer weapon pawn (squared distances are equivalent to 1,000 units or 16.5m)
    ClosestDistSquared = 1000000.0;
    BackupDistSquared = 1000000.0; // added so we can check the closest weapon pawn player could occupy, even though it may be out of range (vehicle itself may be in range)

    // Loop through weapon pawns to check if we are in entry range
    for (x = 0; x < WeaponPawns.Length; ++x)
    {
        // Ignore this weapon pawn if it's already occupied by another player
        if (WeaponPawns[x] == none || (WeaponPawns[x].Driver != none && WeaponPawns[x].Driver.IsHumanControlled()))
        {
            continue;
        }

        // Stop non-tanker from trying to enter a tank crew position (cannon or MG), which would be unsuccessful & stop them reaching a valid rider slot
        if (!bPlayerIsTankCrew && WeaponPawns[x].IsA('ROVehicleWeaponPawn') && ROVehicleWeaponPawn(WeaponPawns[x]).bMustBeTankCrew)
        {
            continue;
        }

        // Calculate player's distance from this weapon pawn
        DistSquared = VSizeSquared(P.Location - (WeaponPawns[x].Location + (WeaponPawns[x].EntryPosition >> Rotation)));

        // Check if this weapon pawn is currently the closest one within range that the player can use
        if (DistSquared < ClosestDistSquared && DistSquared < Square(WeaponPawns[x].EntryRadius))
        {
            ClosestDistSquared = DistSquared;
            ClosestWeaponPawn = WeaponPawns[x];
        }
        // If not, check if this is closest 'backup' weapon pawn player could occupy (used below if vehicle itself in range but no weapon pawn in range)
        else if (ClosestWeaponPawn == none && DistSquared < BackupDistSquared)
        {
            BackupDistSquared = DistSquared;
            BackupWeaponPawn = WeaponPawns[x];
        }
    }

    // If we have a weapon pawn in range, return the closest recorded
    if (ClosestWeaponPawn != none)
    {
        return ClosestWeaponPawn;
    }
    // Or if we have a backup weapon pawn & the vehicle itself is in range, return the backup weapon pawn
    else if (BackupWeaponPawn != none && VSizeSquared(P.Location - (Location + (EntryPosition >> Rotation))) < Square(EntryRadius))
    {
        return BackupWeaponPawn;
    }
    // No valid slots in range
    else
    {
        return none;
    }
}

// Modified to check for available rider positions if player can't crew a tank, & also to prevent entry if either vehicle or player is on fire
function bool TryToDrive(Pawn P)
{
    local bool bCantEnterEnemyVehicle;
    local int  i;

    // Don't allow entry to burning vehicle (with message)
    if (bOnFire || bEngineOnFire)
    {
        DenyEntry(P, 9); // vehicle is on fire

        return false;
    }

    // Deny entry if vehicle has driver or is dead, or if player is crouching or on fire or reloading a weapon (plus several very obscure other reasons)
    if (Driver != none || Health <= 0 || P == none || (DHPawn(P) != none && DHPawn(P).bOnFire) || (P.Weapon != none && P.Weapon.IsInState('Reloading')) ||
        P.Controller == none || !P.Controller.bIsPlayer || P.DrivenVehicle != none || P.IsA('Vehicle') || bNonHumanControl || !Level.Game.CanEnterVehicle(self, P))
    {
        return false;
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
            DenyEntry(P, 1); // can't use enemy vehicle

            return false;
        }
    }

    // If vehicle can only be used by tank crew & player is not a tanker role, check if there are any available rider positions before denying entry
    if (bMustBeTankCommander && !(ROPlayerReplicationInfo(P.Controller.PlayerReplicationInfo) != none && ROPlayerReplicationInfo(P.Controller.PlayerReplicationInfo).RoleInfo != none
        && ROPlayerReplicationInfo(P.Controller.PlayerReplicationInfo).RoleInfo.bCanBeTankCrew) && P.IsHumanControlled())
    {
        // Check first to ensure riders are allowed
        if (!bAllowRiders)
        {
            DenyEntry(P, 3); // can't ride on this vehicle

            return false;
        }

        // Cycle through the available passenger positions
        for (i = FirstRiderPositionIndex; i < WeaponPawns.Length; ++i)
        {
            // If it's a passenger pawn & the position is free, then climb aboard
            if (ROPassengerPawn(WeaponPawns[i]) != none && WeaponPawns[i].Driver == none)
            {
                WeaponPawns[i].KDriverEnter(P);

                return true;
            }
        }

        DenyEntry(P, 3); // all rider positions full

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
    bDriverAlreadyEntered = true; // Matt: added here as a much simpler alternative to the Timer() in ROTreadCraft
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

// Modified to add engine start/stop hint & to enforce bDesiredBehindView = false (avoids view rotation bug)
simulated function ClientKDriverEnter(PlayerController PC)
{
    local DHPlayer P;

    bDesiredBehindView = false; // true values can exist in user.ini config file, if player exited game while in behind view in same vehicle (config values change class defaults)

    P = DHPlayer(PC);

    if (P != none)
    {
        P.QueueHint(40, true);

        if (SpawnVehicleType != class'DHSpawnManager'.default.SVT_None)
        {
            P.QueueHint(14, true);

            if (SpawnVehicleType == class'DHSpawnManager'.default.SVT_EngineOff)
            {
                P.QueueHint(15, true);
            }

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
        if (DriverPositions[InitialPositionIndex].PositionMesh != Mesh)
        {
            LinkMesh(DriverPositions[InitialPositionIndex].PositionMesh);
        }

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
// Also to play idle animation for other net clients (not just owning client) & on server if collision is animated, so we reset visuals like hatches & any moving collision boxes
// And to avoid unnecessary stuff on dedicated server & the call to Super in Vehicle class (it only duplicated)
simulated event DrivingStatusChanged()
{
    local PlayerController PC;

    if (Level.NetMode != NM_DedicatedServer)
    {
        // Not moving, so no motion sound or tread movement
        if (!bDriving)
        {
            if (LeftTreadPanner != none)
            {
                LeftTreadPanner.PanRate = 0.0;
            }

            if (RightTreadPanner != none)
            {
                RightTreadPanner.PanRate = 0.0;
            }

            MotionSoundVolume = 0.0;
            UpdateMovementSound();
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

        // Play neutral idle animation if player has exited, but not on a server unless collision is animated
        if ((Level.NetMode != NM_DedicatedServer || bPlayerCollisionBoxMoves) && HasAnim(BeginningIdleAnim))
        {
            PlayAnim(BeginningIdleAnim);
        }
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

// Modified so server goes to state ViewTransition when unbuttoning, preventing player exiting until fully unbuttoned
// Also so if player has moving collision box, server goes to state ViewTransition just to play animations
function ServerChangeViewPoint(bool bForward)
{
    if (bForward)
    {
        if (DriverPositionIndex < (DriverPositions.Length - 1))
        {
            PreviousPositionIndex = DriverPositionIndex;
            DriverPositionIndex++;

            if (Level.NetMode == NM_Standalone || Level.NetMode == NM_ListenServer)
            {
                NextViewPoint();
            }
            else if ((DriverPositionIndex == UnbuttonedPositionIndex || bPlayerCollisionBoxMoves) && Level.NetMode == NM_DedicatedServer)
            {
                GotoState('ViewTransition');
            }
        }
    }
    else
    {
        if (DriverPositionIndex > 0)
        {
            PreviousPositionIndex = DriverPositionIndex;
            DriverPositionIndex--;

            if (Level.NetMode == NM_Standalone || Level.NetMode == NM_ListenServer)
            {
                NextViewPoint();
            }
            else if (bPlayerCollisionBoxMoves && Level.NetMode == NM_DedicatedServer)
            {
                GotoState('ViewTransition');
            }
        }
    }
}

// Modified to use Sleep to control exit from state, to avoid unnecessary stuff on a server, to add handling of FOV changes & better handling of locked camera
simulated state ViewTransition
{
    simulated function HandleTransition()
    {
        if (Level.NetMode != NM_DedicatedServer)
        {
            // Switch to mesh for new position as may be different
            // Switch to mesh for new position if it's different
            if (DriverPositions[DriverPositionIndex].PositionMesh != Mesh && !bDontUsePositionMesh &&
                (Role == ROLE_AutonomousProxy || Level.NetMode == NM_Standalone || Level.NetMode == NM_ListenServer))
            {
                LinkMesh(DriverPositions[DriverPositionIndex].PositionMesh);
            }

            // If moving to a less zoomed position, we zoom out now, otherwise we wait until end of transition to zoom in
            if (DriverPositions[DriverPositionIndex].ViewFOV > DriverPositions[PreviousPositionIndex].ViewFOV && IsHumanControlled())
            {
                PlayerController(Controller).SetFOV(DriverPositions[DriverPositionIndex].ViewFOV);
            }

            // Play any transition animation for the driver
            if (Driver != none && Driver.HasAnim(DriverPositions[DriverPositionIndex].DriverTransitionAnim) && Driver.HasAnim(DriverPositions[PreviousPositionIndex].DriverTransitionAnim))
            {
                Driver.PlayAnim(DriverPositions[DriverPositionIndex].DriverTransitionAnim);
            }
        }

        ViewTransitionDuration = 0.0; // start with zero in case we don't have a transition animation

        // Play any transition animation for the vehicle itself
        // On dedicated server we only want to run this section, to set Sleep duration to control leaving state (or play button/unbutton anims if driver's collision box moves)
        if (PreviousPositionIndex < DriverPositionIndex)
        {
            if (HasAnim(DriverPositions[PreviousPositionIndex].TransitionUpAnim))
            {
                if (Level.NetMode != NM_DedicatedServer || bPlayerCollisionBoxMoves)
                {
                    PlayAnim(DriverPositions[PreviousPositionIndex].TransitionUpAnim);
                }

                ViewTransitionDuration = GetAnimDuration(DriverPositions[PreviousPositionIndex].TransitionUpAnim);
            }
        }
        else if (HasAnim(DriverPositions[PreviousPositionIndex].TransitionDownAnim))
        {
            if (Level.NetMode != NM_DedicatedServer || bPlayerCollisionBoxMoves)
            {
                PlayAnim(DriverPositions[PreviousPositionIndex].TransitionDownAnim);
            }

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
        if (Level.NetMode != NM_DedicatedServer && IsHumanControlled())
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

    // Matt: TEMP DEBUG added bBypassClientSwitchWeaponChecks
    if (Role == ROLE_Authority || bBypassClientSwitchWeaponChecks) // if we're not a net client, skip clientside checks & jump straight to the server function call
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

    // Stop call to server if player selected a rider position but is buttoned up (no 'teleporting' outside to external rider position)
    if (StopExitToRiderPosition(ChosenWeaponPawnIndex))
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

// Modified to prevent 'teleporting' outside to external rider position while buttoned up inside vehicle
function ServerChangeDriverPosition(byte F)
{
    if (!StopExitToRiderPosition(F - 2))
    {
        super.ServerChangeDriverPosition(F);
    }
}

// Modified to prevent exit if not unbuttoned & to give player the same momentum as the vehicle when exiting
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

// Modified to add a hint if player has left a deployment vehicle with the engine running (team can't spawn on it unless engine is off)
simulated function ClientKDriverLeave(PlayerController PC)
{
    if (SpawnVehicleType == class'DHSpawnManager'.default.SVT_EngineOff && !bEngineOff && DHPlayer(PC) != none)
    {
        DHPlayer(PC).QueueHint(17, true);
    }

    super.ClientKDriverLeave(PC);
}

// New function to check if player can exit, displaying an "unbutton the hatch" message if he can't (just saves repeating code in different functions)
simulated function bool CanExit()
{
    local DHVehicleMGPawn MGPawn;

    if (DriverPositionIndex < UnbuttonedPositionIndex || (IsInState('ViewTransition') && DriverPositionIndex == UnbuttonedPositionIndex))
    {
        if (DriverPositions.Length > UnbuttonedPositionIndex) // means it is possible to unbutton
        {
            ReceiveLocalizedMessage(class'DHVehicleMessage', 4,,, Controller); // must unbutton the hatch
        }
        else
        {
            if (HullMG != none)
            {
                MGPawn = DHVehicleMGPawn(HullMG.Owner);
            }

            if (MGPawn != none && MGPawn.DriverPositions.Length > MGPawn.UnbuttonedPositionIndex) // means it's possible to exit MG position
            {
                ReceiveLocalizedMessage(class'DHVehicleMessage', 11); // must exit through commander's or MG hatch
            }
            else
            {
                ReceiveLocalizedMessage(class'DHVehicleMessage', 5); // must exit through commander's hatch
            }
        }

        return false;
    }

    return true;
}

// New function to check if player is trying to 'teleport' outside to external rider position while buttoned up (just saves repeating code in different functions)
simulated function bool StopExitToRiderPosition(byte ChosenWeaponPawnIndex)
{
    return bMustUnbuttonToSwitchToRider && bAllowRiders && ChosenWeaponPawnIndex >= FirstRiderPositionIndex && ChosenWeaponPawnIndex < PassengerWeapons.Length && !CanExit();
}

// Modified to use new, simplified system with exit positions for all vehicle positions included in the vehicle class default properties
function bool PlaceExitingDriver()
{
    local int i;
    local vector Extent, HitLocation, HitNormal, ZOffset, ExitPosition;

    if (Driver == none)
    {
        return false;
    }

    Extent = Driver.GetCollisionExtent();
    ZOffset = Driver.default.CollisionHeight * vect(0.0, 0.0, 0.5);

    // Debug exits - uses DHArmoredVehicle class default, allowing bDebugExitPositions to be toggled for all DHArmoredVehicles
    if (class'DHArmoredVehicle'.default.bDebugExitPositions)
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
    if (Throttle == 0.0) // clientside check to prevent unnecessary replicated function call to server if invalid
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

            if (GRI != none && SpawnVehicleType == class'DHSpawnManager'.default.SVT_EngineOff)
            {
                if (bEngineOff)
                {
                    GRI.AddSpawnVehicle(self);
                }
                else
                {
                    GRI.RemoveSpawnVehicle(self);
                }
            }
        }
        else
        {
            PlaySound(DamagedStartUpSound, SLOT_None, 2.0);
        }
    }
}

// New function to set up the engine properties, including manual/powered turret
simulated function SetEngine()
{
    if (bEngineOff)
    {
        TurnDamping = 0.0;

        if (bOnFire || bEngineOnFire)
        {
            AmbientSound = VehicleBurningSound;
            SoundVolume = 255;
            SoundRadius = 200.0;
        }
        else if (EngineHealth <= 0)
        {
            AmbientSound = SmokingEngineSound;
            SoundVolume = 64;
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
            SoundVolume = default.SoundVolume;
            SoundRadius = default.SoundRadius;
        }

        if (!bEmittersOn)
        {
            StartEmitters();
        }
    }

    if (CannonTurret != none && DHVehicleCannonPawn(CannonTurret.Owner) != none)
    {
        DHVehicleCannonPawn(CannonTurret.Owner).SetManualTurret(bEngineOff);
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
//  ******************************** VEHICLE FIRES  ******************************** //
///////////////////////////////////////////////////////////////////////////////////////

// New function to handle starting a hull fire
function StartHullFire(Pawn InstigatedBy)
{
    bOnFire = true;

    if (bDebuggingText)
    {
        Level.Game.Broadcast(self, "Vehicle set on fire");
    }

    // Record the player responsible for starting fire, so score can be awarded later if results in a kill
    if (InstigatedBy != none)
    {
        WhoSetOnFire = InstigatedBy.Controller;
        DelayedDamageInstigatorController = WhoSetOnFire;
    }

    if (WhoSetOnFire != none)
    {
        HullFireStarterTeam = WhoSetOnFire.GetTeamNum();
    }

    // Set the 1st hull damage due in 2 seconds
    NextHullFireDamageTime = Level.TimeSeconds + 2.0;

    // Fire effects, including timers for delayed hatch fires
    if (Level.NetMode != NM_DedicatedServer)
    {
        SetFireEffects();
    }
    else
    {
        SetNextTimer(); // for damage only on server
    }
}

// New function to handle starting an engine fire
function StartEngineFire(Pawn InstigatedBy)
{
    bEngineOnFire = true;

    if (bDebuggingText)
    {
        Level.Game.Broadcast(self, "Engine set on fire");
    }

    // Record the player responsible for starting fire, so score can be awarded later if results in a kill
    if (InstigatedBy != none)
    {
        WhoSetEngineOnFire = InstigatedBy.Controller;

        if (WhoSetEngineOnFire != none)
        {
            EngineFireStarterTeam = WhoSetEngineOnFire.GetTeamNum();

            if (DelayedDamageInstigatorController == none) // don't override DDIC if already set, e.g. someone else may already have set hull on fire
            {
                DelayedDamageInstigatorController = WhoSetEngineOnFire;
            }
        }
    }

    // Set fire damage due immediately & call Timer() directly (it handles damage & setting of next due Timer)
    NextEngineFireDamageTime = Level.TimeSeconds;
    Timer();

    // Engine fire effect
    SetFireEffects();
}

// Set up for spawning various hatch fire effects, but randomise start times to desync them
simulated function SetFireEffects()
{
    if (Level.NetMode != NM_DedicatedServer)
    {
        if (bOnFire || bEngineOnFire)
        {
            // Engine fire effect
            if (DamagedEffectHealthFireFactor != 1.0)
            {
                DamagedEffectHealthFireFactor = 1.0;
                DamagedEffectHealthSmokeFactor = 1.0; // appears necessary to get native code to spawn a DamagedEffect if it doesn't already exist
                                                      // (presumably doesn't check for fire unless vehicle is at least damaged enough to smoke)

                if (DamagedEffect == none && Health == HealthMax) // clientside Health hack to get native code to spawn DamagedEffect (it won't unless vehicle has taken some damage)
                {
                    Health--;
                }
            }

            // Hatch fire effects
            if (bOnFire && !bSetHullFireEffects)
            {
                bSetHullFireEffects = true;

                // If bClientInitialized or we're an authority role (single player or listen server) then this must have been called as the fire breaks out
                // Randomise the fire effect start times (spreading from the engine forwards) & set a timer
                if (bClientInitialized || Role == ROLE_Authority)
                {
                    if (CannonTurret != none)
                    {
                        bTurretFireNeeded = true;
                        TurretHatchFireSpawnTime = Level.TimeSeconds + 2.0 + (FRand() * 3.0); // turret hatch fire starts 2-5 secs after fire starts in engine
                    }

                    bDriverHatchFireNeeded = true;
                    DriverHatchFireSpawnTime = FMax(TurretHatchFireSpawnTime, Level.TimeSeconds) + 2.0 + (FRand() * 3.0); // driver hatch fire starts 2-5 secs after turret fire

                    if (HullMG != none)
                    {
                        bHullMGFireNeeded = true;
                        HullMGHatchFireSpawnTime = DriverHatchFireSpawnTime + 1.0 + (FRand() * 2.0); // MG hatch fire starts 1-3 secs after turret fire
                    }

                    SetNextTimer();
                }
                // Otherwise this must have been called when an already burning vehicle is replicated to a net client
                // Start driver's hatch fire effect immediately, but let VehicleWeapons start their own fires as those actors replicate
                else
                {
                    StartDriverHatchFire();
                }
            }
        }
        // Engine is dead, but there's no fire, so make sure it is set to smoke instead of burn
        else if (EngineHealth <= 0 && (DamagedEffectHealthFireFactor != 0.0 || DamagedEffectHealthHeavySmokeFactor != 1.0))
        {
            DamagedEffectHealthFireFactor = 0.0;
            DamagedEffectHealthHeavySmokeFactor = 1.0;
            DamagedEffectHealthSmokeFactor = 1.0; // appears necessary to get native code to spawn a DamagedEffect if it doesn't already exist
                                                  // (presumably doesn't check for fire or dark smoke unless vehicle is at least damaged enough to lightly smoke)
            if (DamagedEffect != none)
            {
                DamagedEffect.UpdateDamagedEffect(false, 0.0, false, false); // reset existing effect
                DamagedEffect.UpdateDamagedEffect(false, 0.0, false, true);  // then set to dark smoke
            }
            else if (Health == HealthMax) // clientside Health hack to get native code to spawn DamagedEffect (it won't unless vehicle has taken some damage)
            {
                Health--;
            }
        }
    }

    // If engine is off, update sound to burning or smoking sound)
    if (bEngineOff)
    {
        SetEngine();
    }
}

// New function to start a driver's hatch fire effect
simulated function StartDriverHatchFire()
{
    bDriverHatchFireNeeded = false;

    if (DriverHatchFireEffect == none && Level.NetMode != NM_DedicatedServer)
    {
        DriverHatchFireEffect = Spawn(FireEffectClass);
    }

    if (DriverHatchFireEffect != none)
    {
        AttachToBone(DriverHatchFireEffect, FireAttachBone);
        DriverHatchFireEffect.SetRelativeLocation(FireEffectOffset);
        DriverHatchFireEffect.UpdateDamagedEffect(true, 0.0, false, false);

        if (DamagedEffectScale != 1.0)
        {
            DriverHatchFireEffect.SetEffectScale(DamagedEffectScale);
        }
    }
}

///////////////////////////////////////////////////////////////////////////////////////
//  ************************  HIT DETECTION & PENETRATION  ************************  //
///////////////////////////////////////////////////////////////////////////////////////

// New function to check if something hit a certain DH NewVehHitpoints
function bool IsNewPointShot(vector Loc, vector Ray, float AdditionalScale, int Index)
{
    local coords C;
    local vector HeadLoc, B, M, Diff;
    local float  t, DotMM, Distance;

    if (NewVehHitpoints[Index].PointBone == '')
    {
        return false;
    }

    C = GetBoneCoords(NewVehHitpoints[Index].PointBone);

    HeadLoc = C.Origin + (NewVehHitpoints[Index].PointHeight * NewVehHitpoints[Index].PointScale * AdditionalScale * C.XAxis);
    HeadLoc = HeadLoc + (NewVehHitpoints[Index].PointOffset >> rotator(C.Xaxis));

    // Express snipe trace line in terms of B + tM
    B = Loc;
    M = Ray * 150.0;

    // Find point-line squared distance
    Diff = HeadLoc - B;
    t = M dot Diff;

    if (t > 0.0)
    {
        DotMM = M dot M;

        if (t < DotMM)
        {
            t = t / DotMM;
            Diff = Diff - (t * M);
        }
        else
        {
            t = 1.0;
            Diff -= M;
        }
    }
    else
    {
        t = 0;
    }

    Distance = Sqrt(Diff dot Diff);

    return (Distance < (NewVehHitpoints[Index].PointRadius * NewVehHitpoints[Index].PointScale * AdditionalScale));
}

// Matt: new generic function to handle 'should penetrate' calcs for any shell type
// Replaces DHShouldPenetrateAPC, DHShouldPenetrateAPDS, DHShouldPenetrateHVAP, DHShouldPenetrateHVAPLarge, DHShouldPenetrateHEAT (also DO's DHShouldPenetrateAP & DHShouldPenetrateAPBC)
simulated function bool DHShouldPenetrate(DHAntiVehicleProjectile P, vector HitLocation, vector HitRotation, float PenetrationNumber)
{
    local float  HitAngleDegrees, Side, InAngle, InAngleDegrees;
    local vector LocDir, HitDir, X, Y, Z;
    local bool   bPenetrated;

    bRearHullPenetration = false; // reset before we start

    // Figure out which side we hit
    LocDir = vector(Rotation);
    LocDir.Z = 0.0;
    HitDir =  HitLocation - Location;
    HitDir.Z = 0.0;
    HitAngleDegrees = (Acos(Normal(LocDir) dot Normal(HitDir))) * 57.2957795131; // final multiplier converts the angle into degrees from radians
    GetAxes(Rotation, X, Y, Z);
    Side = Y dot HitDir;

    if (Side < 0.0)
    {
        HitAngleDegrees = 360.0 - HitAngleDegrees;
    }

    if (bPenetrationText && Role == ROLE_Authority)
    {
        Level.Game.Broadcast(self, "Hull hit angle =" @ HitAngleDegrees @ "degrees");
    }

    // Frontal hit
    if (HitAngleDegrees >= FrontLeftAngle || HitAngleDegrees < FrontRightAngle)
    {
        // Debugging
        if (bDrawPenetration)
        {
            ClearStayingDebugLines();
            DrawStayingDebugLine(HitLocation, HitLocation + 2000.0 * Normal(X), 0, 255, 0);
            DrawStayingDebugLine(HitLocation, HitLocation + 2000.0 * Normal(-HitRotation), 255, 255, 0);
            Spawn(class'DHDebugTracer', self,, HitLocation, rotator(HitRotation));
        }

        if (bLogPenetration)
        {
            Log("Front hull hit: HitAngleDegrees =" @ HitAngleDegrees @ " Side =" @ Side);
        }

        // Calculate the direction the shot came from, so we can check for possible 'hit detection bug' (opposite side collision detection error)
        InAngle = Acos(Normal(-HitRotation) dot Normal(X));
        InAngleDegrees = InAngle * 57.2957795131;

        // InAngle over 90 degrees is impossible, so it's a hit detection bug & we need to switch to opposite side
        if (InAngleDegrees > 90.0)
        {
            if (bPenetrationText && Role == ROLE_Authority)
            {
                Level.Game.Broadcast(self, "Hit bug - switching from front to REAR hull hit: base armor =" @ URearArmorFactor * 10.0 $ "mm, slope =" @ URearArmorSlope);
            }

            // Checking that PenetrationNumber > ArmorFactor 1st is a quick pre-check that it's worth doing more complex calculations in CheckPenetration()
            bPenetrated = PenetrationNumber > URearArmorFactor && CheckPenetration(P, URearArmorFactor, GetCompoundAngle(InAngle, URearArmorSlope), PenetrationNumber);
            bRearHullPenetration = bPenetrated; // record that we penetrated the rear of vehicle, which is useful in TakeDamage()

            return bPenetrated;
        }

        if (bPenetrationText && Role == ROLE_Authority)
        {
            Level.Game.Broadcast(self, "Front hull hit: base armor =" @ UFrontArmorFactor * 10.0 $ "mm, slope =" @ UFrontArmorSlope);
        }

        return PenetrationNumber > UFrontArmorFactor && CheckPenetration(P, UFrontArmorFactor, GetCompoundAngle(InAngle, UFrontArmorSlope), PenetrationNumber);
    }

    // Right side hit
    else if (HitAngleDegrees >= FrontRightAngle && HitAngleDegrees < RearRightAngle)
    {
        // Debugging
        if (bDrawPenetration)
        {
            ClearStayingDebugLines();
            DrawStayingDebugLine(HitLocation, HitLocation + 2000.0 * Normal(-Y), 0, 255, 0);
            DrawStayingDebugLine(HitLocation, HitLocation + 2000.0 * Normal(-HitRotation), 255, 255, 0);
            Spawn(class'DHDebugTracer', self,, HitLocation, rotator(HitRotation));
        }

        if (bLogPenetration)
        {
            Log("Right side hull hit: HitAngleDegrees =" @ HitAngleDegrees @ " Side =" @ Side);
        }

        // Don't penetrate with HEAT if there is added side armor
        if (bHasAddedSideArmor && P.RoundType == RT_HEAT) // using RoundType instead of P.ShellImpactDamage.default.bArmorStops
        {
            return false;
        }

        InAngle = Acos(Normal(-HitRotation) dot Normal(Y));
        InAngleDegrees = InAngle * 57.2957795131;

        // Fix hit detection bug
        if (InAngleDegrees > 90.0)
        {
            if (bPenetrationText && Role == ROLE_Authority)
            {
                Level.Game.Broadcast(self, "Hit bug - switching from right to LEFT hull hit: base armor =" @ ULeftArmorFactor * 10.0 $ "mm, slope =" @ ULeftArmorSlope);
            }

            return PenetrationNumber > ULeftArmorFactor && CheckPenetration(P, ULeftArmorFactor, GetCompoundAngle(InAngle, ULeftArmorSlope), PenetrationNumber);
        }

        if (bPenetrationText && Role == ROLE_Authority)
        {
            Level.Game.Broadcast(self, "Right hull hit: base armor =" @ URightArmorFactor * 10.0 $ "mm, slope =" @ URightArmorSlope);
        }

        return PenetrationNumber > URightArmorFactor && CheckPenetration(P, URightArmorFactor, GetCompoundAngle(InAngle, URightArmorSlope), PenetrationNumber);
    }

    // Rear hit
    else if (HitAngleDegrees >= RearRightAngle && HitAngleDegrees < RearLeftAngle)
    {
        // Debugging
        if (bDrawPenetration)
        {
            ClearStayingDebugLines();
            DrawStayingDebugLine(HitLocation, HitLocation + 2000.0 * Normal(-X), 0, 255, 0);
            DrawStayingDebugLine(HitLocation, HitLocation + 2000.0 * Normal(-HitRotation), 255, 255, 0);
            Spawn(class'DHDebugTracer', self,, HitLocation, rotator(HitRotation));
        }

        if (bLogPenetration)
        {
            Log("Rear hull hit: HitAngleDegrees =" @ HitAngleDegrees @ " Side =" @ Side);
        }

        InAngle = Acos(Normal(-HitRotation) dot Normal(-X));
        InAngleDegrees = InAngle * 57.2957795131;

        // Fix hit detection bug
        if (InAngleDegrees > 90.0)
        {
            if (bPenetrationText && Role == ROLE_Authority)
            {
                Level.Game.Broadcast(self, "Hit bug - switching from rear to FRONT hull hit: base armor =" @ UFrontArmorFactor * 10.0 $ "mm, slope =" @ UFrontArmorSlope);
            }

            return PenetrationNumber > UFrontArmorFactor && CheckPenetration(P, UFrontArmorFactor, GetCompoundAngle(InAngle, UFrontArmorSlope), PenetrationNumber);
        }

        if (bPenetrationText && Role == ROLE_Authority)
        {
            Level.Game.Broadcast(self, "Rear hull hit: base armor =" @ URearArmorFactor * 10.0 $ "mm, slope =" @ URearArmorSlope);
        }

        bPenetrated = PenetrationNumber > URearArmorFactor && CheckPenetration(P, URearArmorFactor, GetCompoundAngle(InAngle, URearArmorSlope), PenetrationNumber);
        bRearHullPenetration = bPenetrated; // record that we penetrated the rear of vehicle, which is useful in TakeDamage()

        return bPenetrated;
    }

    // Left side hit
    else if (HitAngleDegrees >= RearLeftAngle && HitAngleDegrees < FrontLeftAngle)
    {
        // Debugging
        if (bDrawPenetration)
        {
            ClearStayingDebugLines();
            DrawStayingDebugLine(HitLocation, HitLocation + 2000.0 * Normal(Y), 0, 255, 0);
            DrawStayingDebugLine(HitLocation, HitLocation + 2000.0 * Normal(-HitRotation), 255, 255, 0);
            Spawn(class'DHDebugTracer', self,, HitLocation, rotator(HitRotation));
        }

        if (bLogPenetration)
        {
            Log("Left side hull hit: HitAngleDegrees =" @ HitAngleDegrees @ " Side =" @ Side);
        }

        // Don't penetrate with HEAT if there is added side armor
        if (bHasAddedSideArmor && P.RoundType == RT_HEAT) // using RoundType instead of P.ShellImpactDamage.default.bArmorStops
        {
            return false;
        }

        InAngle = Acos(Normal(-HitRotation) dot Normal(-Y));
        InAngleDegrees = InAngle * 57.2957795131;

        // Fix hit detection bug
        if (InAngleDegrees > 90.0)
        {
            if (bPenetrationText && Role == ROLE_Authority)
            {
                Level.Game.Broadcast(self, "Hit bug - switching from left to RIGHT hull hit: base armor =" @ URightArmorFactor * 10.0 $ "mm, slope =" @ URightArmorSlope);
            }

            return PenetrationNumber > URightArmorFactor && CheckPenetration(P, URightArmorFactor, GetCompoundAngle(InAngle, URightArmorSlope), PenetrationNumber);
        }

        if (bPenetrationText && Role == ROLE_Authority)
        {
            Level.Game.Broadcast(self, "Left hull hit: base armor =" @ ULeftArmorFactor * 10.0 $ "mm, slope =" @ ULeftArmorSlope);
        }

        return PenetrationNumber > ULeftArmorFactor && CheckPenetration(P, ULeftArmorFactor, GetCompoundAngle(InAngle, ULeftArmorSlope), PenetrationNumber);
    }

    // Should never happen !
    else
    {
       Log ("?!? We shoulda hit something !!!!");
       Level.Game.Broadcast(self, "?!? We shoulda hit something !!!!");

       return false;
    }
}

// Matt: new generic function to handle penetration calcs for any shell type
// Replaces PenetrationAPC, PenetrationAPDS, PenetrationHVAP, PenetrationHVAPLarge & PenetrationHEAT (also Darkest Orchestra's PenetrationAP & PenetrationAPBC)
simulated function bool CheckPenetration(DHAntiVehicleProjectile P, float ArmorFactor, float CompoundAngle, float PenetrationNumber)
{
    local float CompoundAngleDegrees, OverMatchFactor, SlopeMultiplier, EffectiveArmor, PenetrationRatio;

    // Convert angle back to degrees
    CompoundAngleDegrees = CompoundAngle * 57.2957795131;

    if (CompoundAngleDegrees > 90.0)
    {
        CompoundAngleDegrees = 180.0 - CompoundAngleDegrees;
    }

    // Calculate the SlopeMultiplier & EffectiveArmor, to give us the PenetrationRatio
    OverMatchFactor = ArmorFactor / P.ShellDiameter;
    SlopeMultiplier = GetArmorSlopeMultiplier(P, CompoundAngleDegrees, OverMatchFactor);
    EffectiveArmor = ArmorFactor * SlopeMultiplier;
    PenetrationRatio = PenetrationNumber / EffectiveArmor;

    // Penetration debugging
    if (bPenetrationText && Role == ROLE_Authority)
    {
        Level.Game.Broadcast(self, "Effective armor:" @ EffectiveArmor * 10.0 $ "mm" @ " Shot penetration:" @ PenetrationNumber * 10.0 $ "mm");
        Level.Game.Broadcast(self, "Compound angle:" @ CompoundAngleDegrees @ " Slope multiplier:" @ SlopeMultiplier);
    }

    // Check if round shattered on armor
    P.bRoundShattered = P.bShatterProne && PenetrationRatio >= 1.0 && CheckIfShatters(P, PenetrationRatio, OverMatchFactor);

    // Check if round penetrated the vehicle
    bProjectilePenetrated = PenetrationRatio >= 1.0 && !P.bRoundShattered;

    // Set TakeDamage-related variables
    bTurretPenetration = false;
    bRearHullPenetration = bRearHullPenetration && bProjectilePenetrated;
    bHEATPenetration = P.RoundType == RT_HEAT && bProjectilePenetrated; // would be much better to flag bIsHeatRound in DamageType, but would need new DHWeaponDamageType class

    return bProjectilePenetrated;
}

// Returns the compound hit angle
simulated function float GetCompoundAngle(float AOI, float ArmorSlopeDegrees)
{
    local float ArmorSlope, CompoundAngle;

//  AOI = Abs(AOI * 0.01745329252); // now we pass AOI to this function in radians, to save unnecessary processing to & from degrees
    ArmorSlope = Abs(ArmorSlopeDegrees * 0.01745329252); // convert the angle degrees to radians
    CompoundAngle = Acos(Cos(ArmorSlope) * Cos(AOI));

    return CompoundAngle;
}

// Matt: new generic function to work with generic DHShouldPenetrate & CheckPenetration functions
simulated function float GetArmorSlopeMultiplier(DHAntiVehicleProjectile P, float CompoundAngleDegrees, optional float OverMatchFactor)
{
    local float CompoundExp, CompoundAngleFixed;
    local float RoundedDownAngleDegrees, ExtraAngleDegrees, BaseSlopeMultiplier, NextSlopeMultiplier, SlopeMultiplierGap;

    if (P.RoundType == RT_HVAP)
    {
        if (P.ShellDiameter >= 9.0) // HVAP rounds of at least 90mm shell diameter, e.g. Jackson's 90mm cannon (instead of using separate RoundType RT_HVAPLarge)
        {
            if (CompoundAngleDegrees <= 30.0)
            {
               CompoundExp = CompoundAngleDegrees ** 1.75;

               return 2.71828 ** (CompoundExp * 0.000662);
            }
            else
            {
               CompoundExp = CompoundAngleDegrees ** 2.2;

               return 0.9043 * (2.71828 ** (CompoundExp * 0.0001987));
            }
        }
        else // smaller HVAP rounds
        {
            if (CompoundAngleDegrees <= 25.0)
            {
               CompoundExp = CompoundAngleDegrees ** 2.2;

               return 2.71828 ** (CompoundExp * 0.0001727);
            }
            else
            {
               CompoundExp = CompoundAngleDegrees ** 1.5;

               return 0.7277 * (2.71828 ** (CompoundExp * 0.003787));
            }
        }
    }
    else if (P.RoundType == RT_APDS)
    {
        CompoundExp = CompoundAngleDegrees ** 2.6;

        return 2.71828 ** (CompoundExp * 0.00003011);
    }
    else if (P.RoundType == RT_HEAT)
    {
        CompoundAngleFixed = Abs(CompoundAngleDegrees * 0.01745329252); // convert angle back to radians

        return 1.0 / Cos(CompoundAngleFixed);
    }
    else // should mean RoundType is RT_APC, RT_HE or RT_Smoke, but treating this as a catch-all default (will also handle DO's AP & APBC shells)
    {
        if (CompoundAngleDegrees < 10.0)
        {
            return CompoundAngleDegrees / 10.0 * ArmorSlopeTable(P, 10.0, OverMatchFactor);
        }
        else
        {
            RoundedDownAngleDegrees = Float(Int(CompoundAngleDegrees / 5.0)) * 5.0; // to nearest 5 degrees, rounded down
            ExtraAngleDegrees = CompoundAngleDegrees - RoundedDownAngleDegrees;
            BaseSlopeMultiplier = ArmorSlopeTable(P, RoundedDownAngleDegrees, OverMatchFactor);
            NextSlopeMultiplier = ArmorSlopeTable(P, RoundedDownAngleDegrees + 5.0, OverMatchFactor);
            SlopeMultiplierGap = NextSlopeMultiplier - BaseSlopeMultiplier;

            return BaseSlopeMultiplier + (ExtraAngleDegrees / 5.0 * SlopeMultiplierGap);
        }
    }

    return 1.0; // fail-safe neutral return value
}

// Matt: new generic function to work with new GetArmorSlopeMultiplier for APC shells (also handles Darkest Orchestra's AP & APBC shells)
simulated function float ArmorSlopeTable(DHAntiVehicleProjectile P, float CompoundAngleDegrees, float OverMatchFactor)
{
    // after Bird & Livingston:
    if (P.RoundType == RT_AP) // from Darkest Orchestra
    {
        if      (CompoundAngleDegrees <= 10.0)  return 0.98  * (OverMatchFactor ** 0.0637); // at 10 degrees
        else if (CompoundAngleDegrees <= 15.0)  return 1.0  * (OverMatchFactor ** 0.0969);
        else if (CompoundAngleDegrees <= 20.0)  return 1.04  * (OverMatchFactor ** 0.13561);
        else if (CompoundAngleDegrees <= 25.0)  return 1.11  * (OverMatchFactor ** 0.16164);
        else if (CompoundAngleDegrees <= 30.0)  return 1.22  * (OverMatchFactor ** 0.19702);
        else if (CompoundAngleDegrees <= 35.0)  return 1.38  * (OverMatchFactor ** 0.22546);
        else if (CompoundAngleDegrees <= 40.0)  return 1.63  * (OverMatchFactor ** 0.26313);
        else if (CompoundAngleDegrees <= 45.0)  return 2.0  * (OverMatchFactor ** 0.34717);
        else if (CompoundAngleDegrees <= 50.0)  return 2.64  * (OverMatchFactor ** 0.57353);
        else if (CompoundAngleDegrees <= 55.0)  return 3.23  * (OverMatchFactor ** 0.69075);
        else if (CompoundAngleDegrees <= 60.0)  return 4.07  * (OverMatchFactor ** 0.81826);
        else if (CompoundAngleDegrees <= 65.0)  return 6.27  * (OverMatchFactor ** 0.9192);
        else if (CompoundAngleDegrees <= 70.0)  return 8.65  * (OverMatchFactor ** 1.00539);
        else if (CompoundAngleDegrees <= 75.0)  return 13.75 * (OverMatchFactor ** 1.074);
        else if (CompoundAngleDegrees <= 80.0)  return 21.87 * (OverMatchFactor ** 1.17973);
        else                                    return 34.49 * (OverMatchFactor ** 1.28631); // at 85 degrees
    }
    else if (P.RoundType == RT_APBC) // from Darkest Orchestra
    {
        if      (CompoundAngleDegrees <= 10.0)  return 1.04 * (OverMatchFactor ** 0.01555); // at 10 degrees
        else if (CompoundAngleDegrees <= 15.0)  return 1.06 * (OverMatchFactor ** 0.02315);
        else if (CompoundAngleDegrees <= 20.0)  return 1.08 * (OverMatchFactor ** 0.03448);
        else if (CompoundAngleDegrees <= 25.0)  return 1.11 * (OverMatchFactor ** 0.05134);
        else if (CompoundAngleDegrees <= 30.0)  return 1.16 * (OverMatchFactor ** 0.0771);
        else if (CompoundAngleDegrees <= 35.0)  return 1.22 * (OverMatchFactor ** 0.11384);
        else if (CompoundAngleDegrees <= 40.0)  return 1.31 * (OverMatchFactor ** 0.16952);
        else if (CompoundAngleDegrees <= 45.0)  return 1.44 * (OverMatchFactor ** 0.24604);
        else if (CompoundAngleDegrees <= 50.0)  return 1.68 * (OverMatchFactor ** 0.3791);
        else if (CompoundAngleDegrees <= 55.0)  return 2.11 * (OverMatchFactor ** 0.56444);
        else if (CompoundAngleDegrees <= 60.0)  return 3.5 * (OverMatchFactor ** 1.07411);
        else if (CompoundAngleDegrees <= 65.0)  return 5.34 * (OverMatchFactor ** 1.46188);
        else if (CompoundAngleDegrees <= 70.0)  return 9.48 * (OverMatchFactor ** 1.8152);
        else if (CompoundAngleDegrees <= 75.0)  return 20.22 * (OverMatchFactor ** 2.19155);
        else if (CompoundAngleDegrees <= 80.0)  return 56.2 * (OverMatchFactor ** 2.5621);
        else                                    return 221.3 * (OverMatchFactor ** 2.93265); // at 85 degrees
    }
    else // should mean RoundType is RT_APC (also covers APCBC) or RT_HE, but treating this as a catch-all default
    {
        if      (CompoundAngleDegrees <= 10.0)  return 1.01  * (OverMatchFactor ** 0.0225); // at 10 degrees
        else if (CompoundAngleDegrees <= 15.0)  return 1.03  * (OverMatchFactor ** 0.0327);
        else if (CompoundAngleDegrees <= 20.0)  return 1.1  * (OverMatchFactor ** 0.0454);
        else if (CompoundAngleDegrees <= 25.0)  return 1.17  * (OverMatchFactor ** 0.0549);
        else if (CompoundAngleDegrees <= 30.0)  return 1.27  * (OverMatchFactor ** 0.0655);
        else if (CompoundAngleDegrees <= 35.0)  return 1.39  * (OverMatchFactor ** 0.0993);
        else if (CompoundAngleDegrees <= 40.0)  return 1.54  * (OverMatchFactor ** 0.1388);
        else if (CompoundAngleDegrees <= 45.0)  return 1.72  * (OverMatchFactor ** 0.1655);
        else if (CompoundAngleDegrees <= 50.0)  return 1.94  * (OverMatchFactor ** 0.2035);
        else if (CompoundAngleDegrees <= 55.0)  return 2.12  * (OverMatchFactor ** 0.2427);
        else if (CompoundAngleDegrees <= 60.0)  return 2.56  * (OverMatchFactor ** 0.245);
        else if (CompoundAngleDegrees <= 65.0)  return 3.2  * (OverMatchFactor ** 0.3354);
        else if (CompoundAngleDegrees <= 70.0)  return 3.98  * (OverMatchFactor ** 0.3478);
        else if (CompoundAngleDegrees <= 75.0)  return 5.17  * (OverMatchFactor ** 0.3831);
        else if (CompoundAngleDegrees <= 80.0)  return 8.09  * (OverMatchFactor ** 0.4131);
        else                                    return 11.32 * (OverMatchFactor ** 0.455); // at 85 degrees
    }

    return 1.0; // fail-safe neutral return value
}

// Matt: new generic function to work with new CheckPenetration function - checks if the round should shatter, based on the 'shatter gap' for different round types
simulated function bool CheckIfShatters(DHAntiVehicleProjectile P, float PenetrationRatio, optional float OverMatchFactor)
{
    if (P.RoundType == RT_HVAP)
    {
        if (P.ShellDiameter >= 9.0) // HVAP rounds of at least 90mm shell diameter, e.g. Jackson's 90mm cannon (instead of using separate RoundType RT_HVAPLarge)
        {
            if (PenetrationRatio >= 1.1 && PenetrationRatio <= 1.27)
            {
                return true;
            }
        }
        else // smaller HVAP rounds
        {
            if (PenetrationRatio >= 1.1 && PenetrationRatio <= 1.34)
            {
                return true;
            }
        }
    }
    else if (P.RoundType == RT_APDS)
    {
        if (PenetrationRatio >= 1.06 && PenetrationRatio <= 1.2)
        {
            return true;
        }
    }
    else if (P.RoundType == RT_HEAT) // no chance of shatter for HEAT round
    {
    }
    else // should mean RoundType is RT_APC, RT_HE or RT_Smoke, but treating this as a catch-all default (will also handle DO's AP & APBC shells)
    {
        if (OverMatchFactor > 0.8 && PenetrationRatio >= 1.06 && PenetrationRatio <= 1.19)
        {
            return true;
        }
    }

    return false;
}

///////////////////////////////////////////////////////////////////////////////////////
//  *********************************  DAMAGE  ************************************  //
///////////////////////////////////////////////////////////////////////////////////////

// Modified to add all the DH vehicle damage stuff
function TakeDamage(int Damage, Pawn InstigatedBy, vector HitLocation, vector Momentum, class<DamageType> DamageType, optional int HitIndex)
{
    local DHVehicleCannonPawn CannonPawn;
    local Controller InstigatorController;
    local vector     HitDir, LocDir, X, Y, Z;
    local float      VehicleDamageMod, TreadDamageMod, HitCheckDistance, HullChanceModifier, TurretChanceModifier, InAngle, HitAngleDegrees, Side; // HitHeight
    local int        InstigatorTeam, PossibleDriverDamage, i;
    local bool       bHitDriver, bEngineStoppedProjectile, bAmmoDetonation;

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
    if (InstigatedBy == self && DamageType != VehicleBurningDamType)
    {
        ResetTakeDamageVariables();

        return;
    }

    // Don't allow your own teammates to destroy vehicles in spawns (& you know some jerks would get off on doing that to their team :))
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
                ResetTakeDamageVariables();

                return;
            }
        }
    }

    // Set damage modifiers from the DamageType
    if (class<ROWeaponDamageType>(DamageType) != none)
    {
        VehicleDamageMod = class<ROWeaponDamageType>(DamageType).default.TankDamageModifier;
        TreadDamageMod = class<ROWeaponDamageType>(DamageType).default.TreadDamageModifier;
    }
    else if (class<ROVehicleDamageType>(DamageType) != none)
    {
        VehicleDamageMod = class<ROVehicleDamageType>(DamageType).default.TankDamageModifier;
        TreadDamageMod = class<ROVehicleDamageType>(DamageType).default.TreadDamageModifier;
    }

    // Add in the DamageType's vehicle damage modifier & a little damage randomisation (but not for fire damage as it messes up timings)
    if (DamageType != VehicleBurningDamType)
    {
        Damage *= RandRange(0.75, 1.08);
    }

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
                // Non-penetrating rounds have a limited HitCheckDistance
                // For penetrating rounds, HitCheckDistance will remain default zero, meaning no limit on check distance in IsPointShot()
                if (!bProjectilePenetrated)
                {
                    HitCheckDistance = DriverHitCheckDist;
                }

                if (IsPointShot(Hitlocation,Momentum, 1.0, i, HitCheckDistance))
                {
                    Driver.TakeDamage(PossibleDriverDamage, InstigatedBy, Hitlocation, Momentum, DamageType);
                    bHitDriver = true; // stops any possibility of multiple damage to driver by same projectile if there's more than 1 driver hit point (e.g. head & torso)
                }
            }
        }
        else if (bProjectilePenetrated && Damage > 0 && IsPointShot(Hitlocation, Momentum, 1.0, i))
        {
            if (bLogPenetration)
            {
                Log("We hit" @ GetEnum(enum'EHitPointType', VehHitpoints[i].HitPointType) @ "hitpoint");
            }

            // Engine hit
            if (VehHitpoints[i].HitPointType == HP_Engine)
            {
                if (bDebuggingText)
                {
                    Level.Game.Broadcast(self, "Hit vehicle engine");
                }

                DamageEngine(Damage, InstigatedBy, Hitlocation, Momentum, DamageType);
                Damage *= 0.55; // reduce damage to vehicle itself if hit engine

                // Shot from the rear that hits engine will stop shell from passing through to cabin, so don't check any more VehHitPoints
                if (bRearHullPenetration)
                {
                    bEngineStoppedProjectile = true;
                    break;
                }
            }
            // Hit ammo store
            else if (VehHitpoints[i].HitPointType == HP_AmmoStore)
            {
                // Random chance that ammo explodes & vehicle is destroyed
                if ((bHEATPenetration && FRand() < 0.85) || (!bHEATPenetration && FRand() < AmmoIgnitionProbability))
                {
                    if (bDebuggingText)
                    {
                        Level.Game.Broadcast(self, "Hit vehicle ammo store - exploded");
                    }

                    Damage *= Health;
                    bAmmoDetonation = true; // stops unnecessary penetration checks, as the vehicle is going to explode anyway
                    break;
                }
                // Even if ammo did not explode, increase the chance of a fire breaking out
                else
                {
                    if (bDebuggingText)
                    {
                        Level.Game.Broadcast(self, "Hit vehicle ammo store but did not explode");
                    }

                    HullFireChance = FMax(0.75, HullFireChance);
                    HullFireHEATChance = FMax(0.90, HullFireHEATChance);
                }
            }
        }
    }

    if (!bEngineStoppedProjectile && !bAmmoDetonation) // we can skip lots of checks if either has been flagged true
    {
        if (WeaponPawns.Length > 0)
        {
            CannonPawn = DHVehicleCannonPawn(WeaponPawns[0]);
        }

        // Check additional DH NewVehHitPoints
        for (i = 0; i < NewVehHitpoints.Length; ++i)
        {
            if (IsNewPointShot(Hitlocation,Momentum, 1.0, i))
            {
                if (bLogPenetration)
                {
                    Log("We hit" @ GetEnum(enum'ENewHitPointType', NewVehHitpoints[i].NewHitPointType) @ "hitpoint");
                }

                // Hit periscope optics
                if (NewVehHitpoints[i].NewHitPointType == NHP_PeriscopeOptics)
                {
                    // does nothing at present - possibly add in future
                }
                else if (CannonPawn != none)
                {
                    // Hit exposed gunsight optics
                    if (NewVehHitpoints[i].NewHitPointType == NHP_GunOptics)
                    {
                        if (bDebuggingText)
                        {
                            Level.Game.Broadcast(self, "Hit gunsight optics");
                        }

                        CannonPawn.DamageCannonOverlay();
                    }
                    else if (bProjectilePenetrated)
                    {
                        // Hit turret ring or gun traverse mechanism
                        if (NewVehHitpoints[i].NewHitPointType == NHP_Traverse)
                        {
                            if (bDebuggingText)
                            {
                                Level.Game.Broadcast(self, "Hit gun/turret traverse");
                            }

                            CannonPawn.bTurretRingDamaged = true;
                        }
                        // Hit gun pivot mechanism
                        else if (NewVehHitpoints[i].NewHitPointType == NHP_GunPitch)
                        {
                            if (bDebuggingText)
                            {
                                Level.Game.Broadcast(self, "Hit gun pivot");
                            }

                            CannonPawn.bGunPivotDamaged = true;
                        }
                    }
                }
            }
        }

        // Random damage to crew or vehicle components, caused by shrapnel etc flying around inside the vehicle from penetration, regardless of where it hit
        if (bProjectilePenetrated)
        {
            // Although shrapnel etc can get everywhere, modify chance of random damage based on whether penetration was to hull or turret
            if (CannonPawn != none && CannonPawn.Cannon != none && CannonPawn.Cannon.bHasTurret)
            {
                if (bTurretPenetration)
                {
                    HullChanceModifier = 0.5;   // half usual chance of damage to things in the hull
                    TurretChanceModifier = 1.0;
                }
                else
                {
                    HullChanceModifier = 1.0;
                    TurretChanceModifier = 0.5; // half usual chance of damage to things in the turret
                }
            }
            else // normal chance of damage to everything in vehicles without a turret (e.g. casemate-style tank destroyers)
            {
                HullChanceModifier = 1.0;
                TurretChanceModifier = 1.0;
            }

            if (CannonPawn != none)
            {
                // Random chance of shrapnel killing commander
                if (CannonPawn.Driver != none && FRand() < (Float(Damage) / CommanderKillChance * TurretChanceModifier))
                {
                    if (bDebuggingText)
                    {
                        Level.Game.Broadcast(self, "Commander killed by shrapnel");
                    }

                    CannonPawn.Driver.TakeDamage(150, InstigatedBy, Location, vect(0.0, 0.0, 0.0), DamageType);
                }

                // Random chance of shrapnel damaging gunsight optics
                if (FRand() < (Float(Damage) / OpticsDamageChance * TurretChanceModifier))
                {
                    if (bDebuggingText)
                    {
                        Level.Game.Broadcast(self, "Gunsight optics destroyed by shrapnel");
                    }

                    CannonPawn.DamageCannonOverlay();
                }

                // Random chance of shrapnel damaging gun pivot mechanism
                if (FRand() < (Float(Damage) / GunDamageChance * TurretChanceModifier))
                {
                    if (bDebuggingText)
                    {
                        Level.Game.Broadcast(self, "Gun pivot damaged by shrapnel");
                    }

                    CannonPawn.bGunPivotDamaged = true;
                }

                // Random chance of shrapnel damaging gun traverse mechanism
                if (FRand() < (Float(Damage) / TraverseDamageChance * TurretChanceModifier))
                {
                    if (bDebuggingText)
                    {
                        Level.Game.Broadcast(self, "Gun/turret traverse damaged by shrapnel");
                    }

                    CannonPawn.bTurretRingDamaged = true;
                }
            }

            // Random chance of shrapnel detonating turret ammo & destroying the vehicle
            if (FRand() < (Float(Damage) / TurretDetonationThreshold * TurretChanceModifier))
            {
                if (bDebuggingText)
                {
                    Level.Game.Broadcast(self, "Turret ammo detonated by shrapnel");
                }

                Damage *= Health;
                bAmmoDetonation = true; // stops unnecessary penetration checks, as the vehicle is going to explode anyway
            }
            else if (bTurretPenetration)
            {
                Damage *= 0.55; // reduce damage to vehicle itself from a turret hit, if the turret ammo didn't detonate
            }

            // Random chance of shrapnel killing driver
            if (Driver != none && FRand() < (Float(Damage) / DriverKillChance * HullChanceModifier))
            {
                if (bDebuggingText)
                {
                    Level.Game.Broadcast(self, "Driver killed by shrapnel");
                }

                Driver.TakeDamage(150, InstigatedBy, Location, vect(0.0, 0.0, 0.0), DamageType);
            }

            // Random chance of shrapnel killing hull machine gunner
            if (HullMG != none && Vehicle(HullMG.Owner) != none && Vehicle(HullMG.Owner).Driver != none && FRand() < (Float(Damage) / GunnerKillChance * HullChanceModifier))
            {
                if (bDebuggingText)
                {
                    Level.Game.Broadcast(self, "Hull gunner killed by shrapnel");
                }

                Vehicle(HullMG.Owner).Driver.TakeDamage(150, InstigatedBy, Location, vect(0.0, 0.0, 0.0), DamageType);
            }
        }

    // Matt UK May 2015: in future I intend to add a modified method for track hit detection that works properly, with the changes shown commented out below
    // Problem with original RO method above is the InAngle calculation is distorted by the position of the hit along the vehicle mesh's X axis
    // My new method is simpler & works, producing consistent results along the length of the hull
    // To implement it needs each tracked vehicle to have TreadHitMaxHeight set, being the height (in Unreal units) of the top of the tracks above the hull mesh origin
    // I don't have time to do this for the 6.0 release, so will add later

        // Check if we hit & damaged either track
        if (TreadDamageMod >= TreadDamageThreshold && !bTurretPenetration && !bRearHullPenetration)
        {
            // Calculate height of HitLocation is in relation to hull mesh origin, expressed as an angle in radians
            HitDir =  Hitlocation - Location;
            GetAxes(Rotation, X, Y, Z);
            InAngle = Acos(Normal(HitDir) dot Normal(Z));

            // Calculate height of hit above/below hull mesh origin, having applied hull's rotation // NEW METHOD FOR LATER, replacing 3 lines above
//          HitDir =  Hitlocation - Location;
//          HitHeight = (HitDir << Rotation).Z;

            // We hit low enough to possibly hit one of the tracks
            if (InAngle > TreadHitMinAngle)
//          if (HitHeight <= TreadHitMaxHeight) // NEW METHOD FOR LATER, replacing 'if' line above
            {
                // Now figure out which side of the vehicle we hit
                LocDir = vector(Rotation);
                LocDir.Z = 0.0;
                HitDir.Z = 0.0;
                HitAngleDegrees = (Acos(Normal(LocDir) dot Normal(HitDir))) * 57.2957795131; // final multiplier converts the angle into degrees from radians
//              GetAxes(Rotation, X, Y, Z); // NEW METHOD FOR LATER, moved down here from further up
                Side = Y dot HitDir;

                if (Side < 0.0)
                {
                    HitAngleDegrees = 360.0 - HitAngleDegrees;
                }

                // Right track hit
                if (HitAngleDegrees >= FrontRightAngle && HitAngleDegrees < RearRightAngle)
                {
                    // Calculate the direction the shot came from, so we can check for possible 'hit detection bug' (opposite side collision detection error)
                    InAngle = Acos(Normal(-Momentum) dot Normal(Y)) * 57.2957795131;

                    // InAngle over 90 degrees is impossible, so it's a hit detection bug & we need to switch to left side (same as in DHShouldPenetrate)
                    if (InAngle > 90.0)
                    {
                        if (!bLeftTrackDamaged)
                        {
                            DamageTrack(true);

                            if (bDebugTreadText && Role == ROLE_Authority)
                            {
                                Level.Game.Broadcast(self, "Hit bug: switching from right to LEFT track damaged"); // (HitHeight =" @ HitHeight $ ")");
                            }
                        }
                    }
                    // Otherwise it's a valid hit on the right track
                    else if (!bRightTrackDamaged)
                    {
                        DamageTrack(false);

                        if (bDebugTreadText && Role == ROLE_Authority)
                        {
                            Level.Game.Broadcast(self, "Right track damaged"); // (HitHeight =" @ HitHeight $ ")"); // NEW METHOD FOR LATER - add extra debug detail
                        }
                    }
                }
                // Left track hit
                else if (HitAngleDegrees >= RearLeftAngle && HitAngleDegrees < FrontLeftAngle)
                {
                    InAngle = Acos(Normal(-Momentum) dot Normal(-Y)) * 57.2957795131;

                    // InAngle over 90 degrees is impossible, so it's a hit detection bug & we need to switch to right side
                    if (InAngle > 90.0)
                    {
                        if (!bRightTrackDamaged)
                        {
                            DamageTrack(false);

                            if (bDebugTreadText && Role == ROLE_Authority)
                            {
                                Level.Game.Broadcast(self, "Hit bug: switching from left to RIGHT track damaged"); // (HitHeight =" @ HitHeight $ ")");
                            }
                        }
                    }
                    // Otherwise it's a valid hit on the left track
                    else if (!bLeftTrackDamaged)
                    {
                        DamageTrack(true);

                        if (bDebugTreadText && Role == ROLE_Authority)
                        {
                            Level.Game.Broadcast(self, "Left track damaged"); // (HitHeight =" @ HitHeight $ ")");
                        }
                    }
                }
            }
        }
    }

    // Call the Super from Vehicle (skip over others)
    super(Vehicle).TakeDamage(Damage, InstigatedBy, Hitlocation, Momentum, DamageType);

    // Vehicle is still alive, so check for possibility of a penetration causing hull fire to break out
    if (bProjectilePenetrated && !bOnFire && Damage > 0 && Health > 0)
    {
        // Random chance of hull fire breaking out
        if (!bEngineStoppedProjectile && ((bHEATPenetration && FRand() < HullFireHEATChance) || (!bHEATPenetration && FRand() < HullFireChance)))
        {
            StartHullFire(InstigatedBy);
        }
        // If we didn't start a fire & this is the 1st time a projectile has penetrated, increase the chance of causing a hull fire for any future penetrations
        else if (bFirstPenetratingHit)
        {
            bFirstPenetratingHit = false;
            HullFireChance = FMax(0.75, HullFireChance);
            HullFireHEATChance = FMax(0.90, HullFireHEATChance);
        }
    }

    ResetTakeDamageVariables();
}

// New function to reset all variables used in TakeDamage, ready for next time
function ResetTakeDamageVariables()
{
    bProjectilePenetrated = false;
    bTurretPenetration = false;
    bRearHullPenetration = false;
    bHEATPenetration = false;
}

// Modified to to kill engine if zero health & to add random chance of engine fire breaking out
function DamageEngine(int Damage, Pawn InstigatedBy, vector HitLocation, vector Momentum, class<DamageType> DamageType)
{
    // Apply new damage
    if (EngineHealth > 0)
    {
        if (DamageType != VehicleBurningDamType)
        {
            Damage = Level.Game.ReduceDamage(Damage, self, InstigatedBy, HitLocation, Momentum, DamageType);
        }

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
    // Or if engine still alive, a random chance of engine fire breaking out
    else if (DamageType != VehicleBurningDamType && !bEngineOnFire && Damage > 0 && Health > 0)
    {
        if ((bHEATPenetration && FRand() < EngineFireHEATChance) || (!bHEATPenetration && FRand() < EngineFireChance))
        {
            if (bDebuggingText)
            {
                Level.Game.Broadcast(self, "Engine fire started");
            }

            StartEngineFire(InstigatedBy);
        }
    }
}

// New function to handle hull fire damage
function TakeFireDamage()
{
    local Pawn PawnWhoSetOnFire;
    local int  i;

    if (Role == ROLE_Authority)
    {
        if (WhoSetOnFire != none)
        {
            // If the instigator gets teamswapped before a burning tank dies, make sure they don't get friendly kills for it
            if (WhoSetOnFire.GetTeamNum() != HullFireStarterTeam)
            {
                WhoSetOnFire = none;
                DelayedDamageInstigatorController = none;
            }
            else
            {
                PawnWhoSetOnFire = WhoSetOnFire.Pawn;
            }
        }

        // Burn the driver
        if (Driver != none)
        {
            Driver.TakeDamage(PlayerFireDamagePer2Secs, PawnWhoSetOnFire, Location, vect(0.0, 0.0, 0.0), VehicleBurningDamType);
        }

        // Burn any other vehicle occupants
        for (i = 0; i < WeaponPawns.Length; ++i)
        {
            if (WeaponPawns[i] != none && WeaponPawns[i].Driver != none)
            {
                WeaponPawns[i].Driver.TakeDamage(PlayerFireDamagePer2Secs, PawnWhoSetOnFire, Location, vect(0.0, 0.0, 0.0), VehicleBurningDamType);
            }
        }

        // Chance of cooking off ammo before health runs out
        if (FRand() < FireDetonationChance)
        {
            if (bDebuggingText)
            {
                Level.Game.Broadcast(self, "Fire detonated ammo");
            }

            TakeDamage(Health, PawnWhoSetOnFire, vect(0.0, 0.0, 0.0), vect(0.0, 0.0, 0.0), VehicleBurningDamType);
        }
        // Otherwise the vehicle takes normal fire damage
        else
        {
            TakeDamage(HullFireDamagePer2Secs, PawnWhoSetOnFire, vect(0.0, 0.0, 0.0), vect(0.0, 0.0, 0.0), VehicleBurningDamType);
        }

        // Set next hull damage due in another 2 seconds, unless vehicle is now dead
        if (Health > 0)
        {
            NextHullFireDamageTime += 2.0;
        }
    }
}

// New function to handle engine fire damage
function TakeEngineFireDamage()
{
    local Pawn PawnWhoSetOnFire;

    if (Role == ROLE_Authority)
    {
        // Damage engine if not already dead
        if (EngineHealth > 0)
        {
            if (WhoSetEngineOnFire != none)
            {
                // If the instigator gets teamswapped before a burning tank dies, make sure they don't get friendly kills for it
                if (WhoSetEngineOnFire.GetTeamNum() != EngineFireStarterTeam)
                {
                    WhoSetEngineOnFire = none;
                    DelayedDamageInstigatorController = none;
                }
                else
                {
                    PawnWhoSetOnFire = WhoSetEngineOnFire.Pawn;
                }
            }

            DamageEngine(EngineFireDamagePer3Secs, PawnWhoSetOnFire, vect(0.0, 0.0, 0.0), vect(0.0, 0.0, 0.0), VehicleBurningDamType);

            // Small chance each time of engine fire spreading & setting whole tank on fire
            if (!bOnFire && FRand() < EngineToHullFireChance)
            {
                StartHullFire(PawnWhoSetOnFire);
            }

            // Engine not dead, so set next engine damage due in the normal 3 seconds
            if (EngineHealth > 0)
            {
                NextEngineFireDamageTime += 3.0;
            }
            // Engine is dead, but use NextEngineFireDamageTime to set next timer so engine fire dies down 30 secs after engine health hits zero (unless hull has caught fire)
            else if (!bOnFire)
            {
                NextEngineFireDamageTime += 30.0;
            }
        }
        // Engine fire dies down 30 seconds after engine health hits zero, unless hull has caught fire
        else if (!bOnFire)
        {
            bEngineOnFire = false;
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

// Modified so will pass radius damage on to each VehicleWeaponPawn, as originally lack of vehicle driver caused early exit
function DriverRadiusDamage(float DamageAmount, float DamageRadius, Controller EventInstigator, class<DamageType> DamageType, float Momentum, vector HitLocation)
{
    local vector Direction;
    local float  DamageScale, Distance;
    local int    i;

    // Damage the driver (but not if he has collision as whatever is causing the radius damage will hit the driver by itself)
    if (Driver != none && !Driver.bCollideActors && DriverPositions[DriverPositionIndex].bExposed && EventInstigator != none && !bRemoteControlled)
    {
        Direction = Driver.Location - HitLocation;
        Distance = FMax(1.0, VSize(Direction));
        Direction = Direction / Distance;
        DamageScale = 1.0 - FMax(0.0, (Distance - Driver.CollisionRadius) / DamageRadius);

        if (DamageScale > 0.0)
        {
            Driver.SetDelayedDamageInstigatorController(EventInstigator);

            Driver.TakeDamage(DamageScale * DamageAmount, EventInstigator.Pawn, Driver.Location - (0.5 * (Driver.CollisionHeight + Driver.CollisionRadius)) * Direction,
                DamageScale * Momentum * Direction, DamageType);
        }
    }

    // Pass DriverRadiusDamage on to each VehicleWeaponPawn (but not if it has collision as whatever is causing the radius damage will hit the VWP by itself)
    for (i = 0; i < WeaponPawns.Length; ++i)
    {
        if (!WeaponPawns[i].bCollideActors)
        {
            WeaponPawns[i].DriverRadiusDamage(DamageAmount, DamageRadius, EventInstigator, DamageType, Momentum, HitLocation);
        }
    }
}

// Modified to randomise explosion damage & radius and to add a DestroyedBurningSound
function VehicleExplosion(vector MomentumNormal, float PercentMomentum)
{
    local vector LinearImpulse, AngularImpulse;
    local float  RandomExplModifier;

    RandomExplModifier = FRand();
    HurtRadius(ExplosionDamage * RandomExplModifier, ExplosionRadius * RandomExplModifier, ExplosionDamageType, ExplosionMomentum, Location);

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

    L.AddPrecacheMaterial(default.VehicleHudImage);
    L.AddPrecacheMaterial(default.MPHMeterMaterial);
    L.AddPrecacheMaterial(default.DamagedTreadPanner);
    L.AddPrecacheMaterial(default.PeriscopeOverlay);
    L.AddPrecacheMaterial(default.DamagedPeriscopeOverlay);

    if (default.HighDetailOverlay != none)
    {
        L.AddPrecacheMaterial(default.HighDetailOverlay);
    }

    if (default.SchurzenTexture != none)
    {
        L.AddPrecacheMaterial(default.SchurzenTexture);
    }

    if (default.DestroyedVehicleMesh != none)
    {
        L.AddPrecacheStaticMesh(default.DestroyedVehicleMesh);
    }
}

// Modified to removes all literal material references, so they aren't repeated again & again - instead they are pre-cached once in DarkestHourGame.PrecacheGameTextures()
// Also to add extra material properties & remove obsolete stuff
simulated function UpdatePrecacheMaterials()
{
    super(Actor).UpdatePrecacheMaterials(); // pre-caches the Skins array

    Level.AddPrecacheMaterial(VehicleHudImage);
    Level.AddPrecacheMaterial(MPHMeterMaterial);
    Level.AddPrecacheMaterial(DamagedTreadPanner);
    Level.AddPrecacheMaterial(PeriscopeOverlay);
    Level.AddPrecacheMaterial(DamagedPeriscopeOverlay);

    if (HighDetailOverlay != none)
    {
        Level.AddPrecacheMaterial(HighDetailOverlay);
    }

    if (SchurzenTexture != none)
    {
        Level.AddPrecacheMaterial(SchurzenTexture);
    }

    if (DestroyedVehicleMesh != none)
    {
        Level.AddPrecacheStaticMesh(DestroyedVehicleMesh);
    }
}

// Modified to optimise & to avoid accessed none errors
// Also, for HullMG it looks for any VehicleWeapon that is flagged bIsMountedTankMG, instead of specifically a ROMountedTankMG, so more generic
simulated function UpdateTurretReferences()
{
    local int i;

    for (i = 0; i < WeaponPawns.Length; ++i)
    {
        if (WeaponPawns[i] != none && WeaponPawns[i].Gun != none)
        {
            if (CannonTurret == none && WeaponPawns[i].Gun.IsA('ROTankCannon'))
            {
                CannonTurret = ROTankCannon(WeaponPawns[i].Gun);
            }
            else if (HullMG == none && ROVehicleWeapon(WeaponPawns[i].Gun) != none && ROVehicleWeapon(WeaponPawns[i].Gun).bIsMountedTankMG)
            {
                HullMG = WeaponPawns[i].Gun;
            }

            if (CannonTurret != none && HullMG != none)
            {
                break;
            }
        }
    }
}

// Modified to replace literal for pan direction, so can be easily subclassed, & to incorporate extra tread sounds that were spawned in PostBeginPlay()
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
        LeftTreadSoundAttach = Spawn(class'ROSoundAttachment');
        LeftTreadSoundAttach.AmbientSound = LeftTreadSound;
        LeftTreadSoundAttach.SoundRadius = SoundRadius;
        LeftTreadSoundAttach.TransientSoundRadius = TransientSoundRadius;
        AttachToBone(LeftTreadSoundAttach, LeftTrackSoundBone);
    }

    if (RightTreadSound != none && RightTrackSoundBone != '' && RightTreadSoundAttach == none)
    {
        RightTreadSoundAttach = Spawn(class'ROSoundAttachment');
        RightTreadSoundAttach.AmbientSound = RightTreadSound;
        RightTreadSoundAttach.SoundRadius = SoundRadius;
        RightTreadSoundAttach.TransientSoundRadius = TransientSoundRadius;
        AttachToBone(RightTreadSoundAttach, RightTrackSoundBone);
    }
}

// New function to set up damaged tracks
simulated function SetDamagedTracks()
{
    if (Level.NetMode == NM_DedicatedServer)
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
        if (DamagedTrackLeftClass != none && DamagedTrackLeft == none)
        {
            DamagedTrackLeft = Spawn(DamagedTrackLeftClass);
            DamagedTrackLeft.Skins[0] = default.Skins[LeftTreadIndex]; // sets damaged tread skin to match treads for this tank (i.e. whether normal or snowy)
            AttachToBone(DamagedTrackLeft, 'Body');
        }
    }

    if (bRightTrackDamaged)
    {
        Skins[RightTreadIndex] = DamagedTreadPanner;

        if (RightTreadSoundAttach != none)
        {
            RightTreadSoundAttach.AmbientSound = TrackDamagedSound;
        }

        if (DamagedTrackRightClass != none && DamagedTrackRight == none)
        {
            DamagedTrackRight = Spawn(DamagedTrackRightClass);
            DamagedTrackRight.Skins[0] = default.Skins[RightTreadIndex];
            AttachToBone(DamagedTrackRight, 'Body');
        }
    }
}

// Modified to include damaged tracks in the MotionSoundVolume update - and make them a bit louder than undamaged tracks
simulated function UpdateMovementSound()
{
    if (LeftTreadSoundAttach != none)
    {
        LeftTreadSoundAttach.SoundVolume = MotionSoundVolume;
    }

    if (RightTreadSoundAttach != none)
    {
        RightTreadSoundAttach.SoundVolume = MotionSoundVolume;
    }

    if (InteriorRumbleSoundAttach != none)
    {
        InteriorRumbleSoundAttach.SoundVolume = MotionSoundVolume;
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
    if (Level.NetMode != NM_DedicatedServer)
    {
        DestroyTreads();

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

        if (InteriorRumbleSoundAttach != none)
        {
            InteriorRumbleSoundAttach.Destroy();
        }

        if (DriverHatchFireEffect != none)
        {
            DriverHatchFireEffect.Kill();
        }

        if (Schurzen != none)
        {
            Schurzen.Destroy();
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

// Modified to stop vehicle from prematurely destroying itself when on fire & to include setting ResetTime for an empty vehicle away from its spawn (moved from DriverLeft)
function MaybeDestroyVehicle()
{
    if (!bNeverReset && IsVehicleEmpty())
    {
        if (IsDisabled() && !bOnFire && !bEngineOnFire)
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
    foreach CollidingActors(class'Pawn', P, 4000.0)
    {
        if (P != self && P.Controller != none && P.GetTeamNum() == GetTeamNum()) // traces only work on friendly players nearby
        {
            if (ROPawn(P) != none && (VSizeSquared(P.Location - Location) < DriverTraceDistSquared)) // changed so compare squared values, as VSizeSquared is more efficient
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
        ObjectCrushed(2.0);
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

        PlayerController(User.Controller).ReceiveLocalizedMessage(TouchMessageClass, 0,,, NotifyParameters);

        LastNotifyTime = Level.TimeSeconds;
    }
}

// Modified to require both tracks to be damaged to class as disabled, not just one
simulated function bool IsDisabled()
{
    return (EngineHealth <= 0 || (bLeftTrackDamaged && bRightTrackDamaged));
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

        LinkMesh(DriverPositions[DriverPositionIndex].PositionMesh);
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

// New exec function that allows debugging exit positions to be toggled for all DHArmoredVehicles
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
        class'DHArmoredVehicle'.default.bDebugExitPositions = !class'DHArmoredVehicle'.default.bDebugExitPositions;
        Log("DHArmoredVehicle.bDebugExitPositions =" @ class'DHArmoredVehicle'.default.bDebugExitPositions);
    }
}

// Handy new execs during development for testing engine or track damage
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

exec function DamTrack(string Track)
{
    if (Level.NetMode == NM_Standalone || class'DH_LevelInfo'.static.DHDebugMode())
    {
        ServerDamTrack(Track);
    }
}

function ServerDamTrack(string Track)
{
    if (Level.NetMode == NM_Standalone || class'DH_LevelInfo'.static.DHDebugMode())
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

// Handy new execs during development for testing fire damage & effects
exec function HullFire()
{
    if (Level.NetMode == NM_Standalone || class'DH_LevelInfo'.static.DHDebugMode())
    {
        ServerHullFire();
    }
}

exec function EngineFire()
{
    if (Level.NetMode == NM_Standalone || class'DH_LevelInfo'.static.DHDebugMode())
    {
        ServerEngineFire();
    }
}

function ServerHullFire()
{
    if (!bOnFire) StartHullFire(none);
}

function ServerEngineFire()
{
    if (!bEngineOnFire) StartEngineFire(none);
}

// Removed damaged track stuff as will no longer work now track damage has been removed from Tick() - can now use DamTrack() exec above for testing
// Also made it so can only be in single player or in dev mode (shouldn't be doing something like this during a real multi-player game)
function exec DamageTank()
{
    if (Level.NetMode == NM_Standalone || class'DH_LevelInfo'.static.DHDebugMode())
    {
        Health /= 2;
        EngineHealth /= 2;
    }
}

exec function LogSwitch(optional int Index) // TEMP DEBUG x 4 (Matt: use if you ever find you can't switch to commander's position when you should be able to)
{
    local ROVehicleWeaponPawn WeaponPawn;
    WeaponPawn = ROVehicleWeaponPawn(WeaponPawns[Index]);
    Log("CLIENT:" @ Tag @ " PassengerWeapons.Length =" @ PassengerWeapons.Length @ " WeaponPawns.Length =" @ WeaponPawns.Length @ " WeaponPawn["$Index$"] =" @ WeaponPawn.Tag);
    Log("CLIENT: Driver =" @ Driver.Tag @ " WP.Driver =" @ WeaponPawn.Driver @ " Same team =" @ Driver.GetTeamNum() == WeaponPawn.VehicleBase.VehicleTeam
        @ " WP.bTeamLocked =" @ bTeamLocked @ " WP.Team =" @ WeaponPawn.Team);
    Log("CLIENT: StopExitToRiderPosition() =" @ StopExitToRiderPosition(Index) @ " PassengerWeapons["$Index$"] is rider pawn =" @ class<ROPassengerPawn>(PassengerWeapons[Index].WeaponPawnClass) != none
        @ " ViewTransition =" @ IsInState('ViewTransition') @ " bCanBeTankCrew =" @ ROPlayerReplicationInfo(Controller.PlayerReplicationInfo).RoleInfo.bCanBeTankCrew);
    if (Role < ROLE_Authority) ServerLogSwitch(Index);
}
function ServerLogSwitch(int Index)
{
    local ROVehicleWeaponPawn WeaponPawn;
    WeaponPawn = ROVehicleWeaponPawn(WeaponPawns[Index]);
    ClientLogSwitch(Index, PassengerWeapons.Length, WeaponPawns.Length, WeaponPawn, Driver, WeaponPawn.Driver, Driver.GetTeamNum() == WeaponPawn.VehicleBase.VehicleTeam,
        bTeamLocked, WeaponPawn.Team, StopExitToRiderPosition(Index), class<ROPassengerPawn>(PassengerWeapons[Index].WeaponPawnClass) != none,
        IsInState('ViewTransition'), ROPlayerReplicationInfo(Controller.PlayerReplicationInfo).RoleInfo.bCanBeTankCrew);
}
simulated function ClientLogSwitch(int Index, int PassengerWeaponsLength, int WeaponPawnsLength, VehicleWeaponPawn WeaponPawn, Pawn SDriver, Pawn WeaponPawnDriver, bool bSameTeam,
    bool bVTeamLocked, int bWPTeam, bool bStopExitToRiderPosition, bool bIsRiderPawn, bool bInViewTrans, bool bCanBeTankCrew)
{
    Log("SERVER:" @ Tag @ " PassengerWeapons.Length =" @ PassengerWeaponsLength @ " WeaponPawns.Length =" @ WeaponPawnsLength @ " WeaponPawn["$Index$"] =" @ WeaponPawn.Tag);
    Log("SERVER: Driver =" @ SDriver.Tag @ " WP.Driver =" @ WeaponPawnDriver @ " Same team =" @ Driver.GetTeamNum() == WeaponPawn.VehicleBase.VehicleTeam
        @ " WP.bTeamLocked =" @ bVTeamLocked @ " WP.Team =" @ bWPTeam);
    Log("SERVER: StopExitToRiderPosition() =" @ bStopExitToRiderPosition @ " PassengerWeapons["$Index$"] is rider pawn =" @ bIsRiderPawn
        @ " ViewTransition =" @ bInViewTrans @ " bCanBeTankCrew =" @ bCanBeTankCrew);
}
exec function ToggleBypass()
{
    bBypassClientSwitchWeaponChecks = !bBypassClientSwitchWeaponChecks;
    log(Tag @ "bBypassClientSwitchWeaponChecks =" @ bBypassClientSwitchWeaponChecks);
}

defaultproperties
{
    SoundVolume=200.0
    SoundRadius=600.0
    TransientSoundRadius=700.0
    UnbuttonedPositionIndex=2
    UnbuttonedIdleAnim="driver_hatch_idle_open"
    bAllowRiders=true
    FirstRiderPositionIndex=2
    bMustUnbuttonToSwitchToRider=true
    LeftTreadIndex=1
    RightTreadIndex=2
    LeftTreadPanDirection=(Pitch=0,Yaw=0,Roll=16384)
    RightTreadPanDirection=(Pitch=0,Yaw=0,Roll=16384)
    DamagedTreadPanner=texture'DH_VehiclesGE_tex2.ext_vehicles.Alpha'
    PlayerCameraBone="Camera_driver"
    FPCamPos=(X=0.0,Y=0.0,Z=0.0)
    bEngineOff=true
    bSavedEngineOff=true
    IgnitionSwitchInterval=4.0
    EngineHealth=300
    DamagedEffectHealthSmokeFactor=0.85
    DamagedEffectHealthMediumSmokeFactor=0.65
    DamagedEffectHealthHeavySmokeFactor=0.35
    DamagedEffectHealthFireFactor=0.0
    ExplosionDamage=575.0
    ExplosionRadius=900.0
    ExplosionSoundRadius=1000.0
    TreadDamageThreshold=0.5
    DriverKillChance=1150.0
    GunnerKillChance=1150.0
    CommanderKillChance=950.0
    OpticsDamageChance=3000.0
    GunDamageChance=1250.0
    TraverseDamageChance=2000.0
    TurretDetonationThreshold=1750.0
    AmmoIgnitionProbability=0.75
    HullFireChance=0.25
    HullFireHEATChance=0.5
    EngineFireChance=0.5
    EngineFireHEATChance=0.85
    EngineToHullFireChance=0.05
    PlayerFireDamagePer2Secs=15.0
    FireDetonationChance=0.07
    bFirstPenetratingHit=true
    VehicleBurningDamType=class'DHVehicleBurningDamageType'
    VehicleBurningSound=sound'Amb_Destruction.Fire.Krasnyi_Fire_House02'
    DestroyedBurningSound=sound'Amb_Destruction.Fire.Kessel_Fire_Small_Barrel'
    DamagedStartUpSound=sound'DH_AlliedVehicleSounds2.Damaged.engine_start_damaged'
    DamagedShutDownSound=sound'DH_AlliedVehicleSounds2.Damaged.engine_stop_damaged'
    SmokingEngineSound=sound'Amb_Constructions.steam.Krasnyi_Steam_Deep'
    FireEffectClass=class'ROEngine.VehicleDamagedEffect'
    FireAttachBone="driver_player"
    FireEffectOffset=(Z=-10.0)
    VehicleSpikeTime=60.0
    TimeTilDissapear=90.0
    IdleTimeBeforeReset=200.0
    DriverTraceDistSquared=20250000.0 // increased from 4500 as made variable into a squared value (VSizeSquared is more efficient than VSize)
    PeriscopeOverlay=texture'DH_VehicleOptics_tex.Allied.PERISCOPE_overlay_Allied'
    DamagedPeriscopeOverlay=texture'DH_VehicleOptics_tex.Allied.Destroyed'
    ObjectCrushStallTime=1.0
    MaxCriticalSpeed=700.0
    ChassisTorqueScale=0.9
    ChangeUpPoint=2050.0
    ChangeDownPoint=1100.0
    ViewShakeRadius=50.0
    ViewShakeOffsetMag=(X=0.0,Z=0.0)
    ViewShakeOffsetFreq=0.0
    TouchMessageClass=class'DHVehicleTouchMessage'

    // These variables are effectively deprecated & should not be used - they are either ignored or values below are assumed & hard coded into functionality:
    bPCRelativeFPRotation=true
    bFPNoZFromCameraPitch=false
    FPCamViewOffset=(X=0.0,Y=0.0,Z=0.0)
    bDesiredBehindView=false
    bDisableThrottle=false
}
