//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DHGrenadeProjectile extends DHThrowableExplosiveProjectile // incorporating ROGrenadeProjectile
    abstract;

var     bool    bIsStickGrenade; // if true then the grenade's spin, when thrown, will be tumbling end over end

// Modified from ROGrenadeProjectile to handle different grenade spin for stick grenades
simulated function PostBeginPlay()
{
    super.PostBeginPlay();

    if (Role == ROLE_Authority)
    {
        // FuzeLengthTimer is set by the fire class after the projectile is spawned
        // So though it randomizes the default here, it doesn't matter as the fireclass overrides it
        // This means we will need to fireclass to handle the random fuze times
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
        foreach RadiusActors(class'DHPawn', DHP, 5.0)
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
    FuzeLengthTimer=4.5
    Speed=1100.0
    MyDamageType=class'DHThrowableExplosiveDamageType'
    ExplodeDirtEffectClass=class'GrenadeExplosion'
    ExplodeSnowEffectClass=class'GrenadeExplosionSnow' // added instead of using same as ExplodeDirtEffectClass, as there is an RO snow effect available
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
