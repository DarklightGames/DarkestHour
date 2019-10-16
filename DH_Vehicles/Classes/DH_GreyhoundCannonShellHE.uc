//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2019
//==============================================================================

class DH_GreyhoundCannonShellHE extends DHCannonShellHE;

defaultproperties
{
    Speed=53291.0
    MaxSpeed=53291.0
    ShellDiameter=3.7
    BallisticCoefficient=0.984 //TODO: find correct BC

    //Damage
    ImpactDamage=185
    Damage=150.0
    DamageRadius=800.0
    MyDamageType=class'DH_Engine.DHShellHE37mmDamageType'
    HullFireChance=0.15
    EngineFireChance=0.40

    //Effects
    VehicleDeflectSound=SoundGroup'ProjectileSounds.Bullets.PTRD_deflect'
    VehicleHitSound=SoundGroup'ProjectileSounds.Bullets.PTRD_penetrate'
    ShellHitVehicleEffectClass=class'ROEffects.TankAPHitPenetrateSmall'
    ShellHitDirtEffectClass=class'ROEffects.GrenadeExplosion'
    ShellHitSnowEffectClass=class'ROEffects.GrenadeExplosionSnow'
    ShellHitWoodEffectClass=class'ROEffects.GrenadeExplosion'
    ShellHitRockEffectClass=class'ROEffects.GrenadeExplosion'
    ShellHitWaterEffectClass=class'ROEffects.GrenadeExplosion'

    //Penetration
    DHPenetrationTable(0)=1.2
    DHPenetrationTable(1)=1.1
    DHPenetrationTable(2)=1.0
    DHPenetrationTable(3)=1.0
    DHPenetrationTable(4)=1.0
}
