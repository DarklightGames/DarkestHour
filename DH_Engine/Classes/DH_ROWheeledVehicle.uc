//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_ROWheeledVehicle extends ROWheeledVehicle
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
    var() float             PointRadius;        // squared radius of the head of the pawn that is vulnerable to headshots
    var() float             PointHeight;        // distance from base of neck to center of head - used for headshot calculation
    var() float             PointScale;
    var() name              PointBone;          // bone to reference in offset
    var() vector            PointOffset;        // amount to offset the hitpoint from the bone
    var() bool              bPenetrationPoint;  // this is a penetration point, open hatch, etc
    var() float             DamageMultiplier;   // amount to scale damage to the vehicle if this point is hit
    var() ECarHitPointType  CarHitPointType;    // what type of hit point this is
};

var()   array<CarHitpoint>  CarVehHitpoints;    // an array of possible small points that can be hit. Index zero is always the driver

// General
var     float       PointValue;             // used for scoring
var     bool        bEmittersOn;
var     float       DriverTraceDistSquared; // CheckReset() variable // Matt: changed to a squared value, as VSizeSquared is more efficient than VSize
var()   float       ObjectCollisionResistance;
var     bool        bResupplyVehicle;
var     bool        bClientInitialized;     // Matt: clientside flag that replicated actor has completed initialization (set at end of PostNetBeginPlay)
                                            // (allows client code to determine whether actor is just being received through replication, e.g. in PostNetReceive)
// Engine stuff
var     bool        bEngineDead;        // vehicle engine is damaged and cannot run or be restarted ... ever
var     bool        bEngineOff;         // vehicle engine is simply switched off
var     bool        bSavedEngineOff;    // clientside record of current value, so PostNetReceive can tell if a new value has been replicated
var     float       IgnitionSwitchTime;

// New sounds
var    sound        VehicleBurningSound;
var    sound        DestroyedBurningSound;
var    sound        DamagedStartUpSound;

// Debugging help
var     bool        bDebuggingText;
var     bool        bDebugExitPositions;

replication
{
    // Variables the server will replicate to all clients // Matt: should be added to if (bNetDirty) below as "or bNetInitial adds nothing) - move later as part of class review & refactor
    reliable if ((bNetInitial || bNetDirty) && Role == ROLE_Authority)
        bEngineDead, bEngineOff;

    // Variables the server will replicate to all clients
    reliable if (bNetDirty && Role == ROLE_Authority)
        bResupplyVehicle; // Matt: this never changes & doesn't need to be replicated - check later & possibly remove
//      EngineHealthMax  // Matt: removed as I have deprecated it (it never changed anyway & didn't need to be replicated)

    // Functions a client can call on the server
    reliable if (Role < ROLE_Authority)
        ServerStartEngine, ServerToggleDebugExits;
}

simulated function PostBeginPlay()
{
    super(Vehicle).PostBeginPlay(); // Matt: skip over Super in ROWheeledVehicle to avoid setting an initial timer, which we no longer use

    if (HasAnim(BeginningIdleAnim))
    {
        PlayAnim(BeginningIdleAnim);
    }

    // For single player mode, we may as well set this here, as it's only intended to stop idiot players blowing up friendly vehicles in spawn
    if (Level.NetMode == NM_Standalone)
    {
        bDriverAlreadyEntered = true;
    }
    else if (Role < ROLE_Authority)
    {
        // Matt: set this on a net client to work with our new rider pawn system, as rider pawns won't exist on client unless occupied
        // It forces client's WeaponPawns array to normal length, even though rider pawn slots may be empty - simply so we see all the grey rider position dots on HUD vehicle icon
        WeaponPawns.Length = PassengerWeapons.Length;
    }
}

// Modified to initialize engine-related properties & to set bClientInitialized flag
simulated function PostNetBeginPlay()
{
    super.PostNetBeginPlay();

    SetEngine();

    if (Role < ROLE_Authority)
    {
        bClientInitialized = true;
    }
}

// Matt: modified to handle engine on/off (including dust/exhaust emitters), instead of constantly checking in Tick
simulated function PostNetReceive()
{
    // Driver has changed position
    if (DriverPositionIndex != SavedPositionIndex)
    {
        PreviousPositionIndex = SavedPositionIndex;
        SavedPositionIndex = DriverPositionIndex;
        NextViewPoint();
    }

    // Engine has been switched on or off (but if not bClientInitialized, then actor has just replicated & SetEngine() will get called in PostBeginPlay)
    if (bEngineOff != bSavedEngineOff && bClientInitialized)
    {
        bSavedEngineOff = bEngineOff;
        SetEngine();
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

// DriverLeft() called by KDriverLeave()
function DriverLeft()
{
    // Matt: changed from VSize > 5000 to VSizeSquared > 25000000, as is more efficient processing & does same thing
    if (!bNeverReset && ParentFactory != none && (VSizeSquared(Location - ParentFactory.Location) > 25000000.0 || !FastTrace(ParentFactory.Location, Location)))
    {
        if (bKeyVehicle)
        {
            ResetTime = Level.TimeSeconds + 15.0;
        }
        else
        {
            ResetTime = Level.TimeSeconds + 30.0;
        }
    }

    super(Vehicle).DriverLeft();
}

function bool TryToDrive(Pawn P)
{
    local DH_Pawn DHP;
    local int     i;

    DHP = DH_Pawn(P);

    if (DHP == none || DH_Pawn(P).bOnFire)
    {
        return false;
    }

    if (bDebuggingText)
    {
        P.ClientMessage("Vehicle Health:" @ Health $ ", EngineHealth:" @ EngineHealth);
    }

    // Don't allow vehicle to be stolen when somebody is in a turret
    if (!bTeamLocked && P.GetTeamNum() != VehicleTeam)
    {
        for (i = 0; i < WeaponPawns.Length; i++)
        {
            if (WeaponPawns[i].Driver != none)
            {
                DenyEntry(P, 2);

                return false;
            }
        }
    }

    // Took out the crouch requirement to enter
    if (bNonHumanControl || P.Controller == none || Driver != none || P.DrivenVehicle != none || !P.Controller.bIsPlayer || Health <= 0 || (P.Weapon != none && P.Weapon.IsInState('Reloading')))
    {
        return false;
    }

    if (!Level.Game.CanEnterVehicle(self, P))
    {
        return false;
    }

    // Check vehicle locking
    if (bTeamLocked && (P.GetTeamNum() != VehicleTeam))
    {
        DenyEntry(P, 1);

        return false;
    }
    else if (bMustBeTankCommander && P.IsHumanControlled() && !ROPlayerReplicationInfo(P.Controller.PlayerReplicationInfo).RoleInfo.bCanBeTankCrew)
    {
       DenyEntry(P, 0);

       return false;
    }
    else
    {
        if (bEnterringUnlocks && bTeamLocked)
        {
            bTeamLocked = false;
        }

        KDriverEnter(P);

        return true;
    }
}

simulated function Tick(float dt)
{
    local bool  LostTraction;
    local float ThrottlePosition;
    local int   i;

    super(ROVehicle).Tick(dt); // Matt: skip over the Super in ROWheeledVehicle, as it is already entirely re-stated her, so just duplicates everything

    // Pack the throttle setting into a byte to replicate it
    if (Role == ROLE_Authority)
    {
        if (Throttle < 0.0)
        {
            ThrottleRep = (100.0 * Abs(Throttle));
        }
        else
        {
            ThrottleRep = 101 + (100.0 * Throttle);
        }
    }

    // Don't bother doing effects on dedicated server
    if (Level.NetMode != NM_DedicatedServer && !bDropDetail)
    {
        LostTraction = true;

        // Update dust kicked up by wheels
        for (i = 0; i < Dust.Length; i++)
        {
            Dust[i].UpdateDust(Wheels[i], DustSlipRate, DustSlipThresh);
        }

        // Unpack the replicated throttle byte
        if (ThrottleRep < 101)
        {
            ThrottlePosition = Float(ThrottleRep) / 100.0;
        }
        else if (ThrottleRep == 101)
        {
            ThrottlePosition = 0.0;
        }
        else
        {
            ThrottlePosition = Float(ThrottleRep - 101) / 100.0;
        }

        for (i = 0; i < ExhaustPipes.Length; i++)
        {
            if (ExhaustPipes[i].ExhaustEffect != none)
            {
                ExhaustPipes[i].ExhaustEffect.UpdateExhaust(ThrottlePosition);
            }
        }
    }

    TurnDamping = default.TurnDamping;

    // Lets make the vehicle not slide when its parked
    if (Abs(ForwardVel) < 50.0)
    {
        MinBrakeFriction = LowSpeedBrakeFriction;
    }
    else
    {
        MinBrakeFriction=Default.MinBrakeFriction;
    }

    if (bEngineDead || bEngineOff)
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
        if (IsVehicleEmpty())
        {
            KilledBy(self);
        }
        else
        {
            bSpikedVehicle = false; // cancel spike timer if vehicle is now occupied
        }
    }
}

// Overriding here because we don't want exhaust/dust to start up until engine starts
simulated event DrivingStatusChanged()
{
    super(Vehicle).DrivingStatusChanged();

    // Moved exhaust and dust spawning to StartEngineFunction
}

// Modified to use fire button to start or stop engine
simulated function Fire(optional float F)
{
    // Matt: added clientside checks to prevent unnecessary replicated function call to server if invalid (including clientside time check)
    if (Throttle == 0.0 && (Level.TimeSeconds - IgnitionSwitchTime) > 4.0 && EngineHealth > 0)
    {
        ServerStartEngine();
        IgnitionSwitchTime = Level.TimeSeconds;
    }
}

// Matt: emptied out to prevent unnecessary replicated function calls to server - vehicles don't use AltFire
function AltFire(optional float F)
{
}

simulated function StopEmitters()
{
    local int i;

    if (Level.NetMode != NM_DedicatedServer)
    {
        for (i = 0; i < Dust.Length; i++)
        {
            if (Dust[i] != none)
            {
                Dust[i].Kill();
            }
        }

        Dust.Length = 0;

        for (i = 0; i < ExhaustPipes.Length; i++)
        {
            if (ExhaustPipes[i].ExhaustEffect != none)
            {
                ExhaustPipes[i].ExhaustEffect.Kill();
            }
        }
    }

    bEmittersOn = false;
}

simulated function StartEmitters()
{
    local int    i;
    local coords WheelCoords;

    if (Level.NetMode != NM_DedicatedServer && !bDropDetail)
    {
        Dust.Length = Wheels.Length;

        for (i = 0; i < Wheels.Length; i++)
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

        for (i = 0; i < ExhaustPipes.Length; i++)
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
    }

    bEmittersOn = true;
}

// Server side function called to switch engine on/off
function ServerStartEngine()
{
    // Engine can't be dead & vehicle can't be moving - also a time check so people can't spam the ignition switch
    if (Throttle == 0.0 && (Level.TimeSeconds - IgnitionSwitchTime) > 4.0 && !bEngineDead)
    {
        IgnitionSwitchTime = Level.TimeSeconds;
        bEngineOff = !bEngineOff;
        SetEngine();

        if (bEngineOff)
        {
            if (ShutDownSound != none)
            {
                PlaySound(ShutDownSound, SLOT_None, 1.0);
            }
        }
        else
        {
            if (StartUpSound != none)
            {
                PlaySound(StartUpSound, SLOT_None, 1.0);
            }
        }
    }
}

// Overridden to give players the same momentum as their vehicle had when exiting
// Adds a little height kick to allow for hacked in damage system
function bool KDriverLeave(bool bForceLeave)
{
    local vector OldVel;
    local bool   bSuperDriverLeave;

    if (!bForceLeave)
    {
        OldVel = Velocity;

        bSuperDriverLeave = super.KDriverLeave(bForceLeave);

        OldVel.Z += 75.0;
        Instigator.AddVelocity(OldVel);

        return bSuperDriverLeave;
    }
    else
    {
        super.KDriverLeave(bForceLeave);
    }
}

function bool PlaceExitingDriver()
{
    local int    i;
    local vector Extent, HitLocation, HitNormal, ZOffset, ExitPosition;

    if (Driver == none)
    {
        return false;
    }

    Extent = Driver.default.CollisionRadius * vect(1.0, 1.0, 0.0);
    Extent.Z = Driver.default.CollisionHeight;
    ZOffset = Driver.default.CollisionHeight * vect(0.0, 0.0, 0.5);

    // Debug exits // Matt: uses abstract class default, allowing bDebugExitPositions to be toggled for all DH_ROWheeledVehicles
    if (class'DH_ROWheeledVehicle'.default.bDebugExitPositions)
    {
        for (i = 0; i < ExitPositions.Length; ++i)
        {
            ExitPosition = Location + (ExitPositions[i] >> Rotation) + ZOffset;

            Spawn(class'DH_DebugTracer', , , ExitPosition);
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

event KImpact(Actor Other, vector Pos, vector ImpactVel, vector ImpactNorm)
{
    if (Role == ROLE_Authority)
    {
        ImpactInfo.Other = Other;
        ImpactInfo.Pos = Pos;
        ImpactInfo.ImpactVel = ImpactVel;
        ImpactInfo.ImpactNorm = ImpactNorm;
        ImpactInfo.ImpactAccel = KParams.KAcceleration;
        ImpactTicksLeft = ImpactDamageTicks;
    }
}

event TakeImpactDamage(float AccelMag)
{
    local int Damage;

    if (Vehicle(ImpactInfo.Other) != none)
    {
        Damage = Int(VSize(ImpactInfo.Other.Velocity) * 20.0 * ImpactDamageModifier());

        TakeDamage(Damage, Vehicle(ImpactInfo.Other), ImpactInfo.Pos, vect(0.0, 0.0, 0.0), class'DH_VehicleCollisionDamType');
    }
    else
    {
        TakeDamage(Int(AccelMag * ImpactDamageModifier()) / ObjectCollisionResistance, self, ImpactInfo.Pos, vect(0.0, 0.0, 0.0), class'DH_VehicleCollisionDamType');
    }

    // FIXME - scale sound volume to damage amount
    if (ImpactDamageSounds.Length > 0)
    {
        PlaySound(ImpactDamageSounds[Rand(ImpactDamageSounds.Length - 1)],, TransientSoundVolume * 2.5);
    }

    if (Health < 0 && (Level.TimeSeconds - LastImpactExplosionTime) > TimeBetweenImpactExplosions)
    {
        VehicleExplosion(Normal(ImpactInfo.ImpactNorm), 0.5);

        LastImpactExplosionTime = Level.TimeSeconds;
    }
}

function VehicleExplosion(vector MomentumNormal, float PercentMomentum)
{
    local vector LinearImpulse, AngularImpulse;
    local float  RandomExplModifier;

    RandomExplModifier = FRand();

    if (bResupplyVehicle)
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

// Handle the engine damage
function DamageEngine(int Damage, Pawn InstigatedBy, vector Hitlocation, vector Momentum, class<DamageType> DamageType)
{
    if (EngineHealth > 0)
    {
        Damage = Level.Game.ReduceDamage(Damage, self, InstigatedBy, HitLocation, Momentum, DamageType);
        EngineHealth -= Damage;
    }

    // Heavy damage to engine slows vehicle way down // Matt: won't have any effect setting this here - will move elsewhere later
    if (EngineHealth <= (default.EngineHealth * 0.25) && EngineHealth > 0)
    {
        Throttle = FClamp(Throttle, -0.50, 0.50);
    }
    // Kill the engine if its health has now fallen to zero
    else if (EngineHealth <= 0)
    {
        if (bDebuggingText)
        {
            Level.Game.Broadcast(self, "Vehicle engine is dead");
        }

        bEngineDead = true;
        bEngineOff = true;
        SetEngine();
    }
}

// Vehicle has been in the middle of nowhere with no driver for a while, so consider resetting it called after ResetTime has passed since driver left
// Overridden so we can control the time it takes for the vehicle to disappear - Ramm
event CheckReset()
{
    local Pawn P;

    if (bKeyVehicle && IsVehicleEmpty())
    {
        Died(none, class'DamageType', Location);

        return;
    }

    if (!IsVehicleEmpty())
    {
        ResetTime = Level.TimeSeconds + IdleTimeBeforeReset;

        return;
    }

    foreach CollidingActors(class'Pawn', P, 4000.0)
    {
        if (P != self && P.Controller != none && P.GetTeamNum() == GetTeamNum()) // traces only work on friendly players nearby
        {
            if (ROPawn(P) != none && (VSizeSquared(P.Location - Location) < DriverTraceDistSquared)) // Matt: changed so compare squared values, as VSizeSquared is more efficient
            {
                if (bDebuggingText)
                {
                    Level.Game.Broadcast(self, "Initiating collision reset check");
                }

                ResetTime = Level.TimeSeconds + IdleTimeBeforeReset;

                return;
            }
            else if (FastTrace(P.Location + P.CollisionHeight * vect(0.0, 0.0, 1.0), Location + CollisionHeight * vect(0.0, 0.0, 1.0)))
            {
                if (bDebuggingText)
                {
                    Level.Game.Broadcast(self, "Initiating FastTrace reset check");
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
            Level.Game.Broadcast(self, "Player not found - respawn");
        }

        ParentFactory.VehicleDestroyed(self);
        ParentFactory.Timer();
        ParentFactory = none; // so doesn't call ParentFactory.VehicleDestroyed() again in Destroyed()
    }

    Destroy();
}

function Died(Controller Killer, class<DamageType> DamageType, vector HitLocation)
{
    super.Died(Killer, DamageType, HitLocation);

    if (Killer == none)
    {
        return;
    }

    DarkestHourGame(Level.Game).ScoreVehicleKill(Killer, self, PointValue);
}

simulated event DestroyAppearance()
{
    local int         i;
    local KarmaParams KP;

    // For replication
    bDestroyAppearance = true;

    // Put brakes on
    Throttle = 0.0;
    Steering = 0.0;
    Rise     = 0.0;

    // Destroy the weapons
    if (Role == ROLE_Authority)
    {
        for (i = 0; i < WeaponPawns.Length; i++)
        {
            if (WeaponPawns[i] != none)
            {
                WeaponPawns[i].Destroy();
            }
        }
    }

    WeaponPawns.Length = 0;

    // Destroy the effects
    if (Level.NetMode != NM_DedicatedServer)
    {
        for (i = 0; i < Dust.Length; i++)
        {
            if (Dust[i] != none)
            {
                Dust[i].Kill();
            }
        }

        Dust.Length = 0;

        for (i = 0; i < ExhaustPipes.Length; i++)
        {
            if (ExhaustPipes[i].ExhaustEffect != none)
            {
                ExhaustPipes[i].ExhaustEffect.Kill();
            }
        }
    }

    // Copy linear velocity from actor so it doesn't just stop
    KP = KarmaParams(KParams);

    if (KP != none)
    {
        KP.KStartLinVel = Velocity;
    }

    if (DamagedEffect != none)
    {
        DamagedEffect.Kill();
    }

    // Become the dead vehicle mesh
    SetPhysics(PHYS_None);
    KSetBlockKarma(false);
    SetDrawType(DT_StaticMesh);
    SetStaticMesh(DestroyedVehicleMesh);
    KSetBlockKarma(true);
    SetPhysics(PHYS_Karma);
    Skins.Length = 0;
    NetPriority = 2.0;
}


// Matt: modified to avoid wasting network resources by calling ServerChangeViewPoint on the server when it isn't valid
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
function ServerChangeDriverPosition(byte F)
{
    if (IsInState('ViewTransition'))
    {
        return;
    }

    super.ServerChangeDriverPosition(F);
}

// Modified to add clientside checks before sending the function call to the server
simulated function SwitchWeapon(byte F)
{
    local ROVehicleWeaponPawn WeaponPawn;
    local bool                bMustBeTankerToSwitch;
    local byte                ChosenWeaponPawnIndex;

    ChosenWeaponPawnIndex = F - 2;

    // Stop call to server if player has selected an invalid weapon position
    // Note that if player presses 0 or 1, which are invalid choices for a vehicle driver, the byte index will end up as 254 or 255 & so will still fail this check (which is what we want)
    if (ChosenWeaponPawnIndex >= PassengerWeapons.Length)
    {
        return;
    }

    if (ChosenWeaponPawnIndex < WeaponPawns.Length)
    {
        WeaponPawn = ROVehicleWeaponPawn(WeaponPawns[ChosenWeaponPawnIndex]);
    }

    if (WeaponPawn != none)
    {
        // Stop call to server as weapon position already has a human player
        if (WeaponPawn.Driver != none && WeaponPawn.Driver.IsHumanControlled())
        {
            return;
        }

        if (WeaponPawn.bMustBeTankCrew)
        {
            bMustBeTankerToSwitch = true;
        }
    }
    // Stop call to server if weapon pawn doesn't exist, UNLESS PassengerWeapons array lists it as a rider position
    // This is because our new system means rider pawns won't exist on clients unless occupied, so we have to allow this switch through to server
    else if (class<ROPassengerPawn>(PassengerWeapons[ChosenWeaponPawnIndex].WeaponPawnClass) == none)
    {
        return;
    }

    // Stop call to server if player has selected a tank crew role but isn't a tanker
    if (bMustBeTankerToSwitch && (Controller == none || ROPlayerReplicationInfo(Controller.PlayerReplicationInfo) == none ||
        ROPlayerReplicationInfo(Controller.PlayerReplicationInfo).RoleInfo == none || !ROPlayerReplicationInfo(Controller.PlayerReplicationInfo).RoleInfo.bCanBeTankCrew))
    {
        ReceiveLocalizedMessage(class'DH_VehicleMessage', 0); // not qualified to operate vehicle

        return;
    }

    ServerChangeDriverPosition(F);
}

// Matt: added as when player is in a vehicle, the HUD keybinds to GrowHUD & ShrinkHUD will now call these same named functions in the vehicle classes
// When player is in a vehicle, these functions do nothing to the HUD, but they can be used to add useful vehicle functionality in subclasses, especially as keys are -/+ by default
simulated function GrowHUD();
simulated function ShrinkHUD();

// Matt: modified to switch to external mesh & default FOV for behind view
simulated function POVChanged(PlayerController PC, bool bBehindViewChanged)
{
    local int i;

    if (PC.bBehindView)
    {
        if (bBehindViewChanged)
        {
            if (bPCRelativeFPRotation)
            {
                PC.SetRotation(rotator(vector(PC.Rotation) >> Rotation));
            }

            for (i = 0; i < DriverPositions.Length; i++)
            {
                DriverPositions[i].PositionMesh = default.Mesh;
                DriverPositions[i].ViewFOV = PC.DefaultFOV;
            }

            bDontUsePositionMesh = true;

            if ((Role == ROLE_AutonomousProxy || Level.NetMode == NM_Standalone || Level.NetMode == NM_ListenServer) && DriverPositions[DriverPositionIndex].PositionMesh != none)
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
        if (bPCRelativeFPRotation)
        {
            PC.SetRotation(rotator(vector(PC.Rotation) << Rotation));
        }

        if (bBehindViewChanged)
        {
            for (i = 0; i < DriverPositions.Length; i++)
            {
                DriverPositions[i].PositionMesh = default.DriverPositions[i].PositionMesh;
                DriverPositions[i].ViewFOV = default.DriverPositions[i].ViewFOV;
            }

            bDontUsePositionMesh = default.bDontUsePositionMesh;

            if ((Role == ROLE_AutonomousProxy || Level.NetMode == NM_Standalone || Level.NetMode == NM_ListenServer) && DriverPositions[DriverPositionIndex].PositionMesh != none)
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

        if (bDriving && PC == Controller) // no overlays for spectators
        {
            ActivateOverlay(true);
        }
    }
}

// Matt: DH version but keeping it just to view limits & nothing to do with behind view (which is handled by exec functions BehindView & ToggleBehindView)
exec function ToggleViewLimit()
{
    if (class'DH_LevelInfo'.static.DHDebugMode()) // removed requirement to be in single player mode, as valid in multi-player if in DHDebugMode
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

// Matt: allows debugging exit positions to be toggled for all DH_ROWheeledVehicles
exec function ToggleDebugExits()
{
    if (class'DH_LevelInfo'.static.DHDebugMode())
    {
        ServerToggleDebugExits();
    }
}

function ServerToggleDebugExits()
{
    if (class'DH_LevelInfo'.static.DHDebugMode())
    {
        class'DH_ROWheeledVehicle'.default.bDebugExitPositions = !class'DH_ROWheeledVehicle'.default.bDebugExitPositions;
        Log("DH_ROWheeledVehicle.bDebugExitPositions =" @ class'DH_ROWheeledVehicle'.default.bDebugExitPositions);
    }
}

// Overridden to eliminate "Waiting for Additional Crewmembers" message
function bool CheckForCrew()
{
    return true;
}

defaultproperties
{
    ObjectCollisionResistance=1.0
    bEngineOff=true
    bSavedEngineOff=true
    bDisableThrottle=false
    VehicleBurningSound=sound'Amb_Destruction.Fire.Krasnyi_Fire_House02'
    DestroyedBurningSound=sound'Amb_Destruction.Fire.Kessel_Fire_Small_Barrel'
    DamagedStartUpSound=sound'DH_AlliedVehicleSounds2.Damaged.engine_start_damaged'
    PointValue=1.0
    DriverTraceDistSquared=20250000.0 // Matt: increased from 4500 as made variable into a squared value (VSizeSquared is more efficient than VSize)
    DestructionEffectClass=class'AHZ_ROVehicles.ATCannonDestroyedEmitter'
    DisintegrationEffectClass=class'ROEffects.ROVehicleDestroyedEmitter'
    DisintegrationEffectLowClass=class'ROEffects.ROVehicleDestroyedEmitter_simple'
    ExplosionSoundRadius=1000.0
    ExplosionDamage=325.0
    ExplosionRadius=700.0
    DamagedEffectHealthSmokeFactor=0.75
    DamagedEffectHealthMediumSmokeFactor=0.50
    DamagedEffectHealthHeavySmokeFactor=0.25
    DamagedEffectHealthFireFactor=0.15
    ImpactDamageTicks=2.0
    ImpactDamageThreshold=20.0
    ImpactDamageMult=0.5
    IdleTimeBeforeReset=90.0
    VehicleSpikeTime=30.0
    EngineHealth=30
    ObjectiveGetOutDist=1500.0
    bKeepDriverAuxCollision=true
    HealthMax=175.0
    Health=175
}
