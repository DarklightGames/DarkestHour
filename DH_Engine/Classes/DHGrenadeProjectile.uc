//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DHGrenadeProjectile extends DHThrowableExplosiveProjectile // incorporating ROGrenadeProjectile
    abstract;

var enum ESpinType
{
    ST_Normal,        // Normal spin for egg-shaped or canister grenades.
    ST_Tumble,      // End-over-end tumbling flight (e.g. stick grenades.
} SpinType;

// Client-side only projectile class to accompany a throw
// (i.e., anything that comes flying off the grenade as it's thrown)
var class<Projectile> SpoonProjectileClass;

simulated function SpawnSpoonProjectile()
{
    local Projectile SpoonProjectile;
    local Rotator SpoonDirection;

    if (SpoonProjectileClass == none)
    {
        return;
    }

    SpoonProjectile = Spawn(SpoonProjectileClass,,, Location, Rotation);

    if (SpoonProjectile == none)
    {
        return;
    }

    // Perturb the direction of the spoon projectile slightly.
    SpoonDirection = Rotator(Velocity);
    SpoonDirection.Yaw += class'UInterp'.static.Linear(FRand(), -300, 300);

    SpoonProjectile.Velocity = Vector(SpoonDirection) * VSize(Velocity) * class'UInterp'.static.Linear(FRand(), 0.5, 0.75);
    SpoonProjectile.RandSpin(100000);
}

simulated function PostNetBeginPlay()
{
    super.PostNetBeginPlay();

    if (Level.NetMode != NM_DedicatedServer)
    {
        SpawnSpoonProjectile();
    }
}

// TODO: put this in the parent class?
// Modified from ROGrenadeProjectile to handle different grenade spin for stick grenades
simulated function PostBeginPlay()
{
    super.PostBeginPlay();

    switch (SpinType)
    {
    case ST_Normal:
        RandSpin(100000.0);
        break;
    case ST_Tumble:
        RotationRate.Pitch = -(90000 + Rand(30000)); 
        break;
    }
}

// TODO: pretty sure this is obsolete & can be deleted, as only ROCollisionAttachment in game is bullet whip attachment, which triggers Touch() not HitWall() & is already ignored by ProcessTouch()
simulated function HitWall(vector HitNormal, Actor Wall)
{
    // Return here, this was causing the famous "nade bug"
    if (ROCollisionAttachment(Wall) != none)
    {
        return;
    }

    super.HitWall(HitNormal, Wall);
}

// Modified to allow players to dive on grenades to save teammates
function BlowUp(vector HitLocation)
{
    local DHPawn DHP;

    if (Role == ROLE_Authority)
    {
        // Check for any players so close that they must be on top of the grenade
        foreach RadiusActors(class'DHPawn', DHP, 10.0)
        {
            // Make sure player is actually lying on the grenade, not just standing over it
            if (DHP.bIsCrawling)
            {
                DamageRadius *= 0.25; // shrink the radius so that no-one but the proned player is touched
                break;
            }
        }
    }

    super.BlowUp(HitLocation);
}

defaultproperties
{
    // FuzeLengthRange=(Min=4.5,Max=5.5)
    Speed=1100.0
    MyDamageType=class'DHThrowableExplosiveDamageType'
    ExplodeDirtEffectClass=class'GrenadeExplosion'
    ExplodeSnowEffectClass=class'GrenadeExplosionSnow' // added instead of using same as ExplodeDirtEffectClass, as there is an RO snow effect available
    ExplodeMidAirEffectClass=class'GrenadeExplosion_midair'
    ImpactSound=SoundGroup'DH_ProjectileSounds.GrenadeImpacts_Concrete'
    ImpactSoundDirt=SoundGroup'DH_ProjectileSounds.GrenadeImpacts_Dirt'
    ImpactSoundWood=SoundGroup'DH_ProjectileSounds.GrenadeImpacts_Wood'
    ImpactSoundMetal=SoundGroup'DH_ProjectileSounds.GrenadeImpacts_Metal'
    ImpactSoundMud=SoundGroup'DH_ProjectileSounds.GrenadeImpacts_Mud'
    ImpactSoundGrass=SoundGroup'DH_ProjectileSounds.GrenadeImpacts_Grass'
    ImpactSoundConcrete=SoundGroup'DH_ProjectileSounds.GrenadeImpacts_Concrete'
    WaterHitSound=SoundGroup'DH_ProjectileSounds.GrenadeImpacts_Water'
    ImpactSoundVolume=2.0
    ImpactSoundRadius=45.0
    CollisionHeight=2.0
    CollisionRadius=4.0
    bSwitchToZeroCollision=true
    bUseCollisionStaticMesh=true
    ShakeRotMag=(X=0.0,Y=0.0,Z=200.0)
    ShakeRotRate=(Z=2500.0)
    ShakeRotTime=4.0
    ShakeOffsetMag=(Z=10.0)
    ShakeOffsetRate=(Z=200.0)
    ShakeOffsetTime=6.0
    ShakeScale=3.0
}
