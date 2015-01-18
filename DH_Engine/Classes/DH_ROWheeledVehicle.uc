//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_ROWheeledVehicle extends ROWheeledVehicle
    abstract;

#exec OBJ LOAD FILE=..\Textures\DH_InterfaceArt_tex.utx

struct ExitPositionPair
{
    var int Index;
    var float DistanceSquared;
};

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

// Engine stuff
var     bool        bEngineDead;        // vehicle engine is damaged and cannot run or be restarted ... ever
var     bool        bEngineOff;         // vehicle engine is simply switched off
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


static final operator(24) bool > (ExitPositionPair A, ExitPositionPair B)
{
    return A.DistanceSquared > B.DistanceSquared;
}

// http://wiki.beyondunreal.com/Legacy:Insertion_Sort
static final function InsertSortEPPArray(out array<ExitPositionPair> MyArray, int LowerBound, int UpperBound)
{
    local int InsertIndex, RemovedIndex;

    if (LowerBound < UpperBound)
    {
        for (RemovedIndex = LowerBound + 1; RemovedIndex <= UpperBound; ++RemovedIndex)
        {
            InsertIndex = RemovedIndex;

            while (InsertIndex > LowerBound && MyArray[InsertIndex - 1] > MyArray[RemovedIndex])
            {
                --InsertIndex;
            }

            if (RemovedIndex != InsertIndex)
            {
                MyArray.Insert(InsertIndex, 1);
                MyArray[InsertIndex] = MyArray[RemovedIndex + 1];
                MyArray.Remove(RemovedIndex + 1, 1);
            }
        }
    }
}

function KDriverEnter(Pawn P)
{
    DriverPositionIndex = InitialPositionIndex;
    PreviousPositionIndex = InitialPositionIndex;

    if (!p.IsHumanControlled())
    {
        bEngineOff = false;
    }
    
    // Check to see if engine is already on when entering
    if (bEngineOff)
    {
        if (IdleSound != none)
        {
            AmbientSound = none;
        }
    }
    else if (bEngineDead)
    {
        if (IdleSound != none)
        {
            AmbientSound = VehicleBurningSound;
        }
    }
    else
    {
        if (IdleSound != none)
        {
            AmbientSound = IdleSound;
        }
    }

    ResetTime = Level.TimeSeconds - 1.0;
    Instigator = self;

    super(Vehicle).KDriverEnter(P);
}

// DriverLeft() called by KDriverLeave()
function DriverLeft()
{
    if (ActiveWeapon < Weapons.Length)
    {
        Weapons[ActiveWeapon].bActive = false;
        Weapons[ActiveWeapon].AmbientSound = none;
    }

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

    super.Tick(dt);

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
        velocity = vect(0.0, 0.0, 0.0);
        Throttle = 0.0;
        ThrottleAmount = 0.0;
        bDisableThrottle = true;
        Steering = 0.0;
    }

    if (Level.NetMode != NM_DedicatedServer)
    {
        CheckEmitters();
    }
}

simulated function CheckEmitters()
{
    if (bEmittersOn && (bEngineDead || bEngineOff))
    {
        StopEmitters();
    }
    else if (!bEmittersOn && !bEngineDead && !bEngineOff)
    {
        StartEmitters();
    }
}

// Overriding here because we don't want exhaust/dust to start up until engine starts
simulated event DrivingStatusChanged()
{
    super(Vehicle).DrivingStatusChanged();

    // Moved exhaust and dust spawning to StartEngineFunction
}

simulated function Fire(optional float F)
{
    if (Level.NetMode != NM_DedicatedServer)
    {
        ServerStartEngine();
    }
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
        }
    }

    bEmittersOn = true;
}

function ServerStartEngine()
{
    if (!bEngineDead) //can't turn Engine on or off if it's dead
    {
        if (!bEngineOff)
        {
            if (Throttle != 0.0) // cannot turn off while moving
            {
                return;
            }

            // So that people can't spam the ignition switch
            if (Level.TimeSeconds - IgnitionSwitchTime > 4.0)
            {
                if (AmbientSound != none)
                {
                    AmbientSound = none;
                }

                if (ShutDownSound != none)
                {
                    PlaySound(ShutDownSound, SLOT_None, 1.0,, 300.0);
                }

                Throttle = 0.0;
                ThrottleAmount = 0.0;
                bDisableThrottle = true;
                bEngineOff = true;

                TurnDamping = 0.0;
                IgnitionSwitchTime = Level.TimeSeconds;
            }
        }
        else
        {
            if (Level.TimeSeconds - IgnitionSwitchTime > 4.0)
            {
                if (StartUpSound != none)
                {
                    PlaySound(StartUpSound, SLOT_None, 1.0,, 300.0);
                }

                if (IdleSound != none)
                {
                    AmbientSound = IdleSound;
                }

                Throttle = 0.0;
                bDisableThrottle = false;
                bEngineOff = false;

                IgnitionSwitchTime = Level.TimeSeconds;
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
    local array<ExitPositionPair> ExitPositionPairs;

    if (Driver == none)
    {
        return false;
    }

    Extent = Driver.default.CollisionRadius * vect(1.0, 1.0, 0.0);
    Extent.Z = Driver.default.CollisionHeight;
    ZOffset = Driver.default.CollisionHeight * vect(0.0, 0.0, 0.5);

    ExitPositionPairs.Length = ExitPositions.Length;

    for (i = 0; i < ExitPositions.Length; ++i)
    {
        ExitPositionPairs[i].Index = i;
        ExitPositionPairs[i].DistanceSquared = VSizeSquared(DrivePos - ExitPositions[i]);
    }

    InsertSortEPPArray(ExitPositionPairs, 0, ExitPositionPairs.Length - 1);

    // Debug exits // Matt: uses abstract class default, allowing bDebugExitPositions to be toggled for all DH_ROWheeledVehicles
    if (class'DH_ROWheeledVehicle'.default.bDebugExitPositions)
    {
        for (i = 0; i < ExitPositionPairs.Length; ++i)
        {
            ExitPosition = Location + (ExitPositions[ExitPositionPairs[i].Index] >> Rotation) + ZOffset;

            Spawn(class'DH_DebugTracer', , , ExitPosition);
        }
    }

    for (i = 0; i < ExitPositionPairs.Length; ++i)
    {
        ExitPosition = Location + (ExitPositions[ExitPositionPairs[i].Index] >> Rotation) + ZOffset;

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
    local int ActualDamage;

    if (EngineHealth > 0)
    {
        ActualDamage = Level.Game.ReduceDamage(Damage, self, InstigatedBy, HitLocation, Momentum, DamageType);
        EngineHealth -= ActualDamage;
    }

    // Heavy damage to engine slows vehicle way down
    if (EngineHealth <= (default.EngineHealth * 0.25) && EngineHealth > 0)
    {
        Throttle = FClamp(Throttle, -0.50, 0.50);
    }
    else if (EngineHealth <= 0)
    {
        if (bDebuggingText)
        {
            Level.Game.Broadcast(self, "Vehicle engine is dead");
        }

        bDisableThrottle = true;
        bEngineDead = true;

        IdleSound = VehicleBurningSound;
        StartUpSound = none;
        ShutDownSound = none;
        AmbientSound = VehicleBurningSound;
        SoundVolume = 255;
        SoundRadius = 600;
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
        for (i = 0; i < Weapons.Length; i++)
        {
            if (Weapons[i] != none)
            {
                Weapons[i].Destroy();
            }
        }

        for (i = 0; i < WeaponPawns.Length; i++)
        {
            if (WeaponPawns[i] != none)
            {
                WeaponPawns[i].Destroy();
            }
        }
    }

    Weapons.Length = 0;
    WeaponPawns.Length = 0;

    // Destroy the effects
    if (Level.NetMode != NM_DedicatedServer)
    {
        bNoTeamBeacon = true;

        for (i = 0; i < HeadlightCorona.Length; i++)
        {
            HeadlightCorona[i].Destroy();
        }

        HeadlightCorona.Length = 0;

        if (HeadlightProjector != none)
        {
            HeadlightProjector.Destroy();
        }

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

function ServerChangeDriverPosition(byte F)
{
    if (IsInState('ViewTransition'))
    {
        return;
    }

    super.ServerChangeDriverPosition(F);
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

            if ((Role == ROLE_AutonomousProxy || Level.Netmode == NM_Standalone || Level.Netmode == NM_ListenServer) && DriverPositions[DriverPositionIndex].PositionMesh != none)
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

            if ((Role == ROLE_AutonomousProxy || Level.Netmode == NM_Standalone || Level.Netmode == NM_ListenServer) && DriverPositions[DriverPositionIndex].PositionMesh != none)
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
