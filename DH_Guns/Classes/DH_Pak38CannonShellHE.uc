//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_Pak38CannonShellHE extends DHCannonShellHE;

defaultproperties
{
    Speed=50392.0
    MaxSpeed=50392.0
    ShellDiameter=5.0
    BallisticCoefficient=1.19

    //Damage
    ImpactDamage=545
    Damage=240.0  //~~180 gramms TNT
    DamageRadius=565.0
    MyDamageType=class'DH_Engine.DHShellHE50mmDamageType'
    PenetrationMag=565.0
    HullFireChance=0.6
    EngineFireChance=0.60

    bDebugInImperial=false

    //Effects
    ShellHitDirtEffectClass=class'ROEffects.TankHEHitDirtEffect'
    ShellHitSnowEffectClass=class'ROEffects.TankHEHitSnowEffect'
    ShellHitWoodEffectClass=class'ROEffects.TankHEHitWoodEffect'
    ShellHitRockEffectClass=class'ROEffects.TankHEHitRockEffect'
    ShellHitWaterEffectClass=class'ROEffects.TankHEHitWaterEffect'

    //Penetration
    DHPenetrationTable(0)=2.7
    DHPenetrationTable(1)=2.5
    DHPenetrationTable(2)=2.1
    DHPenetrationTable(3)=1.9
    DHPenetrationTable(4)=1.6
    DHPenetrationTable(5)=1.3
    DHPenetrationTable(6)=1.0
    DHPenetrationTable(7)=0.9
    DHPenetrationTable(8)=0.7
    DHPenetrationTable(9)=0.5
    DHPenetrationTable(10)=0.3

    MechanicalRanges(1)=(Range=100,RangeValue=8.0)
    MechanicalRanges(2)=(Range=200,RangeValue=18.0)
    MechanicalRanges(3)=(Range=300,RangeValue=29.0)
    MechanicalRanges(4)=(Range=400,RangeValue=36.0)
    MechanicalRanges(5)=(Range=500,RangeValue=45.0)
    MechanicalRanges(6)=(Range=600,RangeValue=52.0)
    MechanicalRanges(7)=(Range=700,RangeValue=65.0)
    MechanicalRanges(8)=(Range=800,RangeValue=73.0)
    MechanicalRanges(9)=(Range=900,RangeValue=90.0)
    MechanicalRanges(10)=(Range=1000,RangeValue=97.0)
    MechanicalRanges(11)=(Range=1100,RangeValue=115.0)
    MechanicalRanges(12)=(Range=1200,RangeValue=123.0)
    MechanicalRanges(13)=(Range=1300,RangeValue=135.0)
    MechanicalRanges(14)=(Range=1400,RangeValue=150.0)
    MechanicalRanges(15)=(Range=1500,RangeValue=162.0)
    MechanicalRanges(16)=(Range=1600,RangeValue=177.0)
    MechanicalRanges(17)=(Range=1700,RangeValue=194.0)
    MechanicalRanges(18)=(Range=1800,RangeValue=213.0)
    MechanicalRanges(19)=(Range=1900,RangeValue=228.0)
    MechanicalRanges(20)=(Range=2000,RangeValue=248.0)
    bMechanicalAiming=true
}
