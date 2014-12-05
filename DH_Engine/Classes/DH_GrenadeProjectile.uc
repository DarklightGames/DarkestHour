//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_GrenadeProjectile extends DH_ThrowableExplosiveProjectile // incorporating ROGrenadeProjectile
    abstract;

var bool bIsStickGrenade; // if true then the grenade's spin, when thrown, will be tumbling end over end

// Modified from ROGrenadeProjectile to handle different grenade spin for stick grenades
simulated function PostBeginPlay()
{
    super.PostBeginPlay();

    if (Role == ROLE_Authority)
    {
        Velocity = Speed * vector(Rotation);

        if (Instigator.HeadVolume.bWaterVolume)
        {
            Velocity = 0.25 * Velocity;
        }

        FuzeLengthTimer += FRand();
    }

    if (bIsStickGrenade)
    {
        RotationRate.Pitch = -(90000 + Rand(30000)); // end over end tumbling flight
    }
    else
    {
        RandSpin(100000.0); // normal random 3D spin for egg-shaped or canister grenades
    }

    Acceleration = 0.5 * PhysicsVolume.Gravity;
}

// Modified from ROGrenadeProjectile to alter ImpactSound speed threshold & volume
simulated function HitWall(vector HitNormal, Actor Wall)
{
    local vector        VNorm;
    local ESurfaceTypes ST;

    GetHitSurfaceType(ST, HitNormal);
    GetDampenAndSoundValue(ST);

    // Return here, this was causing the famous "Nade bug"
    if (ROCollisionAttachment(Wall) != none)
    {
        return;
    }

    Bounces--;

    if (Bounces <= 0)
    {
        bBounce = false;
    }
    else
    {
        // Reflect off Wall with damping
        VNorm = (Velocity dot HitNormal) * HitNormal;
        Velocity = -VNorm * DampenFactor + (Velocity - VNorm) * DampenFactorParallel;
        Speed = VSize(Velocity);
    }

    if (Level.NetMode != NM_DedicatedServer && Speed > 150 && ImpactSound != none)
    {
        PlaySound(ImpactSound, SLOT_Misc, 1.1); // increase volume of impact
    }
}

// Modified from ROGrenadeProjectile to allow players to dive on grenades to save teammates
function BlowUp(vector HitLocation)
{
    local DH_Pawn DHP;

    // Check for any players so close that they must be on top of the grenade
    foreach RadiusActors(class'DH_Pawn', DHP, 5)
    {
        // Make sure player is actually lying on the grenade, not just standing over it
        if (DHP.bIsCrawling)
        {
            DamageRadius *= 0.25; // shrink the radius so that no-one but the proned player is touched
        }
    }

    DelayedHurtRadius(Damage, DamageRadius, MyDamageType, MomentumTransfer, HitLocation);

    if (Role == ROLE_Authority)
    {
        MakeNoise(1.0);
    }
}

defaultproperties
{
    FuzeLengthTimer=4.5 // Matt: changed from 4.0 as all but M1 grenade use 4.5
    Speed=1100.0 // Matt: changed from 1000 as all but M1 grenade use 1100
    MyDamageType=class'ROGrenadeDamType'
    ExplodeDirtEffectClass=class'GrenadeExplosion'
    ExplodeSnowEffectClass=class'GrenadeExplosionSnow' // Matt: added instead of using same as ExplodeDirtEffectClass. as there is an RO snow effect available
    ExplodeMidAirEffectClass=class'GrenadeExplosion_midair'
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
