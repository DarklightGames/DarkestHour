//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_Bofors40mmCannonShellHE extends DHCannonShellHE;

defaultproperties
{
    Speed=53170.0
    MaxSpeed=53170.0
    ShellDiameter=4.0
    BallisticCoefficient=0.984 //TODO: pls, check

    //Damage
    ImpactDamage=300
    ShellImpactDamage=class'DH_Engine.DHShellHEGunImpactDamageType'
    Damage=165.0   //~90 gramms TNT
    DamageRadius=540.0
    MyDamageType=class'DH_Engine.DHShellHE37mmATDamageType'
    HullFireChance=0.50
    EngineFireChance=0.50

    //Effects
    CoronaClass=class'DH_Effects.DHShellTracer_Red'
    ShellTrailClass=class'DH_Effects.DH20mmShellTrail_Red'
    BlurTime=4.0
    BlurEffectScalar=1.5
    ShellHitDirtEffectClass=class'DH_Effects.DH20mmHEHitDirtEffect'
    ShellHitSnowEffectClass=class'DH_Effects.DH20mmHEHitSnowEffect'
    ShellHitWoodEffectClass=class'DH_Effects.DH20mmHEHitWoodEffect'
    ShellHitRockEffectClass=class'DH_Effects.DH20mmHEHitConcreteEffect'
    ShellHitWaterEffectClass=class'ROEffects.TankHEHitWaterEffect'
    ShellHitVehicleEffectClass=class'ROEffects.TankAPHitPenetrateSmall'

    //Sound
    //VehicleHitSound=SoundGroup'ProjectileSounds.Bullets.PTRD_penetrate'
    //VehicleDeflectSound=SoundGroup'ProjectileSounds.Bullets.PTRD_deflect'   <why would an explosive shell produce sound of bullet deflection?

    //Penetration
    DHPenetrationTable(0)=1.3 // penetration slightly better than US 37mm HE
    DHPenetrationTable(1)=1.2
    DHPenetrationTable(2)=1.1
    DHPenetrationTable(3)=1.0
    DHPenetrationTable(4)=1.0
}
