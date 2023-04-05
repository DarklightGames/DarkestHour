//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_IS2CannonShellHE extends DHCannonShellHE;

defaultproperties
{
    Speed=45866.0 // 760 m/s
    MaxSpeed=45866.0
    ShellDiameter=12.2
    BallisticCoefficient=2.35

    //Damage
    ImpactDamage=2400  //3.6 KG TNT, destroys anything that gets penetrated  by it
    Damage=1500.0
    DamageRadius=2000.0
    MyDamageType=class'DH_Engine.DHShellHE105mmDamageType' // a 122mm shell, but 105mm is close enough (it's a very big shell that will throw stuff around more)
    PenetrationMag=1250.0
    HullFireChance=1.0
    EngineFireChance=1.0

    //Effects
    CoronaClass=class'DH_Effects.DHShellTracer_GreenLarge'
    ShellTrailClass=class'DH_Effects.DHShellTrail_Green'
    StaticMesh=StaticMesh'WeaponPickupSM.Ammo.122mm_Shell'
    ShellDeflectEffectClass=class'ROEffects.ROArtilleryDirtEmitter'
    ShellHitDirtEffectClass=class'ROEffects.ROArtilleryDirtEmitter'
    ShellHitSnowEffectClass=class'ROEffects.ROArtillerySnowEmitter'
    ShellHitWoodEffectClass=class'ROEffects.ROArtilleryDirtEmitter'
    ShellHitRockEffectClass=class'ROEffects.ROArtilleryDirtEmitter'
    ShellHitWaterEffectClass=class'ROEffects.ROArtilleryWaterEmitter'

    bDebugInImperial=false

    //Penetration
    DHPenetrationTable(0)=9.5  // 100m
    DHPenetrationTable(1)=8.9  // 250m
    DHPenetrationTable(2)=8.5  // 500m
    DHPenetrationTable(3)=8.0
    DHPenetrationTable(4)=7.6  // 1000m
    DHPenetrationTable(5)=7.3
    DHPenetrationTable(6)=7.0  // 1500m
    DHPenetrationTable(7)=6.6
    DHPenetrationTable(8)=6.1  // 2000m
    DHPenetrationTable(9)=5.6
    DHPenetrationTable(10)=5.3 // 3000m

    bMechanicalAiming=true
    MechanicalRanges(0)=(Range=0,RangeValue=0.0)
    MechanicalRanges(1)=(Range=400,RangeValue=37.0)
    MechanicalRanges(2)=(Range=500,RangeValue=48.0)
    MechanicalRanges(3)=(Range=600,RangeValue=57.0)
    MechanicalRanges(4)=(Range=700,RangeValue=68.0)
    MechanicalRanges(5)=(Range=800,RangeValue=77.0)
    MechanicalRanges(6)=(Range=900,RangeValue=88.0)
    MechanicalRanges(7)=(Range=1000,RangeValue=100.0)
    MechanicalRanges(8)=(Range=1200,RangeValue=121.0)
    MechanicalRanges(9)=(Range=1400,RangeValue=145.0)
    MechanicalRanges(10)=(Range=1600,RangeValue=172.0)
    MechanicalRanges(11)=(Range=1800,RangeValue=197.0)
    MechanicalRanges(12)=(Range=2000,RangeValue=225.0)
    MechanicalRanges(13)=(Range=2200,RangeValue=253.0)
    MechanicalRanges(14)=(Range=2400,RangeValue=285.0)
    MechanicalRanges(15)=(Range=2600,RangeValue=317.0)
    MechanicalRanges(16)=(Range=2800,RangeValue=349.0) // estimates from here on as these extreme ranges are largely theoretical
    MechanicalRanges(17)=(Range=3000,RangeValue=381.0)
    MechanicalRanges(18)=(Range=3200,RangeValue=413.0)
    MechanicalRanges(19)=(Range=3400,RangeValue=445.0)
    MechanicalRanges(20)=(Range=3600,RangeValue=477.0)
    MechanicalRanges(21)=(Range=3800,RangeValue=509.0)
    MechanicalRanges(22)=(Range=4000,RangeValue=541.0)
    MechanicalRanges(23)=(Range=4200,RangeValue=573.0)
    MechanicalRanges(24)=(Range=4400,RangeValue=605.0)
    MechanicalRanges(25)=(Range=4600,RangeValue=637.0)
    MechanicalRanges(26)=(Range=4800,RangeValue=669.0)
    MechanicalRanges(27)=(Range=5000,RangeValue=701.0)
    MechanicalRanges(28)=(Range=5200,RangeValue=733.0)

    bOpticalAiming=true // just a visual range indicator on the side; doesn't actually alter the aiming point
    OpticalRanges(0)=(Range=0,RangeValue=0.420)
    OpticalRanges(1)=(Range=400,RangeValue=0.397)
    OpticalRanges(2)=(Range=500,RangeValue=0.391)
    OpticalRanges(3)=(Range=600,RangeValue=0.385)
    OpticalRanges(4)=(Range=700,RangeValue=0.379)
    OpticalRanges(5)=(Range=800,RangeValue=0.373)
    OpticalRanges(6)=(Range=900,RangeValue=0.367)
    OpticalRanges(7)=(Range=1000,RangeValue=0.361)
    OpticalRanges(8)=(Range=1200,RangeValue=0.349)
    OpticalRanges(9)=(Range=1400,RangeValue=0.337)
    OpticalRanges(10)=(Range=1600,RangeValue=0.325)
    OpticalRanges(11)=(Range=1800,RangeValue=0.313)
    OpticalRanges(12)=(Range=2000,RangeValue=0.301)
    OpticalRanges(13)=(Range=2200,RangeValue=0.289)
    OpticalRanges(14)=(Range=2400,RangeValue=0.277)
    OpticalRanges(15)=(Range=2600,RangeValue=0.265)
    OpticalRanges(16)=(Range=2800,RangeValue=0.253)
    OpticalRanges(17)=(Range=3000,RangeValue=0.241)
    OpticalRanges(18)=(Range=3200,RangeValue=0.229)
    OpticalRanges(19)=(Range=3400,RangeValue=0.217)
    OpticalRanges(20)=(Range=3600,RangeValue=0.205)
    OpticalRanges(21)=(Range=3800,RangeValue=0.193)
    OpticalRanges(22)=(Range=4000,RangeValue=0.181)
    OpticalRanges(23)=(Range=4200,RangeValue=0.169)
    OpticalRanges(24)=(Range=4400,RangeValue=0.157)
    OpticalRanges(25)=(Range=4600,RangeValue=0.145)
    OpticalRanges(26)=(Range=4800,RangeValue=0.133)
    OpticalRanges(27)=(Range=5000,RangeValue=0.121)
    OpticalRanges(28)=(Range=5200,RangeValue=0.109)
}
