//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_ZiS2CannonShell extends DHSovietCannonShell;

defaultproperties
{
    RoundType=RT_APBC
    Speed=59930.0 // 990 m/s
    MaxSpeed=59930.0
    ShellDiameter=5.7
    BallisticCoefficient=1.14 //TODO: find correct BC

    //Damage
    ImpactDamage=460  //14 gramms TNT filler
    ShellImpactDamage=class'DH_Engine.DHShellAPGunImpactDamageType'
    HullFireChance=0.35
    EngineFireChance=0.62

    //Penetration
    DHPenetrationTable(0)=12.1  // 100m  (from Bird & Livingstone, estimate between rolled homogenous and face hardened armor)
    DHPenetrationTable(1)=11.6  // 250m
    DHPenetrationTable(2)=10.9  // 500m
    DHPenetrationTable(3)=10.3
    DHPenetrationTable(4)=9.5  // 1000m
    DHPenetrationTable(5)=8.8
    DHPenetrationTable(6)=8.1  // 1500m
    DHPenetrationTable(7)=7.7
    DHPenetrationTable(8)=7.1  // 2000m
    DHPenetrationTable(9)=5.7
    DHPenetrationTable(10)=4.9 // 3000m

    //Gunsight adjustments
    //these are commented out because i dont know how to do these, should be done in the future
    //commented out values are from zis-3
    bMechanicalAiming=true
    MechanicalRanges(1)=(Range=200,RangeValue=22.0)
  //  MechanicalRanges(2)=(Range=400,RangeValue=63.0)
   // MechanicalRanges(3)=(Range=600,RangeValue=87.0)
  //  MechanicalRanges(4)=(Range=800,RangeValue=115.0)
  //  MechanicalRanges(5)=(Range=1000,RangeValue=147.0)
  //  MechanicalRanges(6)=(Range=1200,RangeValue=183.0)
  //  MechanicalRanges(7)=(Range=1400,RangeValue=220.0)
 //   MechanicalRanges(8)=(Range=1600,RangeValue=260.0)
 //   MechanicalRanges(9)=(Range=1800,RangeValue=307.0)
   // MechanicalRanges(10)=(Range=2000,RangeValue=355.0)
    //MechanicalRanges(11)=(Range=2200,RangeValue=408.0)
    //MechanicalRanges(12)=(Range=2400,RangeValue=467.0)
//    MechanicalRanges(13)=(Range=2600,RangeValue=528.0)
  //  MechanicalRanges(14)=(Range=2800,RangeValue=589.0)
//    MechanicalRanges(15)=(Range=3000,RangeValue=650.0)
  //  MechanicalRanges(16)=(Range=3200,RangeValue=711.0)
 //   MechanicalRanges(17)=(Range=3400,RangeValue=772.0)
 //   MechanicalRanges(18)=(Range=3600,RangeValue=833.0)
 //   MechanicalRanges(19)=(Range=3800,RangeValue=894.0)
    MechanicalRanges(20)=(Range=4000,RangeValue=22.0)
}
