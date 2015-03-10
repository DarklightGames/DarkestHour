//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DH_ATGun extends DH_ROTreadCraft
    abstract;

#exec OBJ LOAD FILE=..\Textures\DH_Artillery_tex.utx
#exec OBJ LOAD FILE=..\StaticMeshes\DH_Artillery_stc.usx

var  DH_ATCannonFactoryBase   DHParentFactory;
var  ROVehicleFactory         ROParentFactory;

// The following functions are empty functions, as AT guns have no treads, engine, movement, fire (burning), resupply or self-destruct if empty:
simulated function PostNetReceive();
function Fire(optional float F);
function ServerStartEngine();
simulated function SetEngine();
simulated function StopEmitters();
simulated function StartEmitters();
simulated function UpdateMovementSound();
function DamageEngine(int Damage, Pawn InstigatedBy, vector HitLocation, vector Momentum, class<DamageType> DamageType);
simulated function SetupTreads();
simulated function DestroyTreads();
function DamageTrack(bool bLeftTrack);
simulated function SetDamagedTracks();
function MaybeDestroyVehicle();
event CheckReset();
simulated function SetFireEffects();
function TakeFireDamage();
function TakeEngineFireDamage();
function StartHullFire(Pawn InstigatedBy);
function StartEngineFire(Pawn InstigatedBy);
simulated function StartDriverHatchFire();
function Timer();
simulated function SetNextTimer(optional float Now);
//function bool ResupplyAmmo();
//function EnteredResupply();
//function LeftResupply();

// Modified as nearly everything in DH_ROTreadCraft is irrelevant to AT gun
simulated function PostBeginPlay()
{
    super(Vehicle).PostBeginPlay();

    if (HasAnim(BeginningIdleAnim))
    {
        PlayAnim(BeginningIdleAnim);
    }
}

// Modified as everything in DH_ROTreadCraft is irrelevant to AT gun
simulated function PostNetBeginPlay()
{
    super(ROVehicle).PostNetBeginPlay();
}

// Overridden to bypass attaching as a driver and go straight to the gun
simulated function ClientKDriverEnter(PlayerController PC)
{
    if (WeaponPawns.Length > 0)
    {
        WeaponPawns[0].ClientKDriverEnter(PC); // attach to the first WeaponPawn, do not pass "Go" :-)
    }
}

// Overridden to bypass attaching as a driver and go straight to the gun
function KDriverEnter(Pawn P)
{
    if (WeaponPawns.Length > 0)
    {
        WeaponPawns[0].KDriverEnter(P); // attach to the first WeaponPawn, do not pass "Go" :-)
    }
}

function DriverLeft()
{
    super(ROWheeledVehicle).DriverLeft(); // skip ROTreadCraft
}

simulated function Destroyed()
{
    super(ROVehicle).Destroyed(); // skip ROTreadCraft
}

simulated function Tick(float DeltaTime)
{
    // Only need these effects client side
    // Reworked from the original code in ROTreadCraft to drop evaluations
    if (Level.NetMode == NM_DedicatedServer && SoundVolume != default.SoundVolume)
    {
        SoundVolume = default.SoundVolume;
    }

    super(ROWheeledVehicle).Tick(DeltaTime);
}

function bool TryToDrive(Pawn P)
{
    local int x;

    if (DH_Pawn(P).bOnFire)
    {
        return false;
    }

    // Don't allow vehicle to be stolen when somebody is in a turret
    if (!bTeamLocked && P.GetTeamNum() != VehicleTeam)
    {
        for (x = 0; x < WeaponPawns.Length; x++)
        {
            if (WeaponPawns[x].Driver != none)
            {
                DenyEntry(P, 2);

                return false;
            }
        }
    }

    // Removed "P.bIsCrouched" to allow players to connect while crouched
    if (bNonHumanControl || P.Controller == none || Driver != none || P.DrivenVehicle != none || !P.Controller.bIsPlayer || P.IsA('Vehicle') || Health <= 0 || !Level.Game.CanEnterVehicle(self, P))
    {
        return false;
    }

    // Check vehicle locking
    if (bTeamLocked && P.GetTeamNum() != VehicleTeam)
    {
        DenyEntry(P, 1);

        return false;
    }
    else
    {
        // At this point we know the pawn is not a tanker, so let's see if they can use the gun
        if (bEnterringUnlocks && bTeamLocked)
        {
            bTeamLocked = false;
        }

        // The gun is manned and it is a human - deny entry
        if (WeaponPawns[0].Driver != none && WeaponPawns[0].IsHumanControlled())
        {
            DenyEntry(P, 3);

            return false;
        }
        // The gun is manned by a bot and the requesting pawn is human controlled - kick the bot off the gun
        else if (WeaponPawns[0].Driver != none && !WeaponPawns[0].IsHumanControlled() && p.IsHumanControlled())
        {
            WeaponPawns[0].KDriverLeave(true);
            KDriverEnter(P);

            return true;
        }
        // The gun is manned by a bot and a bot is trying to use it - deny entry
        else if (WeaponPawns[0].Driver != none && !WeaponPawns[0].IsHumanControlled() && !p.IsHumanControlled())
        {
            DenyEntry(P, 3);

            return false;
        }
        // The gun is unmanned, so let who ever is there first can use it
        else
        {
            KDriverEnter(P);

            return true;
        }
    }
}

// Modified to use a different AT cannon message class
function DenyEntry(Pawn P, int MessageNum)
{
    P.ReceiveLocalizedMessage(class'DH_ATCannonMessage', MessageNum);
}

function TakeDamage(int Damage, Pawn InstigatedBy, vector HitLocation, vector Momentum, class<DamageType> DamageType, optional int HitIndex)
{
    local float VehicleDamageMod;
    local int   i;

    // Fix for suicide death messages
    if (DamageType == class'Suicided')
    {
        DamageType = class'ROSuicided';

        super(ROVehicle).TakeDamage(Damage, InstigatedBy, HitLocation, Momentum, DamageType);
    }
    else if (DamageType == class'ROSuicided')
    {
        super(ROVehicle).TakeDamage(Damage, InstigatedBy, HitLocation, Momentum, DamageType);
    }

    // Hacked in APC damage mods for AT Guns, but bullets/bayo/bashing still shouldn't work...
    if (DamageType != none)
    {
        if (class<ROWeaponDamageType>(DamageType) != none && class<ROWeaponDamageType>(DamageType).default.APCDamageModifier >= 0.05)
        {
            VehicleDamageMod = class<ROWeaponDamageType>(DamageType).default.APCDamageModifier;
        }
        else if (class<ROVehicleDamageType>(DamageType) != none && class<ROVehicleDamageType>(DamageType).default.APCDamageModifier >= 0.05)
        {
            VehicleDamageMod = class<ROVehicleDamageType>(DamageType).default.APCDamageModifier;
        }
    }

    if (bLogPenetration)
    {
        Log("VehHitpoints start: Damage =" @ Damage);
    }

    for (i = 0; i < VehHitpoints.Length; ++i)
    {
        if (VehHitpoints[i].HitPointType == HP_Driver)
        {
            // Damage for large weapons
            if (class<ROWeaponDamageType>(DamageType) != none && class<ROWeaponDamageType>(DamageType).default.VehicleDamageModifier > 0.25)
            {
                if (Driver != none && DriverPositions[DriverPositionIndex].bExposed && IsPointShot(HitLocation,Momentum, 1.0, i))
                {
                    Driver.TakeDamage(Damage, InstigatedBy, HitLocation, Momentum, DamageType);
                }
            }
            // Damage for small (non penetrating) arms
            else
            {
                if (Driver != none && DriverPositions[DriverPositionIndex].bExposed && IsPointShot(HitLocation,Momentum, 1.0, i, DriverHitCheckDist))
                {
                    Driver.TakeDamage(Damage, InstigatedBy, HitLocation, Momentum, DamageType);
                }
            }
        }
        // An AT gun does not have an engine - we will however leave the ammo store because we need it to get around a collision issue with the gunner (player)
        else if (IsPointShot(HitLocation,Momentum, 1.0, i))
        {
            if (VehHitpoints[i].HitPointType == HP_AmmoStore)
            {
                Damage *= VehHitpoints[i].DamageMultiplier;
                break;
            }
        }
    }

    // Add in the vehicle damage modifier for the actual damage to the vehicle itself
    Damage *= VehicleDamageMod;

    super(ROVehicle).TakeDamage(Damage, InstigatedBy, HitLocation, Momentum, DamageType);
}

exec function DamageTank()
{
    Health /= 2;
}

defaultproperties
{
    bNetNotify=false
    UFrontArmorFactor=0.8
    URightArmorFactor=0.8
    ULeftArmorFactor=0.8
    URearArmorFactor=0.8
    PointValue=2.0
    TreadVelocityScale=0.0
    FrontLeftAngle=302.0
    FrontRightAngle=58.0
    RearRightAngle=122.0
    RearLeftAngle=238.0
    IdleRPM=0.0
    EngineRPMSoundRange=0.0
    bSpecialTankTurning=false
    ViewShakeRadius=100.0
    ViewShakeOffsetFreq=1.0
    DisintegrationEffectClass=class'ROEffects.ROVehicleDestroyedEmitter'
    DisintegrationEffectLowClass=class'ROEffects.ROVehicleDestroyedEmitter_simple'
    DisintegrationHealth=-1000000000.0
    DestructionLinearMomentum=(Min=0.0,Max=0.0)
    DestructionAngularMomentum=(Min=0.0,Max=0.0)
    DamagedEffectClass=class'AHZ_ROVehicles.ATCannonDamagedEffect'
    bMustBeTankCommander=false
    VehicleHudEngineX=0.0
    VehicleHudEngineY=0.0
    EngineHealth=1
    bMultiPosition=false
    TouchMessage="Use the "
    VehicleMass=5.0
    VehicleNameString="AT-Gun"
    RanOverDamageType=none
    CrushedDamageType=none
    RanOverSound=none
    StolenAnnouncement=
    MaxDesireability=1.9
    WaterDamage=0.0
    VehicleDrowningDamType=none
    bSpecialHUD=false
    CollisionRadius=75.0
    CollisionHeight=100.0
    Begin Object Class=KarmaParamsRBFull Name=KParams0
        KInertiaTensor(0)=1.0
        KInertiaTensor(3)=3.0
        KInertiaTensor(5)=3.0
        KCOMOffset=(Z=-0.5)
        KLinearDamping=0.05
        KAngularDamping=0.05
        KStartEnabled=true
        bKNonSphericalInertia=true
        KMaxAngularSpeed=0.0
        bHighDetailOnly=false
        bClientOnly=false
        bKDoubleTickRate=true
        bDestroyOnWorldPenetrate=true
        bDoSafetime=true
        KFriction=0.5
        KImpactThreshold=700.0
    End Object
    KParams=KarmaParamsRBFull'DH_Guns.DH_ATGun.KParams0'
}
