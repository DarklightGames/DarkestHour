//==============================================================================
// DH_ROWheeledVehicle
//
// Darkest Hour Source - (c) Darkest Hour Team 2010
// Red Orchestra Source - (c) Tripwire Interactive 2006
//
// Base class for all DH wheeled transports
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

var     ECarHitPointType                    CarHitPointType;

struct CarHitpoint
{
    var() float             PointRadius;        // Squared radius of the head of the pawn that is vulnerable to headshots
    var() float             PointHeight;        // Distance from base of neck to center of head - used for headshot calculation
    var() float             PointScale;
    var() name              PointBone;          // Bone to reference in offset
    var() vector            PointOffset;        // Amount to offset the hitpoint from the bone
    var() bool              bPenetrationPoint;  // This is a penetration point, open hatch, etc
    var() float             DamageMultiplier;   // Amount to scale damage to the vehicle if this point is hit
    var() ECarHitPointType  CarHitPointType;    // What type of hit point this is
};

var()   array<CarHitpoint>      CarVehHitpoints;        // An array of possible small points that can be hit. Index zero is always the driver

var()       float               ObjectCollisionResistance;

var int EngineHealthMax;

// Engine stuff
var     bool                bEngineDead;   //vehicle engine is damaged and cannot run or be restarted...ever
var     bool                bEngineOff;    //vehicle engine is simply switched off
var     float               IgnitionSwitchTime;
var     bool                bResupplyVehicle;

// New sounds
var    sound                VehicleBurningSound;
var    sound                DestroyedBurningSound;
var    sound                DamagedStartUpSound;

var     float       PointValue; // Used for scoring

var     float       DriverTraceDist;

//Debugging help
var     bool        bDebuggingText;

var     bool        bEmittersOn;

struct ExitPositionPair
{
    var int Index;
    var float DistanceSquared;
};

var bool bDebugExitPositions;

//==============================================================================
// Functions
//==============================================================================
replication
{
    reliable if (bNetDirty && Role==ROLE_Authority)
        EngineHealthMax;

    reliable if (Role<ROLE_Authority)
        ServerStartEngine;

    reliable if (Role == ROLE_Authority)
        bResupplyVehicle;

    reliable if ((bNetInitial || bNetDirty) && Role == ROLE_Authority)
        bEngineDead, bEngineOff;
}

static final operator(24) bool > (ExitPositionPair A, ExitPositionPair B)
{
    return A.DistanceSquared > B.DistanceSquared;
}

//http://wiki.beyondunreal.com/Legacy:Insertion_Sort
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

            if ( RemovedIndex != InsertIndex )
            {
                MyArray.Insert(InsertIndex, 1);
                MyArray[InsertIndex] = MyArray[RemovedIndex + 1];
                MyArray.Remove(RemovedIndex + 1, 1);
            }
        }
    }
}

simulated function PostBeginPlay()
{
    Super.PostBeginPlay();

    EngineHealth=EngineHealthMax;

    //Engine starting and stopping stuff
    //bEngineOff=true;
    //bEngineDead=false;
    //bDisableThrottle=true;
}

function KDriverEnter(Pawn P)
{

    DriverPositionIndex=InitialPositionIndex;
    PreviousPositionIndex=InitialPositionIndex;

    if (!p.IsHumanControlled())
       bEngineOff=false;

    //check to see if Engine is already on when entering
    if (bEngineOff)
    {
        if (IdleSound != none)
        AmbientSound = none;

    }
    else if (bEngineDead)
    {
        if (IdleSound != none)
        AmbientSound = VehicleBurningSound;
    }
    else
    {
        if (IdleSound != none)
        AmbientSound = IdleSound;
    }

    ResetTime = Level.TimeSeconds - 1;
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

    if (!bNeverReset && ParentFactory != none && (VSize(Location - ParentFactory.Location) > 5000.0 || !FastTrace(ParentFactory.Location, Location)))
    {
        if (bKeyVehicle)
            ResetTime = Level.TimeSeconds + 15;
        else
        ResetTime = Level.TimeSeconds + 30;
    }

    super(Vehicle).DriverLeft();
}

function bool TryToDrive(Pawn P)
{
    local int i;
    local DH_Pawn DHP;

    DHP = DH_Pawn(P);

    if (DHP == none || DH_Pawn(P).bOnFire)
    {
        return false;
    }

    if (bDebuggingText)
    {
        P.ClientMessage("Vehicle Health: " $ Health $ ", EngineHealth: " $ EngineHealth);
    }

    //don't allow vehicle to be stolen when somebody is in a turret
    if (!bTeamLocked && P.GetTeamNum() != VehicleTeam)
    {
        for (i = 0; i < WeaponPawns.length; i++)
        {
            if (WeaponPawns[i].Driver != none)
            {
                DenyEntry(P, 2);

                return false;
            }
        }
    }

    //took out the crouch requirement to enter
    if (bNonHumanControl ||
        P.Controller == none ||
        Driver != none ||
        P.DrivenVehicle != none ||
        !P.Controller.bIsPlayer ||
        Health <= 0 ||
        (P.Weapon != none && P.Weapon.IsInState('Reloading')))
    {
        return false;
    }

    if (!Level.Game.CanEnterVehicle(self, P))
    {
        return false;
    }

    // Check vehicle Locking....
    if (bTeamLocked && (P.GetTeamNum() != VehicleTeam))
    {
        DenyEntry(P, 1);

        return false;
    }
    else if (bMustBeTankCommander &&
             P.IsHumanControlled() &&
             !ROPlayerReplicationInfo(P.Controller.PlayerReplicationInfo).RoleInfo.bCanBeTankCrew)
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

// Overridden to add steering wheel code that actually works - Ramm
// MergeTODO: Move my steering code to the native and AXE epics steering code
simulated function Tick(float dt)
{
    local int i;
    local bool lostTraction;
    local float ThrottlePosition;

    Super.Tick(dt);

    // Pack the throttle setting into a byte to replicate it
    if (Role == ROLE_Authority)
    {
        if (Throttle < 0)
        {
            ThrottleRep = (100 * Abs(Throttle));
        }
        else
        {
            ThrottleRep = 101 + (100 * Throttle);
        }
    }

    // Dont bother doing effects on dedicated server.
    if (Level.NetMode != NM_DedicatedServer && !bDropDetail)
    {
        lostTraction = true;

        // MergeTODO: Put this stuff back in

        // Update dust kicked up by wheels.
        for(i=0; i<Dust.Length; i++)
           Dust[i].UpdateDust(Wheels[i], DustSlipRate, DustSlipThresh);

        // Unpack the replicated throttle byte
        if (ThrottleRep < 101)
        {
            ThrottlePosition = (ThrottleRep * 1.0)/100;
        }
        else if (ThrottleRep == 101)
        {
            ThrottlePosition = 0;
        }
        else
        {
            ThrottlePosition = (ThrottleRep - 101)/100;
        }

        for(i=0; i<ExhaustPipes.Length; i++)
        {
            if (ExhaustPipes[i].ExhaustEffect != none)
            {
                ExhaustPipes[i].ExhaustEffect.UpdateExhaust(ThrottlePosition);
            }
        }

        /*
        if (bMakeBrakeLights)
        {
            for(i=0; i<2; i++)
                if (BrakeLight[i] != none)
                    BrakeLight[i].bCorona = true;

            for(i=0; i<2; i++)
                if (BrakeLight[i] != none)
                    BrakeLight[i].UpdateBrakelightState(OutputBrake, Gear);
        }  */
    }

    TurnDamping = default.TurnDamping;

    // RO Functionality
    // Lets make the vehicle not slide when its parked
    if (Abs(ForwardVel) < 50)
    {
        MinBrakeFriction = LowSpeedBrakeFriction;
    }
    else
    {
        MinBrakeFriction=Default.MinBrakeFriction;
    }

    if (bEngineDead || bEngineOff)
    {
        velocity=vect(0,0,0);
        Throttle=0;
        ThrottleAmount=0;
        bDisableThrottle=true;
        Steering=0;
    }

    if (Level.NetMode != NM_DedicatedServer)
        CheckEmitters();
}

simulated function CheckEmitters()
{
    if (bEmittersOn && (bEngineDead || bEngineOff))
        StopEmitters();
    else if (!bEmittersOn && !bEngineDead && !bEngineOff)
        StartEmitters();
}
//overriding here because we don't want exhaust/dust to start up until engine starts
simulated event DrivingStatusChanged()
{
    super(Vehicle).DrivingStatusChanged();

    //moved exhaust and dust spawning to StartEngineFunction
}

simulated function Fire(optional float F)
{
    if (Level.NetMode != NM_DedicatedServer)
        ServerStartEngine();
}

simulated function StopEmitters()
{
    local int i;

    if (Level.NetMode != NM_DedicatedServer)
    {
        for(i = 0; i < Dust.Length; i++)
            if (Dust[i] != none)
                Dust[i].Kill();

        Dust.Length = 0;

        for(i = 0; i < ExhaustPipes.Length; i++)
            if (ExhaustPipes[i].ExhaustEffect != none)
                ExhaustPipes[i].ExhaustEffect.Kill();
    }

    bEmittersOn = false;
}

simulated function StartEmitters()
{
    local int i;
    local coords WheelCoords;

    if (Level.NetMode != NM_DedicatedServer && !bDropDetail)
    {
        Dust.length = Wheels.length;

        for(i=0; i<Wheels.Length; i++)
        {
            if (Dust[i] != none)
                Dust[i].Destroy();

            // Create wheel dust emitters.
            WheelCoords = GetBoneCoords(Wheels[i].BoneName);
            Dust[i] = spawn(class'VehicleWheelDustEffect', self,, WheelCoords.Origin + ((vect(0,0,-1) * Wheels[i].WheelRadius) >> Rotation));

            if (Level.bDropDetail || Level.DetailMode == DM_Low)
            {
                Dust[i].MaxSpritePPS=3;
                Dust[i].MaxMeshPPS=3;
            }

            Dust[i].SetBase(self);
            Dust[i].SetDirtColor(Level.DustColor);
        }

        for(i=0; i<ExhaustPipes.Length; i++)
        {
            if (ExhaustPipes[i].ExhaustEffect != none)
                ExhaustPipes[i].ExhaustEffect.Destroy();

            // Create exhaust emitters.
            if (Level.bDropDetail || Level.DetailMode == DM_Low)
                ExhaustPipes[i].ExhaustEffect = spawn(ExhaustEffectLowClass, self,, Location + (ExhaustPipes[i].ExhaustPosition >> Rotation), ExhaustPipes[i].ExhaustRotation + Rotation);
            else
                ExhaustPipes[i].ExhaustEffect = spawn(ExhaustEffectClass, self,, Location + (ExhaustPipes[i].ExhaustPosition >> Rotation), ExhaustPipes[i].ExhaustRotation + Rotation);

            ExhaustPipes[i].ExhaustEffect.SetBase(self);
        }
    }

    bEmittersOn = true;
}

function ServerStartEngine()
{
//  local Pawn P; // not used

    if (!bEngineDead) //can't turn Engine on or off if its Dead
    {
        if (!bEngineOff)
        {
            if (Throttle != 0) //cannot turn off while moving
            return;

            //so that people can't spam the ignition switch
            if (Level.TimeSeconds - IgnitionSwitchTime > 4.0)
            {

                if (AmbientSound != none)
                AmbientSound = none;

                if (ShutDownSound != none)
                PlaySound(ShutDownSound, SLOT_none, 1.0, , 300.0);

                Throttle=0;
                ThrottleAmount=0;
                bDisableThrottle=true;
                bEngineOff=true;

                TurnDamping = 0.0;
                IgnitionSwitchTime = Level.TimeSeconds;
            }
        }
        else
        {
            if (Level.TimeSeconds - IgnitionSwitchTime > 4.0)
            {
                if (StartUpSound != none)
                PlaySound(StartUpSound, SLOT_none, 1.0, , 300.0);

                if (IdleSound != none)
                AmbientSound = IdleSound;

                Throttle=0;
                bDisableThrottle=false;
                bEngineOff=false;

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

        bSuperDriverLeave = Super.KDriverLeave(bForceLeave);

        OldVel.Z += 75;
        Instigator.AddVelocity(OldVel);

        return bSuperDriverLeave;
    }
    else
        Super.KDriverLeave(bForceLeave);
}

function bool PlaceExitingDriver()
{
    local int i;
    local vector Extent, HitLocation, HitNormal, ZOffset, ExitPosition;
    local array<ExitPositionPair> ExitPositionPairs;

    if (Driver == none)
    {
        return false;
    }

    Extent = Driver.default.CollisionRadius * vect(1, 1, 0);
    Extent.Z = Driver.default.CollisionHeight;
    ZOffset = Driver.default.CollisionHeight * vect(0, 0, 0.5);

    ExitPositionPairs.Length = ExitPositions.Length;

    for (i = 0; i < ExitPositions.Length; ++i)
    {
        ExitPositionPairs[i].Index = i;
        ExitPositionPairs[i].DistanceSquared = VSizeSquared(DrivePos - ExitPositions[i]);
    }

    InsertSortEPPArray(ExitPositionPairs, 0, ExitPositionPairs.Length - 1);

    if (bDebugExitPositions)
    {
        for (i = 0; i < ExitPositionPairs.Length; ++i)
        {
            ExitPosition = Location + (ExitPositions[ExitPositionPairs[i].Index] >> Rotation) + ZOffset;

            Spawn(class'RODebugTracer',,, ExitPosition);
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
        Damage = int(VSize(ImpactInfo.Other.Velocity) * 20.0 * ImpactDamageModifier()); // Matt: moved under this 'if' to avoid "accessed none" errors

        TakeDamage(Damage, Vehicle(ImpactInfo.Other), ImpactInfo.Pos, vect(0, 0, 0), class'DH_VehicleCollisionDamType');
    }
    else
    {
        TakeDamage(int(AccelMag * ImpactDamageModifier()) / ObjectCollisionResistance, self, ImpactInfo.Pos, vect(0.0,0.0,0.0), class'DH_VehicleCollisionDamType');
    }

    // FIXME - scale sound volume to damage amount
    if (ImpactDamageSounds.Length > 0)
    {
        PlaySound(ImpactDamageSounds[Rand(ImpactDamageSounds.Length - 1)], , TransientSoundVolume * 2.5);
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
    local float RandomExplModifier;

    RandomExplModifier = FRand();

    // Don't hurt us when we are destroying our own vehicle // why ?
    // if (!bSpikedVehicle)
    if (bResupplyVehicle)
    {
        HurtRadius(ExplosionDamage, ExplosionRadius, ExplosionDamageType, ExplosionMomentum, Location);
    }
    else
    {
        HurtRadius(ExplosionDamage * RandomExplModifier, ExplosionRadius * RandomExplModifier, ExplosionDamageType, ExplosionMomentum, Location);
    }

    AmbientSound = DestroyedBurningSound; // test
    SoundVolume = 255.0;
    SoundRadius = 600.0;

    if (!bDisintegrateVehicle)
    {
        ExplosionCount++;

        if (Level.NetMode != NM_DedicatedServer)
            ClientVehicleExplosion(false);

        LinearImpulse = PercentMomentum * RandRange(DestructionLinearMomentum.Min, DestructionLinearMomentum.Max) * MomentumNormal;
        AngularImpulse = PercentMomentum * RandRange(DestructionAngularMomentum.Min, DestructionAngularMomentum.Max) * VRand();

        NetUpdateTime = Level.TimeSeconds - 1;
        KAddImpulse(LinearImpulse, vect(0,0,0));
        KAddAngularImpulse(AngularImpulse);
    }
}

// Handle the engine damage
function DamageEngine(int Damage, Pawn instigatedBy, vector Hitlocation, vector Momentum, class<DamageType> DamageType)
{
    local int actualDamage;

    if (EngineHealth > 0)
    {
        actualDamage = Level.Game.ReduceDamage(Damage, self, instigatedBy, HitLocation, Momentum, DamageType);
        EngineHealth -= actualDamage;
    }

    //Heavy damage to engine slows vehicle way down...
    if (EngineHealth <= (EngineHealthMax * 0.25) && EngineHealth > 0)
    {
        Throttle = FClamp(Throttle, -0.50, 0.50);
    }
    else if (EngineHealth <= 0)
    {
        if (bDebuggingText)
            Level.Game.Broadcast(self, "Vehicle Engine is Dead");

        bDisableThrottle=true;
        bEngineDead=true;

        IdleSound=VehicleBurningSound;
        StartUpSound=none;
        ShutDownSound=none;
        AmbientSound=VehicleBurningSound;
        SoundVolume=255;
        SoundRadius=600;
    }
}

//Vehicle has been in the middle of nowhere with no driver for a while, so consider resetting it
//  called after ResetTime has passed since driver left
// Overriden so we can control the time it takes for the vehicle to disappear - Ramm
//
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

    foreach CollidingActors(class 'Pawn', P, 4000.0) //was 4000.0
    {
        if (P != self && P.Controller != none && P.GetTeamNum() == GetTeamNum())  //traces only work on friendly players nearby
        {
            if (ROPawn(P) != none && (VSize(P.Location - Location) < DriverTraceDist)) //was 2000 - server problems?
            {
               if (bDebuggingText)
               Level.Game.Broadcast(self, "Initiating Collision Reset Check...");

                ResetTime = Level.TimeSeconds + IdleTimeBeforeReset;
                return;
            }
            else if (FastTrace(P.Location + P.CollisionHeight * vect(0,0,1), Location + CollisionHeight * vect(0,0,1)))
            {
                if (bDebuggingText)
                Level.Game.Broadcast(self, "Initiating FastTrace Reset Check...");

                ResetTime = Level.TimeSeconds + IdleTimeBeforeReset;
                return;
            }
        }
    }

    //if factory is active, we want it to spawn new vehicle NOW
    if (ParentFactory != none)
    {

        if (bDebuggingText)
        Level.Game.Broadcast(self, "Player not found.Respawn.");

        ParentFactory.VehicleDestroyed(self);
        ParentFactory.Timer();
        ParentFactory = none; //so doesn't call ParentFactory.VehicleDestroyed() again in Destroyed()
    }

    Destroy();
}

function Died(Controller Killer, class<DamageType> DamageType, vector HitLocation)
{
    super.Died(Killer, DamageType, HitLocation);

    if (Killer == none)
        return;

    DarkestHourGame(Level.Game).ScoreVehicleKill(Killer, self, PointValue);
}

simulated event DestroyAppearance()
{
    local int i;
    local KarmaParams KP;

    // For replication
    bDestroyAppearance = true;

    // Put brakes on
    Throttle    = 0;
    Steering    = 0;
    Rise        = 0;

    // Destroy the weapons
    if (Role == ROLE_Authority)
    {
        for(i=0;i<Weapons.Length;i++)
        {
            if (Weapons[i] != none)
                Weapons[i].Destroy();
        }
        for(i=0;i<WeaponPawns.Length;i++)
            WeaponPawns[i].Destroy();
    }
    Weapons.Length = 0;
    WeaponPawns.Length = 0;

    // Destroy the effects
    if (Level.NetMode != NM_DedicatedServer)
    {
        bNoTeamBeacon = true;

        for(i=0;i<HeadlightCorona.Length;i++)
            HeadlightCorona[i].Destroy();
        HeadlightCorona.Length = 0;

        if (HeadlightProjector != none)
            HeadlightProjector.Destroy();

        for(i=0; i<Dust.Length; i++)
        {
            if (Dust[i] != none)
                Dust[i].Kill();
        }

        Dust.Length = 0;

        for(i=0; i<ExhaustPipes.Length; i++)
        {
            if (ExhaustPipes[i].ExhaustEffect != none)
            {
                ExhaustPipes[i].ExhaustEffect.Kill();
            }
        }
    }

    // Copy linear velocity from actor so it doesn't just stop.
    KP = KarmaParams(KParams);
    if (KP != none)
        KP.KStartLinVel = Velocity;

    if (DamagedEffect != none)
    {
        DamagedEffect.Kill();
    }

    // Become the dead vehicle mesh
    SetPhysics(PHYS_none);
    KSetBlockKarma(false);
    SetDrawType(DT_StaticMesh);
    SetStaticMesh(DestroyedVehicleMesh);
    KSetBlockKarma(true);
    SetPhysics(PHYS_Karma);
    Skins.length = 0;
    NetPriority = 2;
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

defaultproperties
{
     ObjectCollisionResistance=1.000000
     EngineHealthMax=30
     bEngineOff=true
     VehicleBurningSound=Sound'Amb_Destruction.Fire.Krasnyi_Fire_House02'
     DestroyedBurningSound=Sound'Amb_Destruction.Fire.Kessel_Fire_Small_Barrel'
     DamagedStartUpSound=Sound'DH_AlliedVehicleSounds2.Damaged.engine_start_damaged'
     PointValue=1.000000
     DriverTraceDist=4500.000000
     DestructionEffectClass=Class'AHZ_ROVehicles.ATCannonDestroyedEmitter'
     DisintegrationEffectClass=Class'ROEffects.ROVehicleDestroyedEmitter'
     DisintegrationEffectLowClass=Class'ROEffects.ROVehicleDestroyedEmitter_simple'
     ExplosionSoundRadius=1000.000000
     ExplosionDamage=325.000000
     ExplosionRadius=700.000000
     DamagedEffectHealthSmokeFactor=0.750000
     DamagedEffectHealthMediumSmokeFactor=0.500000
     DamagedEffectHealthHeavySmokeFactor=0.250000
     DamagedEffectHealthFireFactor=0.150000
     ImpactDamageTicks=2.000000
     ImpactDamageThreshold=20.000000
     ImpactDamageMult=0.500000
     IdleTimeBeforeReset=90.000000
     VehicleSpikeTime=30.000000
     EngineHealth=30
     ObjectiveGetOutDist=1500.000000
     bKeepDriverAuxCollision=true
     HealthMax=175.000000
     Health=175
}
