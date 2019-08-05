//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2019
//==============================================================================

class DHAirplaneCannon extends Actor
    abstract;

var DHAirplane          Airplane;

var Sound               FiringSound;
var class<Projectile>   ProjectileClass;
var class<Emitter>      EmitterClass;
var bool                bIsFiring;

var bool                bHasInfiniteAmmo;
var float               RoundsPerMinute;
var int                 AmmoCount;
var float               NextFireTime;

var rotator             SpreadMin;
var rotator             SpreadMax;

function bool HasAmmo()
{
    return AmmoCount > 0;
}

function bool IsFiring()
{
    return bIsFiring;
}

function StartFiring()
{
    if (bIsFiring)
    {
        return;
    }

    AmbientSound = FiringSound;

    bIsFiring = true;
}

function StopFiring()
{
    if (bIsFiring == false)
    {
        return;
    }

    bIsFiring = true;
    AmbientSound = none;
}

function bool CanFire()
{
    // TODO: in future, we could check if the gun is damaged in some way and unable to fire.
    return HasAmmo();
}

function float GetFiringInterval()
{
    return 60.0 / RoundsPerMinute;
}

function Tick(float DeltaTime)
{
    local int i, ProjectileCount;

    if (bIsFiring && HasAmmo())
    {
        if (Level.TimeSeconds >= NextFireTime)
        {
            // Calculate the number of projectiles to fire in this tick.
            ProjectileCount = Ceil((NextFireTime - Level.TimeSeconds) / GetFiringInterval());

            // Spawn the projectiles.
            for (i = 0; i < ProjectileCount; ++i)
            {
                SpawnProjectile();
            }

            // Set the next fire time.
            NextFireTime += GetFiringInterval() * ProjectileCount;

            if (bHasInfiniteAmmo == false)
            {
                // Decrement ammo count.
                AmmoCount -= 1;

                if (AmmoCount == 0)
                {
                    // No more ammunition, stop firing.
                    StopFiring();
                }
            }
        }
    }
}

function SpawnProjectile()
{
    Spawn(ProjectileClass,,, Location, GetProjectileRotation());
}

function rotator GetProjectileRotation()
{
    local rotator Spread;

    Spread = class'URotator'.static.RandomRange(SpreadMin, SpreadMax);

    return QuatToRotator(QuatProduct(QuatFromRotator(Spread), QuatFromRotator(Rotation)));
}

defaultproperties
{
}

