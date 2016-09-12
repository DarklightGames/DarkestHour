//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DH_F1GrenadeProjectile extends DHGrenadeProjectile;

simulated function HitWall(vector HitNormal, Actor Wall)
{
    local ESurfaceTypes ST;
    local vector        VNorm;

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
        // Reflect off Wall w/damping
        VNorm = (Velocity dot HitNormal) * HitNormal;
        Velocity = -VNorm * DampenFactor + (Velocity - VNorm) * DampenFactorParallel;
        Speed = VSize(Velocity);
    }

    if (Level.NetMode != NM_DedicatedServer && Speed > 150.0 && ImpactSound != none)
    {
        PlaySound(ImpactSound, SLOT_Misc, 1.1); // Increase volume of impact
    }
}

function BlowUp(vector HitLocation)
{
    local DHPawn DHP;

    // Check for any players so close that they must be on top of the grenade
    foreach RadiusActors(class'DHPawn', DHP, 5.0)
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

simulated function Landed(vector HitNormal)
{
    if (Bounces <= 0)
    {
        SetPhysics(PHYS_None);
        SetRotation(QuatToRotator(QuatProduct(QuatFromRotator(rotator(HitNormal)), QuatFromAxisAndAngle(HitNormal, Rotation.Yaw * 0.000095873))));

        if (Role == ROLE_Authority)
        {
            Fear = Spawn(class'AvoidMarker');
            Fear.SetCollisionSize(DamageRadius, 200.0);
            Fear.StartleBots();
        }
    }
    else
    {
        HitWall(HitNormal, none);
    }
}

defaultproperties
{
    ExplosionSound(0)=SoundGroup'Inf_Weapons.F1.f1_explode01'
    ExplosionSound(1)=SoundGroup'Inf_Weapons.F1.f1_explode02'
    ExplosionSound(2)=SoundGroup'Inf_Weapons.F1.f1_explode03'
    Damage=150.0
    DamageRadius=700.0
    MyDamageType=class'DH_Weapons.DH_F1GrenadeDamType'
    StaticMesh=StaticMesh'WeaponPickupSM.Projectile.F1grenade-throw'
}
