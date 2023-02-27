//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DHSmokeLauncherProjectile extends DHMortarProjectileSmoke
    abstract;

var bool        bHasSmokeTrail;  // some smoke pots ignite immediately upon firing
var             class<Emitter>      MortarSmokeTrailClass;  // some smoke pots ignite immediately upon firing
var             Emitter             SmokeTrail;
var float       SmokeTrailDuration; // we want to destroy the trail a few seconds after landing (but not immediately b/c it looks weird)

simulated function PostBeginPlay()
{
    if ( Level.NetMode != NM_DedicatedServer && bHasSmokeTrail)
    {
        SmokeTrail = Spawn(MortarSmokeTrailClass,self);
        SmokeTrail.SetBase(self);
    }

    Super.PostBeginPlay();
}

simulated function HandleDestruction()
{
    if ( SmokeTrail != None )
    {
        SmokeTrail.LifeSpan = SmokeTrailDuration;
    }

    super.HandleDestruction();
}

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

    //Effects
    bHasSmokeTrail=true
    SmokeTrailDuration=4.0
    MortarSmokeTrailClass=class'DH_Effects.DHMortarSmokeTrail'

    DrawType=DT_StaticMesh
    StaticMesh=StaticMesh'IndustrySM.Barrels.Barrel_Green' //PLACEHOLDER: Emulates the 90mm Nb.K.S 39 smoke grenade
    DrawScale=0.15

    HitDirtEmitterClass=class'DH_Effects.DHSmokeMortarHitDirtEffect'
    HitRockEmitterClass=class'DH_Effects.DHSmokeMortarHitRockEffect'
    HitWoodEmitterClass=class'DH_Effects.DHSmokeMortarHitWoodEffect'
    HitSnowEmitterClass=class'DH_Effects.DHSmokeMortarHitSnowEffect'

    bFixedRotationDir=true
    RotationRate=(Pitch=15000)
    DesiredRotation=(Pitch=3000) //30000
}
