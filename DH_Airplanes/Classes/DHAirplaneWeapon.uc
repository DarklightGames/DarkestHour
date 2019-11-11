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
var array<DHAirplane.ETargetType> TargetTypes;

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

final static final function ArmWeapons(array<DHAirplaneWeapon> Weapons)
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
    return true;
}

defaultproperties
{
    RemoteRole=ROLE_SimulatedProxy
}
