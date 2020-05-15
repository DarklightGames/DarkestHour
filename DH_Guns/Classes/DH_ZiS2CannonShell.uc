//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2020
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
    ImpactDamage=370
    ShellImpactDamage=class'DH_Engine.DHShellAPGunImpactDamageType'
    HullFireChance=0.31
    EngineFireChance=0.58
    //^slightly better than AT57, assumed because higher speed and small TNT filler (14 gramms)

    //Penetration
    DHPenetrationTable(0)=11.7  // 100m (all same as T34/76)
    DHPenetrationTable(1)=11.0  // 250m
    DHPenetrationTable(2)=10.3  // 500m
    DHPenetrationTable(3)=9.8
    DHPenetrationTable(4)=9.1  // 1000m
    DHPenetrationTable(5)=8.5
    DHPenetrationTable(6)=7.9  // 1500m
    DHPenetrationTable(7)=7.4
    DHPenetrationTable(8)=6.9  // 2000m
    DHPenetrationTable(9)=5.5
    DHPenetrationTable(10)=4.2 // 3000m

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
