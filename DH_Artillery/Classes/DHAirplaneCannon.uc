//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2019
//==============================================================================

class DHAirplaneCannon extends Actor
    abstract;

var DHAirplane          Airplane;

var Sound               FiringSound;
var class<Projectile>   ProjectileClass;
var vector              ProjectileOffset;
var class<Emitter>      EmitterClass;

var bool                bHasInfiniteAmmo;
var float               RoundsPerMinute;
var int                 AmmoCount;
var float               NextFireTime;

var rotator             SpreadMin;
var rotator             SpreadMax;

var bool                bIsFiring;

replication
{
    reliable if (Role == ROLE_Authority)
        bIsFiring;
}

function bool HasAmmo()
{
    return bHasInfiniteAmmo || AmmoCount > 0;
}

function StartFiring()
{
    if (CanFire())
    {
        GotoState('Firing');
    }
}

function StopFiring();

function bool CanFire()
{
    // TODO: in future, we could check if the gun is damaged in some way and unable to fire.
    return HasAmmo();
}

function float GetFiringInterval()
{
    if (RoundsPerMinute == 0)
    {
        // Avoid divide-by-zero errors.
        return 1.0;
    }

    return 60.0 / RoundsPerMinute;
}

state Firing
{
    function StopFiring()
    {
        GotoState('');
    }

    function BeginState()
    {
        bIsFiring = true;
        NextFireTime = Level.TimeSeconds;
        AmbientSound = FiringSound;
    }

    function EndState()
    {
        AmbientSound = none;
        bIsFiring = false;
    }

    function Tick(float DeltaTime)
    {
        local int i;
        local int ProjectileCount;

        if (HasAmmo() == false)
        {
            StopFiring();
            return;
        }

        if (Level.TimeSeconds >= NextFireTime)
        {
            // Calculate the number of projectiles to fire in this tick.
            ProjectileCount = Ceil((Level.TimeSeconds - NextFireTime) / GetFiringInterval());

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

function bool IsFiring()
{
    return IsInState('Firing');
}

function SpawnProjectile()
{
    local vector ProjectileLocation;
    local rotator ProjectileRotation;
    local RODebugTracer DT;

    ProjectileLocation = Location + (ProjectileOffset >> Rotation);
    ProjectileRotation = GetProjectileRotation();

    Log("(ProjectileOffset >> Rotation)" @ (ProjectileOffset >> Rotation));

    DT = Spawn(class'RODebugTracer',,, ProjectileLocation, ProjectileRotation);
    DT.LifeSpan = 10.0;

    Spawn(ProjectileClass,,, ProjectileLocation, ProjectileRotation);
}

function rotator GetProjectileRotation()
{
    local rotator Spread;

    Spread = class'URotator'.static.RandomRange(SpreadMin, SpreadMax);

    return QuatToRotator(QuatProduct(QuatFromRotator(Spread), QuatFromRotator(Rotation)));
}

defaultproperties
{
    bHasInfiniteAmmo=true
    ProjectileOffset=(X=512,Y=0,Z=0)
}

