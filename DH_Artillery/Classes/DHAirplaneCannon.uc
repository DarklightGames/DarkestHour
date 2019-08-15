//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2019
//==============================================================================

class DHAirplaneCannon extends Actor
    abstract;

var int                 CannonIndex;

// Projectile
var class<Projectile>   ProjectileClass;
var vector              ProjectileOffset;

// Ammunition
var bool                bHasInfiniteAmmo;
var float               RoundsPerMinute;
var int                 AmmoCount;
var float               NextFireTime;

// Spread
var rotator             SpreadMin;
var rotator             SpreadMax;

// Firing effects
var Sound               FiringAmbientSound;
var Emitter             FiringEmitter;
var class<Emitter>      FiringEmitterClass;
var vector              FiringEmitterOffset;

var bool                bIsPlayingFiringEffects;
var private bool        bIsFiring;  // Replicated variable used to signal to the client to begin playing firing effects.

replication
{
    reliable if (Role == ROLE_Authority)
        bIsFiring;
}

simulated function DHAirplane GetAirplane()
{
    return DHAirplane(Owner);
}

simulated function PostNetReceive()
{
    if (Level.NetMode != NM_DedicatedServer)
    {
        if (bIsFiring && !bIsPlayingFiringEffects)
        {
            PlayFiringEffects();
        }
        else if (!bIsFiring && bIsPlayingFiringEffects)
        {
            StopFiringEffects();
        }
    }
}

simulated function PlayFiringEffects()
{
    if (Level.NetMode == NM_DedicatedServer)
    {
        return;
    }

    if (bIsPlayingFiringEffects)
    {
        return;
    }

    if (FiringEmitter != none)
    {
        FiringEmitter.Destroy();
    }

    if (FiringEmitterClass != none)
    {
        FiringEmitter = Spawn(FiringEmitterClass, self);

        if (FiringEmitter != none)
        {
            FiringEmitter.SetBase(self);
            FiringEmitter.SetRelativeLocation(FiringEmitterOffset);
            FiringEmitter.SetRelativeRotation(rot(0, 0, 0));
        }
    }

    bIsPlayingFiringEffects = true;
}

simulated function StopFiringEffects()
{
    if (Level.NetMode == NM_DedicatedServer)
    {
        return;
    }
    
    if (FiringEmitter != none)
    {
        FiringEmitter.Destroy();
    }

    bIsPlayingFiringEffects = false;
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
        AmbientSound = FiringAmbientSound;
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

            if (bHasInfiniteAmmo == false)
            {
                // Ensure that we do not fire more projectiles than we have available.
                ProjectileCount = Min(AmmoCount, ProjectileCount);
            }

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
                AmmoCount -= ProjectileCount;

                if (AmmoCount == 0)
                {
                    // No more ammunition, stop firing.
                    StopFiring();
                }
            }
        }
    }
}

simulated function bool IsFiring()
{
    return bIsFiring;
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

simulated function Destroyed()
{
    super.Destroyed();

    StopFiringEffects();
}

defaultproperties
{
    bHasInfiniteAmmo=true
    ProjectileOffset=(X=512,Y=0,Z=0)
    RemoteRole=ROLE_SimulatedProxy
}
