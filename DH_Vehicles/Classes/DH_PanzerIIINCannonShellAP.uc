//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_PanzerIIINCannonShellAP extends DHGermanCannonShell;

defaultproperties
{
  Speed=38548.0
  MaxSpeed=38548.0
  ShellDiameter=7.5
  BallisticCoefficient=2.0

  // Damage
  ImpactDamage=360
  ShellImpactDamage=class'DH_Engine.DHShellAPGunImpactDamageType'
  HullFireChance=0.5
  EngineFireChance=0.6

  // Effects
  bHasTracer=true
  bHasShellTrail=true

  // Penetration
  DHPenetrationTable(0)=5.7
  DHPenetrationTable(1)=5.6
  DHPenetrationTable(2)=5.5
  DHPenetrationTable(3)=5.3
  DHPenetrationTable(4)=5.2
  DHPenetrationTable(5)=5.1
  DHPenetrationTable(6)=5.0
  DHPenetrationTable(7)=4.9
  DHPenetrationTable(8)=4.8
  DHPenetrationTable(9)=4.6
  DHPenetrationTable(10)=4.5

  MechanicalRanges(0)=(RangeValue=16.0)
  MechanicalRanges(1)=(Range=100,RangeValue=32.0)
  MechanicalRanges(2)=(Range=200,RangeValue=64.0)
  MechanicalRanges(3)=(Range=300,RangeValue=96.0)
  MechanicalRanges(4)=(Range=400,RangeValue=128.0)
  MechanicalRanges(5)=(Range=500,RangeValue=168.0)
  MechanicalRanges(6)=(Range=600,RangeValue=196.0)
  MechanicalRanges(7)=(Range=700,RangeValue=222.0)
  MechanicalRanges(8)=(Range=800,RangeValue=268.0)
  MechanicalRanges(9)=(Range=900,RangeValue=304.0)
  MechanicalRanges(10)=(Range=1000,RangeValue=344.0)
  MechanicalRanges(11)=(Range=1100,RangeValue=388.0)
  MechanicalRanges(12)=(Range=1200,RangeValue=428.0)
  MechanicalRanges(13)=(Range=1300,RangeValue=468.0)
  MechanicalRanges(14)=(Range=1400,RangeValue=512.0)
  MechanicalRanges(15)=(Range=1500,RangeValue=556.0)
  MechanicalRanges(16)=(Range=1600,RangeValue=600.0)
  MechanicalRanges(17)=(Range=1700,RangeValue=644.0)
  MechanicalRanges(18)=(Range=1800,RangeValue=688.0)
  MechanicalRanges(19)=(Range=1900,RangeValue=728.0)
  MechanicalRanges(20)=(Range=2000,RangeValue=764.0)
  MechanicalRanges(21)=(Range=2200,RangeValue=808.0)
  MechanicalRanges(22)=(Range=2400,RangeValue=852.0)
  MechanicalRanges(23)=(Range=2600,RangeValue=898.0)
  MechanicalRanges(24)=(Range=2800,RangeValue=938.0)
  MechanicalRanges(25)=(Range=3000,RangeValue=976.0)
  bMechanicalAiming=true
}
