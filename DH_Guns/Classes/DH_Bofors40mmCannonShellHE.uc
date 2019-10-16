//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2019
//==============================================================================

class DH_Bofors40mmCannonShellHE extends DHCannonShellHE;

defaultproperties
{
    Speed=53170.0
    MaxSpeed=53170.0
    ShellDiameter=4.0
    BallisticCoefficient=0.984 //TODO: pls, check

    //Damage
    ImpactDamage=200
    ShellImpactDamage=class'DH_Engine.DHShellHEGunImpactDamageType'
    Damage=165.0
    DamageRadius=500.0
    MyDamageType=class'DH_Engine.DHShellHE37mmATDamageType'
    HullFireChance=0.20
    EngineFireChance=0.40

    //Effects
    CoronaClass=class'DH_Effects.DHShellTracer_Red'
    BlurTime=4.0
    BlurEffectScalar=1.5
    ShellHitDirtEffectClass=class'ROEffects.GrenadeExplosion'
    ShellHitSnowEffectClass=class'ROEffects.GrenadeExplosionSnow'
    ShellHitWoodEffectClass=class'ROEffects.GrenadeExplosion'
    ShellHitRockEffectClass=class'ROEffects.GrenadeExplosion'
    ShellHitWaterEffectClass=class'ROEffects.GrenadeExplosion'
    ShellHitVehicleEffectClass=class'ROEffects.TankAPHitPenetrateSmall'
    VehicleHitSound=SoundGroup'ProjectileSounds.Bullets.PTRD_penetrate'
    VehicleDeflectSound=SoundGroup'ProjectileSounds.Bullets.PTRD_deflect'

    //Penetration
    DHPenetrationTable(0)=1.3 // penetration slightly better than US 37mm HE
    DHPenetrationTable(1)=1.2
    DHPenetrationTable(2)=1.1
    DHPenetrationTable(3)=1.0
    DHPenetrationTable(4)=1.0
}
