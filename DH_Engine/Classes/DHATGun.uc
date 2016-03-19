//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DHATGun extends DHArmoredVehicle
    abstract;

#exec OBJ LOAD FILE=..\Textures\DH_Artillery_tex.utx
#exec OBJ LOAD FILE=..\StaticMeshes\DH_Artillery_stc.usx

// The following functions are empty functions, as AT guns have no treads, engine, movement, fire (burning), resupply or self-destruct if empty:
simulated function PostNetReceive();
function Fire(optional float F);
function ServerStartEngine();
simulated function SetEngine();
simulated function StopEmitters();
simulated function StartEmitters();
simulated function UpdateMovementSound(float MotionSoundVolume);
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

// Modified as nearly everything in DHArmoredVehicle is irrelevant to AT gun
simulated function PostBeginPlay()
{
    super(Vehicle).PostBeginPlay();

    if (HasAnim(BeginningIdleAnim))
    {
        PlayAnim(BeginningIdleAnim);
    }

    // Set up new NotifyParameters object
    if (Level.NetMode != NM_DedicatedServer)
    {
        NotifyParameters = new class'ObjectMap';
        NotifyParameters.Insert("VehicleClass", Class);
    }
}

// Modified as everything in DHArmoredVehicle & ROWheeledVehicle is irrelevant to AT gun
simulated function PostNetBeginPlay()
{
    super(ROVehicle).PostNetBeginPlay();
}

// Disabled as nothing in Tick is relevant to an AT gun (to be on the safe side, MinBrakeFriction is set very high in default properties, so gun won't slide down a hill)
simulated function Tick(float DeltaTime)
{
    Disable('Tick');
}

// Modified to allow human to kick bot off a gun & to remove stuff not relevant to an AT gun
function bool TryToDrive(Pawn P)
{
    // Deny entry if gun has 'driver' or is dead, or if player on fire or reloading a weapon (plus several very obscure other reasons)
    if (Driver != none || Health <= 0 || P == none || (DHPawn(P) != none && DHPawn(P).bOnFire) || (P.Weapon != none && P.Weapon.IsInState('Reloading')) ||
        P.Controller == none || !P.Controller.bIsPlayer || P.DrivenVehicle != none || P.IsA('Vehicle') || bNonHumanControl || !Level.Game.CanEnterVehicle(self, P))
    {
        return false;
    }

    // Trying to enter a gun that isn't on our team
    if (P.GetTeamNum() != VehicleTeam)
    {
        // Deny entry to TeamLocked enemy gun or non-TeamLocked gun that already has an enemy occupant
        if (bTeamLocked || (Driver != none && P.GetTeamNum() != Driver.GetTeamNum()) || (WeaponPawns[0].Driver != none && P.GetTeamNum() != WeaponPawns[0].Driver.GetTeamNum()))
        {
            DisplayVehicleMessage(1, P); // can't use enemy gun

            return false;
        }
    }

    // The gun is already manned
    if (WeaponPawns[0].Driver != none)
    {
        // Deny entry if gun is already manned by a human, or a bot is trying to man a gun already occupied by another bot
        if (WeaponPawns[0].IsHumanControlled() || !P.IsHumanControlled())
        {
            DisplayVehicleMessage(3, P); // gun is crewed

            return false;
        }

        // A human player wants to enter a gun manned by a bot, so kick the bot off the gun
        WeaponPawns[0].KDriverLeave(true);
    }

    // Passed all checks, so allow player to man the gun
    if (bEnterringUnlocks && bTeamLocked)
    {
        bTeamLocked = false;
    }

    KDriverEnter(P);

    return true;
}

// Overridden to bypass attaching as a driver and go straight to the gun
function KDriverEnter(Pawn P)
{
    if (WeaponPawns.Length > 0)
    {
        WeaponPawns[0].KDriverEnter(P); // attach to the first WeaponPawn, do not pass "Go" :-)
    }
}

// Overridden to bypass attaching as a driver and go straight to the gun
simulated function ClientKDriverEnter(PlayerController PC)
{
    if (WeaponPawns.Length > 0)
    {
        WeaponPawns[0].ClientKDriverEnter(PC); // attach to the first WeaponPawn, do not pass "Go" :-)
    }
}

// Modified to use a different AT cannon message class
function DisplayVehicleMessage(int MessageNumber, optional Pawn P, optional bool bPassController)
{
    if (P == none)
    {
        P = self;
    }

    if (bPassController) // option to pass pawn's controller as the OptionalObject, so it can be used in building the message
    {
        P.ReceiveLocalizedMessage(class'DHATCannonMessage', MessageNumber,,, Controller);
    }
    else
    {
        P.ReceiveLocalizedMessage(class'DHATCannonMessage', MessageNumber);
    }
}

// Modified to remove lots of irrelevant tank stuff & to use APCDamageModifier instead of TankDamageModifier
function TakeDamage(int Damage, Pawn InstigatedBy, vector HitLocation, vector Momentum, class<DamageType> DamageType, optional int HitIndex)
{
    local float VehicleDamageMod;
    local int   i;

    // Fix for suicide death messages
    if (DamageType == class'Suicided' || DamageType == class'ROSuicided')
    {
        super(Vehicle).TakeDamage(Damage, InstigatedBy, HitLocation, Momentum, class'ROSuicided');

        return;
    }

    // Set damage modifier from the DamageType
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

    // Add in the DamageType's vehicle damage modifier & a little damage randomisation
    Damage *= VehicleDamageMod * RandRange(0.75, 1.08);

    // Exit if no damage
    if (Damage < 1)
    {
        return;
    }

    // Check RO VehHitpoints, but only for any ammo store (AT gun has no driver or engine)
    for (i = 0; i < VehHitpoints.Length; ++i)
    {
        if (VehHitpoints[i].HitPointType == HP_AmmoStore && IsPointShot(HitLocation, Momentum, 1.0, i))
        {
            if (bDebuggingText)
            {
                Level.Game.Broadcast(self, "Hit AT gun ammo store");
            }

            Damage *= VehHitpoints[i].DamageMultiplier;
            break;
        }
    }

    // Call the Super from Vehicle (skip over others)
    super(Vehicle).TakeDamage(Damage, InstigatedBy, HitLocation, Momentum, DamageType);
}

defaultproperties
{
    bNetNotify=false // AT gun doesn't use PostNetReceive() as engine on/off, damaged tracks & hull fires are all irrelevant to it
    bNeverReset=true // AT gun never re-spawns if left unattended with no friendlies nearby or is left disabled
    PointValue=2.0
    DisintegrationEffectClass=class'ROEffects.ROVehicleDestroyedEmitter'
    DisintegrationEffectLowClass=class'ROEffects.ROVehicleDestroyedEmitter_simple'
    DisintegrationHealth=-1000000000.0
    DestructionLinearMomentum=(Min=0.0,Max=0.0)
    DestructionAngularMomentum=(Min=0.0,Max=0.0)
    DamagedEffectClass=class'AHZ_ROVehicles.ATCannonDamagedEffect'
    bMustBeTankCommander=false
    bMultiPosition=false
    TouchMessage="Use the "
    VehicleMass=5.0
    ExitPositions(0)=(X=0.0,Y=0.0,Z=100.0)  // last resort (because we start at index 1 for a cannon pawn)
    ExitPositions(1)=(X=-100.0,Y=0.0,Z=0.0) // index 1 is gunner's 1st choice exit position
    ExitPositions(2)=(X=-150.0,Y=0.0,Z=0.0) // all the rest are generic fallbacks to try different positions to try & get the player off the gun
    ExitPositions(3)=(X=-100.0,Y=25.0,Z=0.0)
    ExitPositions(4)=(X=-100.0,Y=-25.0,Z=0.0)
    ExitPositions(5)=(X=-100.0,Y=50.0,Z=0.0)
    ExitPositions(6)=(X=-100.0,Y=-50.0,Z=0.0)
    ExitPositions(7)=(X=-50.0,Y=50.0,Z=0.0)
    ExitPositions(8)=(X=-50.0,Y=-50.0,Z=0.0)
    ExitPositions(9)=(X=-50.0,Y=50.0,Z=50.0)
    ExitPositions(10)=(X=-50.0,Y=-50.0,Z=50.0)
    ExitPositions(11)=(X=-75.0,Y=75.0,Z=50.0)
    ExitPositions(12)=(X=-75.0,Y=-75.0,Z=50.0)
    ExitPositions(13)=(X=-100.0,Y=0.0,Z=75.0)
    ExitPositions(14)=(X=-100.0,Y=75.0,Z=75.0)
    ExitPositions(15)=(X=-100.0,Y=-75.0,Z=75.0)
    VehicleNameString="AT gun"
    MaxDesireability=1.9
    bSpecialHUD=false
    CollisionRadius=75.0
    CollisionHeight=100.0
    MinBrakeFriction=40.0
    VehHitpoints(0)=(PointRadius=0.0,PointBone="",DamageMultiplier=0.0) // remove inherited values from vehicle classes
    VehHitpoints(1)=(PointRadius=0.0,PointBone="",DamageMultiplier=0.0)
    Begin Object Class=KarmaParamsRBFull Name=KParams0
        KInertiaTensor(0)=1.0
        KInertiaTensor(3)=3.0
        KInertiaTensor(5)=3.0
        KCOMOffset=(Z=-0.5)
        KLinearDamping=0.05
        KAngularDamping=0.05
        KStartEnabled=true
        bKNonSphericalInertia=true
        KMaxAngularSpeed=0.0 // default is 1.0 (AT gun can't move, so KParams is probably an unnecessary override)
        bHighDetailOnly=false
        bClientOnly=false
        bKDoubleTickRate=true
        bDestroyOnWorldPenetrate=true
        bDoSafetime=true
        KFriction=0.5
        KImpactThreshold=700.0
    End Object
    KParams=KarmaParamsRBFull'DH_Engine.DHATGun.KParams0'
}
