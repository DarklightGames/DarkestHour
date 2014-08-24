//=============================================================================
// DH_StielGranateProjectile
//=============================================================================
// Grenade projectile for the Gaerman StielGranate concussion grenade
//=============================================================================
// Red Orchestra Source
// Copyright (C) 2005 Tripwire Interactive LLC
// - John "Ramm-Jaeger" Gibson
//=============================================================================

//=============================================================================

class DH_StielGranateProjectile extends ROGrenadeProjectile;

// Give this nade some extra spin
simulated function PostBeginPlay()
{
    super(ROThrowableExplosiveProjectile).PostBeginPlay();

    if (Role == ROLE_Authority)
    {
        Velocity = Speed * vector(Rotation);

        if (Instigator.HeadVolume.bWaterVolume)
        {
            Velocity = 0.25 * Velocity;
        }
    }

    RotationRate.Pitch = -(90000 + 30000 * FRand());

    Acceleration = 0.5 * PhysicsVolume.Gravity;
}

//-----------------------------------------------------------------------------
// HitWall
//-----------------------------------------------------------------------------

simulated function HitWall(vector HitNormal, actor Wall)
{
    local vector VNorm;
    local ESurfaceTypes ST;

    GetHitSurfaceType(ST, HitNormal);
    GetDampenAndSoundValue(ST);

    // Return here, this was causing the famous "Nade bug"
    if (ROCollisionAttachment(Wall) != none)
    {
        return;
    }

    // Reflect off Wall w/damping
    //VNorm = (Velocity dot HitNormal) * HitNormal;
    //Velocity = -VNorm * DampenFactor + (Velocity - VNorm) * DampenFactorParallel;
    //Velocity = -HitNormal * Velocity * 0.3;
    Bounces--;

    if (Bounces <= 0)
    {
        bBounce = false;
        //SetPhysics(PHYS_none);
    }
    else
    {
        // Reflect off Wall w/damping
        VNorm = (Velocity dot HitNormal) * HitNormal;
        Velocity = -VNorm * DampenFactor + (Velocity - VNorm) * DampenFactorParallel;
        //Velocity = 0.3 * (Velocity - 2.0 * HitNormal * (Velocity dot HitNormal));
        //RandSpin(100000);
        Speed = VSize(Velocity);
    }

    if ((Level.NetMode != NM_DedicatedServer) && (Speed > 150) && ImpactSound != none)
    {
        PlaySound(ImpactSound, SLOT_Misc, 1.1); // Increase volume of impact
    }
}

//-----------------------------------------------------------------------------
// BlowUp
// Overridden to allow players to dive on grenades to save teammates
//-----------------------------------------------------------------------------

function BlowUp(vector HitLocation)
{
    local DH_Pawn DHP;

    // Check for any players so close that they must be on top of the grenade
    foreach RadiusActors(class'DH_Pawn', DHP, 3)
    {
        // Make sure player is actually lying on the grenade, not just standing over it
        if (DHP.bIsCrawling)
        {
            DamageRadius *= 0.25; // Shrink the radius so that no-one but the proned player is touched
        }
    }

    DelayedHurtRadius(Damage, DamageRadius, MyDamageType, MomentumTransfer, HitLocation);

    if (Role == ROLE_Authority)
        MakeNoise(1.0);
}

simulated function Landed(vector HitNormal)
{
    if (Bounces <= 0)
    {
        SetPhysics(PHYS_none);
        SetRotation(QuatToRotator(QuatProduct(QuatFromRotator(rotator(HitNormal)),QuatFromAxisAndAngle(HitNormal, Rotation.Yaw * 0.000095873))));

        if (Role == ROLE_Authority)
        {
            Fear = Spawn(class'AvoidMarker');
            Fear.SetCollisionSize(DamageRadius,200);
            Fear.StartleBots();
        }
    }
    else
    {
        HitWall(HitNormal, none);
    }
}

//=============================================================================
// defaultproperties
//=============================================================================

defaultproperties
{
     FuzeLengthTimer=4.500000
     ExplosionSound(0)=SoundGroup'Inf_Weapons.stielhandgranate24.stielhandgranate24_explode01'
     ExplosionSound(1)=SoundGroup'Inf_Weapons.stielhandgranate24.stielhandgranate24_explode02'
     ExplosionSound(2)=SoundGroup'Inf_Weapons.stielhandgranate24.stielhandgranate24_explode03'
     Speed=1100.000000
     Damage=180.000000
     DamageRadius=639.000000
     MyDamageType=Class'DH_Weapons.DH_StielGranateDamType'
     StaticMesh=StaticMesh'WeaponPickupSM.Projectile.Stielhandgranate_throw'
}
