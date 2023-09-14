//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_PanzerIIIJCannonShell extends DHGermanCannonShell;

defaultproperties
{
    Speed=41339.0
    MaxSpeed=41339.0
    ShellDiameter=5.0
    BallisticCoefficient=1.19

    //Damage
    ImpactDamage=300  //18 gramms TNT filler
    ShellImpactDamage=class'DH_Vehicles.DH_PanzerIIILCannonShellDamageAP'
    HullFireChance=0.30
    EngineFireChance=0.55

    //Effects
    CoronaClass=class'DH_Effects.DHShellTracer_Orange'
    StaticMesh=StaticMesh'WeaponPickupSM.shells.76mm_shell'

    //Penetration
    DHPenetrationTable(0)=7.3 //100
    DHPenetrationTable(1)=6.7 //250
    DHPenetrationTable(2)=5.9 //500
    DHPenetrationTable(3)=5.1 //750
    DHPenetrationTable(4)=4.5 //1000
    DHPenetrationTable(5)=3.9 //1250
    DHPenetrationTable(6)=3.4 //1500
    DHPenetrationTable(7)=3.0 //1750
    DHPenetrationTable(8)=2.6 //2000
    DHPenetrationTable(9)=2.0 //2500
    DHPenetrationTable(10)=1.5//3000

    //below is very approximate, i just added 20% above ausf L values

    MechanicalRanges(1)=(Range=100,RangeValue=9.6)
    MechanicalRanges(2)=(Range=200,RangeValue=22.0)
    MechanicalRanges(3)=(Range=300,RangeValue=35.0)
    MechanicalRanges(4)=(Range=400,RangeValue=43.0)
    MechanicalRanges(5)=(Range=500,RangeValue=54.0)
    MechanicalRanges(6)=(Range=600,RangeValue=62.0)
    MechanicalRanges(7)=(Range=700,RangeValue=78.0)
    MechanicalRanges(8)=(Range=800,RangeValue=88.0)
    MechanicalRanges(9)=(Range=900,RangeValue=118.0)
    MechanicalRanges(10)=(Range=1000,RangeValue=120.0)
    MechanicalRanges(11)=(Range=1100,RangeValue=138.0)
    MechanicalRanges(12)=(Range=1200,RangeValue=147.0)
    MechanicalRanges(13)=(Range=1300,RangeValue=162.0)
    MechanicalRanges(14)=(Range=1400,RangeValue=180.0)
    MechanicalRanges(15)=(Range=1500,RangeValue=195.0)
    MechanicalRanges(16)=(Range=1600,RangeValue=213.0)
    MechanicalRanges(17)=(Range=1700,RangeValue=233.0)
    MechanicalRanges(18)=(Range=1800,RangeValue=255.0)
    MechanicalRanges(19)=(Range=1900,RangeValue=274.0)
    MechanicalRanges(20)=(Range=2000,RangeValue=298.0)
    bMechanicalAiming=true
}
