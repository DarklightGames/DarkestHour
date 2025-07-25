//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DHCannonShellHE extends DHCannonShell
    abstract;

// Modified to move karma ragdolls around when HE round explodes (moved here from Destroyed)
simulated function SpawnExplosionEffects(Vector HitLocation, Vector HitNormal, optional float ActualLocationAdjustment)
{
    local Vector Start, Direction;
    local float  DamageScale, Distance;
    local ROPawn Victims;

    super.SpawnExplosionEffects(HitLocation, HitNormal, ActualLocationAdjustment);

    // Move karma ragdolls around when this explodes
    if (Level.NetMode != NM_DedicatedServer)
    {
        Start = HitLocation + vect(0.0, 0.0, 32.0);

        foreach VisibleCollidingActors(Class'ROPawn', Victims, DamageRadius, Start)
        {
            if (Victims.Physics == PHYS_KarmaRagDoll && Victims != self)
            {
                Direction = Victims.Location - Start;
                Distance = FMax(1.0, VSize(Direction));
                Direction = Direction / Distance;
                DamageScale = 1.0 - FMax(0.0, (Distance - Victims.CollisionRadius) / DamageRadius);

                Victims.DeadExplosionKarma(MyDamageType, DamageScale * MomentumTransfer * Direction, DamageScale);
            }
        }
    }
}

defaultproperties
{
    RoundType=RT_HE
    bExplodesOnArmor=true
    bExplodesOnHittingWater=true
    bExplodesOnHittingBody=true
    bAlwaysDoShakeEffect=true
    bBotNotifyIneffective=false
    ExplosionSound(0)=SoundGroup'ProjectileSounds.OUT_HE_explode01'
    ExplosionSound(1)=SoundGroup'ProjectileSounds.OUT_HE_explode02'
    ExplosionSound(2)=SoundGroup'ProjectileSounds.OUT_HE_explode03'
    ExplosionSound(3)=SoundGroup'ProjectileSounds.OUT_HE_explode04'
    bHasTracer=true
    ShakeRotMag=(Y=0.0)
    ShakeRotRate=(Z=2500.0)
    BlurTime=6.0
    BlurEffectScalar=2.2
    PenetrationMag=300.0
    VehicleDeflectSound=SoundGroup'ProjectileSounds.HE_deflect'
    ShellHitVehicleEffectClass=Class'TankHEHitPenetrate'
    ShellDeflectEffectClass=Class'TankHEHitDeflect'
    ShellHitDirtEffectClass=Class'DHShellExplosion_MediumHE'
    ShellHitSnowEffectClass=Class'DHShellExplosion_MediumHE'
    ShellHitWoodEffectClass=Class'DHShellExplosion_MediumHE'
    ShellHitRockEffectClass=Class'DHShellExplosion_MediumHE'
    ShellHitWaterEffectClass=Class'DHShellExplosion_MediumHE'
    DamageRadius=300.0
    MyDamageType=Class'DHShellHE75mmDamageType'
    ShellImpactDamage=Class'DHShellHEImpactDamageType'
    ExplosionDecal=Class'ArtilleryMarkDirt'
    ExplosionDecalSnow=Class'ArtilleryMarkSnow'
    LifeSpan=10.0
//  SoundRadius=1000.0 // removed as affects shell's flight 'whistle' (i.e. AmbientSound), not the explosion sound radius
    ExplosionSoundVolume=2.0
}
