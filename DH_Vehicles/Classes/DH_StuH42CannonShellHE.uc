//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_StuH42CannonShellHE extends DHCannonShellHE;

defaultproperties
{
    Speed=29874.0
    MaxSpeed=29874.0
    ShellDiameter=10.5
    BallisticCoefficient=2.96 //find correct BC - this is likely wrong

    //Damage
    ImpactDamage=650  //1.75 KG TNT
    Damage=700.0
    DamageRadius=1250.0
    MyDamageType=class'DH_Engine.DHShellHE105mmDamageType'
    PenetrationMag=1000.0
    HullFireChance=1.0
    EngineFireChance=1.0

    //Effects
    DrawScale=1.5
    bHasTracer=false
    bHasShellTrail=false
    ShellDeflectEffectClass=class'ROEffects.ROArtilleryDirtEmitter'
    ShellHitDirtEffectClass=class'ROEffects.ROArtilleryDirtEmitter'
    ShellHitSnowEffectClass=class'ROEffects.ROArtillerySnowEmitter'
    ShellHitWoodEffectClass=class'ROEffects.ROArtilleryDirtEmitter'
    ShellHitRockEffectClass=class'ROEffects.ROArtilleryDirtEmitter'
    ShellHitWaterEffectClass=class'ROEffects.ROArtilleryWaterEmitter'

    //Sound
    ExplosionSound(0)=SoundGroup'Artillery.explosions.explo01'
    ExplosionSound(1)=SoundGroup'Artillery.explosions.explo02'
    ExplosionSound(2)=SoundGroup'Artillery.explosions.explo03'
    ExplosionSound(3)=SoundGroup'Artillery.explosions.explo04'

    bDebugInImperial=false

    //Penetration
    DHPenetrationTable(0)=8.0
    DHPenetrationTable(1)=7.5
    DHPenetrationTable(2)=7.2
    DHPenetrationTable(3)=6.7
    DHPenetrationTable(4)=6.1
    DHPenetrationTable(5)=5.7
    DHPenetrationTable(6)=5.2
    DHPenetrationTable(7)=4.8
    DHPenetrationTable(8)=4.2
    DHPenetrationTable(9)=3.9
    DHPenetrationTable(10)=3.5

    //Gunsight adjustments
    bMechanicalAiming=true
    MechanicalRanges(0)=(RangeValue=68.0)
    MechanicalRanges(1)=(Range=100,RangeValue=72.0)
    MechanicalRanges(2)=(Range=200,RangeValue=76.0)
    MechanicalRanges(3)=(Range=300,RangeValue=80.0)
    MechanicalRanges(4)=(Range=400,RangeValue=80.0)
    MechanicalRanges(5)=(Range=500,RangeValue=80.0)
    MechanicalRanges(6)=(Range=600,RangeValue=84.0)
    MechanicalRanges(7)=(Range=700,RangeValue=92.0)
    MechanicalRanges(8)=(Range=800,RangeValue=102.0)
    MechanicalRanges(9)=(Range=900,RangeValue=112.0)
    MechanicalRanges(10)=(Range=1000,RangeValue=122.0)
    MechanicalRanges(11)=(Range=1100,RangeValue=126.0)
    MechanicalRanges(12)=(Range=1200,RangeValue=144.0)
    MechanicalRanges(13)=(Range=1300,RangeValue=150.0)
    MechanicalRanges(14)=(Range=1400,RangeValue=159.0)
    MechanicalRanges(15)=(Range=1500,RangeValue=167.0)
    MechanicalRanges(16)=(Range=1600,RangeValue=182.0)
    MechanicalRanges(17)=(Range=1700,RangeValue=196.0)
    MechanicalRanges(18)=(Range=1800,RangeValue=208.0)
    MechanicalRanges(19)=(Range=1900,RangeValue=224.0)
    MechanicalRanges(20)=(Range=2000,RangeValue=236.0)
    MechanicalRanges(21)=(Range=2200,RangeValue=258.0)
    MechanicalRanges(22)=(Range=2400,RangeValue=278.0)
    MechanicalRanges(23)=(Range=2600,RangeValue=298.0)
    MechanicalRanges(24)=(Range=2800,RangeValue=318.0)
    MechanicalRanges(25)=(Range=3000,RangeValue=338.0)
}
