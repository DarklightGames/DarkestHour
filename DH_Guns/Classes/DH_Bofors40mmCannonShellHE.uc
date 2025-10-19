//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
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
    ShellImpactDamage=Class'DHShellHEGunImpactDamageType'
    Damage=165.0   //~90 gramms TNT
    DamageRadius=540.0
    MyDamageType=Class'DHShellHE37mmATDamageType'
    HullFireChance=0.50
    EngineFireChance=0.50

    //Effects
    CoronaClass=Class'DHShellTracer_Red'
    ShellTrailClass=Class'DH20mmShellTrail_Red'
    BlurTime=4.0
    BlurEffectScalar=1.5
    ShellHitDirtEffectClass=Class'DH20mmHEHitDirtEffect'
    ShellHitSnowEffectClass=Class'DH20mmHEHitSnowEffect'
    ShellHitWoodEffectClass=Class'DH20mmHEHitWoodEffect'
    ShellHitRockEffectClass=Class'DH20mmHEHitConcreteEffect'
    ShellHitWaterEffectClass=Class'TankHEHitWaterEffect'
    ShellHitVehicleEffectClass=Class'TankAPHitPenetrateSmall'

    //Sound
    //VehicleHitSound=SoundGroup'ProjectileSounds.PTRD_penetrate'
    //VehicleDeflectSound=SoundGroup'ProjectileSounds.PTRD_deflect'   <why would an explosive shell produce sound of bullet deflection?

    //Penetration
    DHPenetrationTable(0)=1.3 // penetration slightly better than US 37mm HE
    DHPenetrationTable(1)=1.2
    DHPenetrationTable(2)=1.1
    DHPenetrationTable(3)=1.0
    DHPenetrationTable(4)=1.0
}
