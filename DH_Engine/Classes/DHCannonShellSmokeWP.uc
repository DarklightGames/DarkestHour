//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DHCannonShellSmokeWP extends DHCannonShellSmoke
    abstract;

var int                    GasDamage;
var float                  GasRadius;
var class<DamageType>      GasDamageClass;
var float                  GasEffectDuration;

// Modified so actor is torn off & then destroyed on server, but persists for its LifeSpan on clients to play the smoke sound
simulated function HandleDestruction()
{
    local DHHurtRadius HurtRadius;

    super.HandleDestruction();

    if (Role == ROLE_Authority)
    {
        // Spawn a hurt radius actor.
        HurtRadius = Spawn(Class'DHHurtRadius',,, Location);
        HurtRadius.DamageAmount = GasDamage;
        HurtRadius.DamageRadius = GasRadius;
        HurtRadius.LifeSpan = GasEffectDuration;
        HurtRadius.DamageType = GasDamageClass;
        HurtRadius.SetDamageTimerRate(2.0);
    }
}

defaultproperties
{
    bExplodesOnArmor=true
    bExplodesOnHittingWater=true
    bExplodesOnHittingBody=true

    //The smoke screen effect
    SmokeEmitterClass=Class'DHSmokeEffect_ShellWP'

    //In all cases we want an impact to result in the WP explosion effect
    ShellHitVehicleEffectClass=Class'DHShellExplosion_MediumWP'
    ShellDeflectEffectClass=Class'DHShellExplosion_MediumWP'

    ShellHitDirtEffectClass=Class'DHShellExplosion_MediumWP'
    ShellHitSnowEffectClass=Class'DHShellExplosion_MediumWP'
    ShellHitWoodEffectClass=Class'DHShellExplosion_MediumWP'
    ShellHitRockEffectClass=Class'DHShellExplosion_MediumWP'
    ShellHitWaterEffectClass=Class'DHShellExplosion_MediumWP'

    //Sounds adopted from HE shell since this shell ruptures on impact too
    VehicleDeflectSound=SoundGroup'ProjectileSounds.cannon_rounds.HE_deflect'
    ExplosionSound(0)=SoundGroup'ProjectileSounds.cannon_rounds.OUT_HE_explode01'
    ExplosionSound(1)=SoundGroup'ProjectileSounds.cannon_rounds.OUT_HE_explode02'
    ExplosionSound(2)=SoundGroup'ProjectileSounds.cannon_rounds.OUT_HE_explode03'
    ExplosionSound(3)=SoundGroup'ProjectileSounds.cannon_rounds.OUT_HE_explode04'

    VehicleHitSound=SoundGroup'ProjectileSounds.cannon_rounds.OUT_HE_explode03'
    DirtHitSound=SoundGroup'ProjectileSounds.cannon_rounds.OUT_HE_explode01'
    RockHitSound=SoundGroup'ProjectileSounds.cannon_rounds.OUT_HE_explode02'
    WaterHitSound=SoundGroup'ProjectileSounds.cannon_rounds.AP_Impact_Water'
    WoodHitSound=SoundGroup'ProjectileSounds.cannon_rounds.OUT_HE_explode04'

    //Damage Chances - Upon penetration
    HullFireChance=0.65 // defaults here - customize per shell class
    EngineFireChance=0.90 // defaults here - customize per shell class

    GasEffectDuration=50.0

    Damage=100.0
    DamageRadius=480.0
    MyDamageType=Class'DHShellSmokeWPDamageType' // new dam type that sets nearby players on fire upon "explosion"
    GasDamageClass=Class'DHShellSmokeWPGasDamageType'
    GasDamage=10.0
    GasRadius=800.0
}
