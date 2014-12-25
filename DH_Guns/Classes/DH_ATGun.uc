//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_ATGun extends DH_ROTreadCraft
    abstract;

#exec OBJ LOAD FILE=..\textures\DH_Artillery_tex.utx
#exec OBJ LOAD FILE=..\StaticMeshes\DH_Artillery_stc.usx

var  DH_ATCannonFactoryBase   DHParentFactory;
var  ROVehicleFactory         ROParentFactory;

//The following functions are empty functions
simulated function UpdateMovementSound();          //removed due to no movement sound needed
simulated function SetupTreads();                  //removed due to no need to setup treads
simulated function DestroyTreads();                //removed due to no need to setup treads
function DamageTrack(bool bLeftTrack);             //removed due to no need to damage treads
event TakeFireDamage(float DeltaTime);             //removed due to no need for fire damage
function DamageEngine(int Damage, Pawn instigatedBy, vector Hitlocation, vector Momentum, class<DamageType> DamageType);   //removed due to no need to damage engine
//function bool ResupplyAmmo();                    //removed due to no need to resupply the gun
function MaybeDestroyVehicle();                    //removed so we don't destroy the Gun if abandoned
//function EnteredResupply();                      //removed due to no need to resupply the gun
//function LeftResupply();                         //removed due to no need to resupply the gun
function Timer();                                  //keeps the throttle disabled.
function Fire(optional float F);                   //don't need the fire stuff
function ServerStartEngine();                      //don't need the engine stuff
simulated function StartEngine();                  //don't need the engine stuff

// Returns true, an AT-Gun is always disabled (i.e. can not move)
simulated function bool IsDisabled()
{
    return true; //for now just return true.
}

// Overriden to bypass attaching as a driver and go straight to the gun.
simulated function ClientKDriverEnter(PlayerController PC)
{
    //Make sure there is a least one WeaponPawn.
    if (WeaponPawns.length > 0)
    {
        WeaponPawns[0].ClientKDriverEnter(PC);            //attach to the first WeaponPawn, do not pass "Go".  :-)
    }
}

// Overriden to bypass attaching as a driver and go straight to the gun.
function KDriverEnter(Pawn P)
{
    //Make sure there is a least one WeaponPawn.
    if (WeaponPawns.length > 0)
    {
        WeaponPawns[0].KDriverEnter(P);                   //attach to the first WeaponPawn, do not pass "Go".  :-)
    }
}

// DriverLeft() called by KDriverLeave()
function DriverLeft()
{
    super(ROWheeledVehicle).DriverLeft();      //Skip ROTreadCraft.
}

simulated function Destroyed()
{
    super(ROVehicle).Destroyed();       //Skip ROTreadCraft
}

simulated function Tick(float DeltaTime)
{
    // Only need these effects client side
    // Reworked from the original code in ROTreadCraft to drop evaluations
    if (Level.Netmode == NM_DedicatedServer && SoundVolume != default.SoundVolume)
        SoundVolume = default.SoundVolume;

    super(ROWheeledVehicle).Tick(DeltaTime);
}

// Overridden due to the Onslaught team lock not working in RO
function bool TryToDrive(Pawn P)
{
    local int x;

    if (DH_Pawn(P).bOnFire)
        return false;

    //don't allow vehicle to be stolen when somebody is in a turret
    if (!bTeamLocked && P.GetTeamNum() != VehicleTeam)
    {
        for (x = 0; x < WeaponPawns.length; x++)
            if (WeaponPawns[x].Driver != none)
            {
                DenyEntry(P, 2);
                return false;
            }
    }

    //Removed "P.bIsCrouched" to allow players to connect while crouched.
    if (bNonHumanControl || (P.Controller == none) || (Driver != none) || (P.DrivenVehicle != none) || !P.Controller.bIsPlayer
         || P.IsA('Vehicle') || Health <= 0)
        return false;

    if (!Level.Game.CanEnterVehicle(self, P))
        return false;

    // Check vehicle Locking....
    if (bTeamLocked && (P.GetTeamNum() != VehicleTeam))
    {

        DenyEntry(P, 1);
        return false;
    }
    else
    {
        //At this point we know the pawn is not a tanker, so let's see if they can use the gun
        if (bEnterringUnlocks && bTeamLocked)
            bTeamLocked = false;

        //The gun is manned and it is a human - deny entry
        if (WeaponPawns[0].Driver != none && WeaponPawns[0].IsHumanControlled())
        {
            DenyEntry(P, 3);
            return false;
        }
        //The gun is manned by a bot and the requesting pawn is human controlled - kick the bot off the gun
        else if (WeaponPawns[0].Driver != none && !WeaponPawns[0].IsHumanControlled() && p.IsHumanControlled())
        {
            WeaponPawns[0].KDriverLeave(true);

            KDriverEnter(P);
            return true;
        }
        //The gun is manned by a bot and a bot is trying to use it, deny entry.
        else if (WeaponPawns[0].Driver != none && !WeaponPawns[0].IsHumanControlled() && !p.IsHumanControlled())
        {
            DenyEntry(P, 3);
            return false;
        }
        //The gun is unmanned, so let who ever is there first can use it.
        else
        {
            KDriverEnter(P);
            return true;
        }
    }
}

// Send a message on why they can't get in the vehicle
function DenyEntry(Pawn P, int MessageNum)
{
    P.ReceiveLocalizedMessage(class'DH_ATCannonMessage', MessageNum);
}

// TakeDamage - overloaded to prevent bayonet and bash attacks from damaging vehicles
//              for Tanks, we'll probably want to prevent bullets from doing damage too
function TakeDamage(int Damage, Pawn instigatedBy, vector HitLocation, vector Momentum, class<DamageType> DamageType, optional int HitIndex)
{

    local int i;
    local float VehicleDamageMod;
    local int HitPointDamage;
    //local int InstigatorTeam;
    //local controller InstigatorController;

    // Fix for suicide death messages
    if (DamageType == class'Suicided')
    {
        DamageType = class'ROSuicided';
        super(ROVehicle).TakeDamage(Damage, instigatedBy, Hitlocation, Momentum, damageType);
    }
    else if (DamageType == class'ROSuicided')
    {
        super(ROVehicle).TakeDamage(Damage, instigatedBy, Hitlocation, Momentum, damageType);
    }

    // Hacked in APC damage mods for AT Guns, but bullets/bayo/bashing still shouldn't work...
    if (DamageType != none)
    {
       if (class<ROWeaponDamageType>(DamageType) != none &&
       class<ROWeaponDamageType>(DamageType).default.APCDamageModifier >= 0.05)
       {
          VehicleDamageMod = class<ROWeaponDamageType>(DamageType).default.APCDamageModifier;
       }
       else if (class<ROVehicleDamageType>(DamageType) != none &&
       class<ROVehicleDamageType>(DamageType).default.APCDamageModifier >= 0.05)
       {
          VehicleDamageMod = class<ROVehicleDamageType>(DamageType).default.APCDamageModifier;
       }
    }

    if (bLogPenetration)
        Log("VehHitpoints and HitPointDamage start, damage = "$Damage);

    for (i = 0; i < VehHitpoints.Length; i++)
    {
        HitPointDamage=Damage;

        if (VehHitpoints[i].HitPointType == HP_Driver)
        {
            // Damage for large weapons
            if (class<ROWeaponDamageType>(DamageType) != none && class<ROWeaponDamageType>(DamageType).default.VehicleDamageModifier > 0.25)
            {
                if (Driver != none && DriverPositions[DriverPositionIndex].bExposed && IsPointShot(Hitlocation,Momentum, 1.0, i))
                {
                    //Level.Game.Broadcast(self, "Hit Driver"); //re-comment when fixed
                    Driver.TakeDamage(Damage, instigatedBy, Hitlocation, Momentum, damageType);
                }
            }
            // Damage for small (non penetrating) arms
            else
            {
                if (Driver != none && DriverPositions[DriverPositionIndex].bExposed && IsPointShot(Hitlocation,Momentum, 1.0, i, DriverHitCheckDist))
                {
                    //Level.Game.Broadcast(self, "Hit Driver");  //re-comment when fixed
                    Driver.TakeDamage(Damage, instigatedBy, Hitlocation, Momentum, damageType);
                }
            }
        }
        //An At-Gun does not have an engine. We will however, leave the ammo store because we need it to get around a
        //  collision issue with the gunner (player).
        else if (IsPointShot(Hitlocation,Momentum, 1.0, i))
        {
            HitPointDamage *= VehHitpoints[i].DamageMultiplier;
            HitPointDamage *= VehicleDamageMod;

            //Log("We hit "$GetEnum(enum'EPawnHitPointType',VehHitpoints[i].HitPointType));

            if (VehHitpoints[i].HitPointType == HP_AmmoStore)
            {
                Damage *= VehHitpoints[i].DamageMultiplier;
                break;
            }
        }

    }

    // Add in the Vehicle damage modifier for the actual damage to the vehicle itself
    Damage *= VehicleDamageMod;

    super(ROVehicle).TakeDamage(Damage, instigatedBy, Hitlocation, Momentum, damageType);

}

function exec DamageTank()
{
    Health /= 2;
}

defaultproperties
{
    UFrontArmorFactor=0.800000
    URightArmorFactor=0.800000
    ULeftArmorFactor=0.800000
    URearArmorFactor=0.800000
    PointValue=2.000000
    TreadVelocityScale=0.000000
    FrontLeftAngle=302.000000
    FrontRightAngle=58.000000
    RearRightAngle=122.000000
    RearLeftAngle=238.000000
    IdleRPM=0.000000
    EngineRPMSoundRange=0.000000
    bSpecialTankTurning=false
    ViewShakeRadius=100.000000
    ViewShakeOffsetFreq=1.000000
    DisintegrationEffectClass=class'ROEffects.ROVehicleDestroyedEmitter'
    DisintegrationEffectLowClass=class'ROEffects.ROVehicleDestroyedEmitter_simple'
    DisintegrationHealth=-1000000000.000000
    DestructionLinearMomentum=(Min=0.000000,Max=0.000000)
    DestructionAngularMomentum=(Min=0.000000,Max=0.000000)
    DamagedEffectClass=class'AHZ_ROVehicles.ATCannonDamagedEffect'
    bMustBeTankCommander=false
    VehicleHudEngineX=0.000000
    VehicleHudEngineY=0.000000
    EngineHealth=1
    bMultiPosition=false
    TouchMessage="Use the "
    VehicleMass=5.000000
    VehicleNameString="AT-Gun"
    RanOverDamageType=none
    CrushedDamageType=none
    RanOverSound=none
    StolenAnnouncement=
    MaxDesireability=1.900000
    WaterDamage=0.000000
    VehicleDrowningDamType=none
    bSpecialHUD=false
    CollisionRadius=75.000000
    CollisionHeight=100.000000
    Begin Object Class=KarmaParamsRBFull Name=KParams0
        KInertiaTensor(0)=1.000000
        KInertiaTensor(3)=3.000000
        KInertiaTensor(5)=3.000000
        KCOMOffset=(Z=-0.500000)
        KLinearDamping=0.050000
        KAngularDamping=0.050000
        KStartEnabled=true
        bKNonSphericalInertia=true
        KMaxAngularSpeed=0.000000
        bHighDetailOnly=false
        bClientOnly=false
        bKDoubleTickRate=true
        bDestroyOnWorldPenetrate=true
        bDoSafetime=true
        KFriction=0.500000
        KImpactThreshold=700.000000
    End Object
    KParams=KarmaParamsRBFull'DH_Guns.DH_ATGun.KParams0'
}
