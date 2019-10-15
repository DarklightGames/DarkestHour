//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2019
//==============================================================================

class DHAirplaneWeapon extends Actor
    dependson(DHAirplane)
    abstract;

enum EWeaponType
{
    WEAPON_MachineGun,
    WEAPON_AutoCannon,
    WEAPON_Rocket,
    WEAPON_Bomb
};

enum EMountAxis
{
    MOUNT_Center,
    MOUNT_Left,
    MOUNT_Right
};

var DHAirplane          Airplane;
var DHAirplaneTarget    Target;

var EWeaponType         WeaponType;
var int                 WeaponInfo;

// Projectile
var class<Projectile>   ProjectileClass;
var vector              ProjectileOffset;

// Ammunition
var bool                bHasInfiniteAmmo;
var float               RoundsPerMinute;
var int                 AmmoCount;
var int                 MaxAmmo;

// Spread
var rotator             SpreadMin;
var rotator             SpreadMax;

// Weapon balancing
var EMountAxis          MountAxis;
var DHAirplaneWeapon    WeaponPair;

// Targetting
var array<DHAirplaneTarget.ETargetType> TargetTypes;

simulated function PostBeginPlay()
{
    if (Role == ROLE_Authority)
    {
        Airplane = DHAirplane(Owner);

        if (Airplane != none)
        {
            Target = Airplane.Target;
        }
    }
}

simulated function DHAirplane GetAirplane()
{
    return DHAirplane(Owner);
}

function bool HasAmmo()
{
    return bHasInfiniteAmmo || AmmoCount > 0;
}

function bool CanFire()
{
    // TODO: in future, we could check if the gun is damaged in some way and unable to fire.
    return HasAmmo();
}

function SpawnProjectile()
{
    local vector ProjectileLocation;
    local rotator ProjectileRotation;

    ProjectileLocation = Location + (ProjectileOffset >> Rotation);
    ProjectileRotation = GetProjectileRotation();

    Spawn(ProjectileClass,,, ProjectileLocation, ProjectileRotation);
}

function rotator GetProjectileRotation()
{
    local rotator Spread;

    Spread = class'URotator'.static.RandomRange(SpreadMin, SpreadMax);

    return QuatToRotator(QuatProduct(QuatFromRotator(Spread), QuatFromRotator(Rotation)));
}

function Resupply()
{
    AmmoCount = MaxAmmo;
}

function Arm();
function Fire();
function StopFiring();
function StartFiring();

// WEAPON ARRAYS

static final function array<DHAirplaneWeapon> GetWeaponsForCluster(array<DHAirplaneWeapon> Weapons, array<Actor> Targets)
{
    local array<DHAirplaneWeapon> ValidWeapons;
    local int i;

    if (Targets.Length == 0)
    {
        return ValidWeapons;
    }

    for (i = 0; i < Weapons.Length; ++i)
    {
        if (Weapons[i] == none)
        {
            continue;
        }

        if (Weapons[i].CanDamageCluster(Targets))
        {
            ValidWeapons[ValidWeapons.Length] = Weapons[i];
        }
    }

    return ValidWeapons;
}

static final function ArmWeapons(array<DHAirplaneWeapon> Weapons)
{
    local int i;

    for (i = 0; i < Weapons.Length; ++i)
    {
        Weapons[i].Arm();

        if (Weapons[i].WeaponPair != none)
        {
            Weapons[i].WeaponPair.Arm();
        }
    }
}

static function bool CanDamageTargetType(DHAirplane.ETargetType TargetType)
{
    local int i;

    for (i = 0; i < default.TargetTypes.Length; ++i)
    {
        if (default.TargetTypes[i] == TargetType)
        {
            return true;
        }
    }
}

static function bool CanDamageActor(Actor A)
{
    local DHAirplane.ETargetType TargetType;

    if (A == none)
    {
        return false;
    }

    TargetType = class'DHAirplane'.static.GetTargetType(A);

    if (CanDamageTargetType(TargetType))
    {
        return true;
    }
}

// Returns true, if cluster contains at least 1 valid target.
static function bool CanDamageCluster(array<Actor> Actors)
{
    local int i;

    for (i = 0; i < Actors.Length; ++i)
    {
        if (Actors[i] == none)
        {
            continue;
        }

        if (CanDamageActor(Actors[i]))
        {
            return true;
        }
    }
}

defaultproperties
{
    RemoteRole=ROLE_SimulatedProxy
}
