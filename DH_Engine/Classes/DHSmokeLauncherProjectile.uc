//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2017
//==============================================================================

class DHSmokeLauncherProjectile extends DHMortarProjectileSmoke
    abstract;

// Modified so remove mortar shell's 'Whistle' state, with its descending sound & delayed impact effects
// Also to ignore any collision with a vehicle weapon on the launcher's own vehicle
simulated function ProcessTouch(Actor Other, vector HitLocation)
{
    if (Other == none || Other.IsA('ROBulletWhipAttachment') || Other.bDeleteMe || (Other.IsA('Projectile') && !Other.bProjTarget))
    {
        return;
    }

    if (Instigator != none && Other.Base == Instigator.GetVehicleBase())
    {
        log("HIT OWN VEHICLE" @ Other.name); // TEMPDEBUG
        return;
    }

    HitWall(Normal(HitLocation - Other.Location), Other);
    self.HitNormal = Normal(HitLocation - Other.Location);
}

// Modified so remove mortar shell's 'Whistle' state, with its descending sound & delayed impact effects
// Also to ignore any collision with the launcher's own vehicle
// Unlike ProcessTouch(), here the projectile gets 'stuck' if it collides with own vehicle, resulting in hundreds of repeated invalid HitWall() events
// The projectile goes nowhere & finally destroys itself after its Lifespan, without ever having exploded & spawned a smoke effect
// So if we get an invalid collision with our own vehicle, we move the projectile on by 1 UU
simulated function HitWall(vector HitNormal, Actor Wall)
{
    if (Instigator != none && Wall == Instigator.GetVehicleBase() && Wall != none)
    {
        log("HIT OWN VEHICLE" @ Wall.name @ " Velocity =" @ Velocity @ " Rotation =" @ Rotation); // TEMPDEBUG
        SetLocation(Location + vector(Rotation));

        return;
    }

    self.HitNormal = HitNormal;
    Explode(Location, HitNormal);
}

// Modified to get smoke launcher's firing location, as the usual WeaponFireLocation doesn't apply to a smoke launcher
simulated function SpawnFiringEffect()
{
    local DHVehicleCannon Cannon;
    local vector          FireLocation;

    if (DHVehicleCannonPawn(Instigator) != none)
    {
        Cannon = DHVehicleCannonPawn(Instigator).Cannon;

        // Can't handle more than one tube firing at once, so have to fall back to using the projectile's location to spawn the firing effect
        if (Cannon == none || Cannon.SmokeLauncherClass.default.ProjectilesPerFire > 1)
        {
            FireLocation = Location;
        }
        else
        {
            FireLocation = Cannon.GetSmokeLauncherFireLocation();
        }

        Spawn(FireEmitterClass,,, FireLocation, Rotation);
    }
}

defaultproperties
{
    bUseCollisionStaticMesh=true // mostly for accurate detection of collision with own vehicle, preventing unwanted impacts
}
