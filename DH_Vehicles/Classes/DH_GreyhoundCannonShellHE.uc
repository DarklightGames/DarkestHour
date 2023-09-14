//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
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
    Damage=100.0   //39 gramms TNT
    DamageRadius=400.0
    MyDamageType=class'DH_Engine.DHShellHE37mmDamageType'
    HullFireChance=0.5
    EngineFireChance=0.5

    //Effects
    ShellHitVehicleEffectClass=class'ROEffects.TankAPHitPenetrateSmall'
    ShellHitDirtEffectClass=class'ROEffects.GrenadeExplosion'
    ShellHitSnowEffectClass=class'ROEffects.GrenadeExplosionSnow'
    ShellHitWoodEffectClass=class'ROEffects.GrenadeExplosion'
    ShellHitRockEffectClass=class'ROEffects.GrenadeExplosion'
    ShellHitWaterEffectClass=class'ROEffects.GrenadeExplosion'

    //Sound
    //VehicleDeflectSound=SoundGroup'ProjectileSounds.Bullets.PTRD_deflect'  <why would an explosive shell produce sound of bullet deflection?
    //VehicleHitSound=SoundGroup'ProjectileSounds.Bullets.PTRD_penetrate'

    //Penetration
    DHPenetrationTable(0)=1.2
    DHPenetrationTable(1)=1.1
    DHPenetrationTable(2)=1.0
    DHPenetrationTable(3)=1.0
    DHPenetrationTable(4)=1.0
}
