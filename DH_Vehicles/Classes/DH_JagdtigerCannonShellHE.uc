//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_JagdtigerCannonShellHE extends DHCannonShellHE;

defaultproperties
{
    Speed=53110.0
    MaxSpeed=53110.0
    ShellDiameter=12.8
    BallisticCoefficient=3.9

    //Damage
    ImpactDamage=2400  //3.6 KG TNT, destroys anything that gets penetrated  by it
    Damage=1600.0
    DamageRadius=2100.0
    MyDamageType=class'DH_Engine.DHShellHE105mmDamageType' // a 128mm shell, but 105mm is close enough (it's a very big shell that will throw stuff around more)
    PenetrationMag=1250.0
    HullFireChance=1.0
    EngineFireChance=1.0

    bDebugInImperial=false

    //Effects
    bHasTracer=false
    bHasShellTrail=false
    StaticMesh=StaticMesh'WeaponPickupSM.Ammo.122mm_Shell'

    ShellDeflectEffectClass=class'ROEffects.ROArtilleryDirtEmitter'
    ShellHitDirtEffectClass=class'ROEffects.ROArtilleryDirtEmitter'
    ShellHitSnowEffectClass=class'ROEffects.ROArtillerySnowEmitter'
    ShellHitWoodEffectClass=class'ROEffects.ROArtilleryDirtEmitter'
    ShellHitRockEffectClass=class'ROEffects.ROArtilleryDirtEmitter'
    ShellHitWaterEffectClass=class'ROEffects.ROArtilleryWaterEmitter'

    //Penetration
    DHPenetrationTable(0)=10.5
    DHPenetrationTable(1)=9.9
    DHPenetrationTable(2)=9.5
    DHPenetrationTable(3)=8.9
    DHPenetrationTable(4)=8.5
    DHPenetrationTable(5)=8.1
    DHPenetrationTable(6)=7.7
    DHPenetrationTable(7)=7.3
    DHPenetrationTable(8)=6.7
    DHPenetrationTable(9)=6.2
    DHPenetrationTable(10)=5.9

    ExplosionSound(0)=SoundGroup'Artillery.explosions.explo01'
    ExplosionSound(1)=SoundGroup'Artillery.explosions.explo02'
    ExplosionSound(2)=SoundGroup'Artillery.explosions.explo03'
    ExplosionSound(3)=SoundGroup'Artillery.explosions.explo04'
    MechanicalRanges(1)=(Range=100,RangeValue=16.0)
    MechanicalRanges(2)=(Range=200,RangeValue=20.0)
    MechanicalRanges(3)=(Range=300,RangeValue=26.0)
    MechanicalRanges(4)=(Range=400,RangeValue=32.0)
    MechanicalRanges(5)=(Range=500,RangeValue=42.0)
    MechanicalRanges(6)=(Range=600,RangeValue=48.0)
    MechanicalRanges(7)=(Range=700,RangeValue=54.0)
    MechanicalRanges(8)=(Range=800,RangeValue=62.0)
    MechanicalRanges(9)=(Range=900,RangeValue=70.0)
    MechanicalRanges(10)=(Range=1000,RangeValue=74.0)
    MechanicalRanges(11)=(Range=1100,RangeValue=86.0)
    MechanicalRanges(12)=(Range=1200,RangeValue=90.0)
    MechanicalRanges(13)=(Range=1300,RangeValue=100.0)
    MechanicalRanges(14)=(Range=1400,RangeValue=110.0)
    MechanicalRanges(15)=(Range=1500,RangeValue=116.0)
    MechanicalRanges(16)=(Range=1600,RangeValue=124.0)
    MechanicalRanges(17)=(Range=1700,RangeValue=134.0)
    MechanicalRanges(18)=(Range=1800,RangeValue=136.0)
    MechanicalRanges(19)=(Range=1900,RangeValue=148.0)
    MechanicalRanges(20)=(Range=2000,RangeValue=154.0)
    MechanicalRanges(21)=(Range=2200,RangeValue=169.0)
    MechanicalRanges(22)=(Range=2400,RangeValue=183.0)
    MechanicalRanges(23)=(Range=2600,RangeValue=198.0)
    MechanicalRanges(24)=(Range=2800,RangeValue=212.0)
    MechanicalRanges(25)=(Range=3000,RangeValue=227.0)
    bMechanicalAiming=true
}
