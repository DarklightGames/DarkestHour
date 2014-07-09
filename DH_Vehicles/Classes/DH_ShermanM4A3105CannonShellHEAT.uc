//==============================================================================
// DH_ShermanM4A3105CannonShellHEAT
//
// Darkest Hour Source - (c) Darkest Hour Team 2010
// Red Orchestra Source - (c) Tripwire Interactive 2006
//
// M4A3 (105) American Sherman Tank - 105mm M67 HEAT
//==============================================================================
class DH_ShermanM4A3105CannonShellHEAT extends DH_ROTankCannonShellHEAT;

defaultproperties
{
     MechanicalRanges(1)=(Range=400)
     MechanicalRanges(2)=(Range=800)
     MechanicalRanges(3)=(Range=1200)
     MechanicalRanges(4)=(Range=1600)
     MechanicalRanges(5)=(Range=2000)
     MechanicalRanges(6)=(Range=2400)
     MechanicalRanges(7)=(Range=2800)
     MechanicalRanges(8)=(Range=3200)
     MechanicalRanges(9)=(Range=4200)
     bMechanicalAiming=True
     DHPenetrationTable(0)=12.800000
     DHPenetrationTable(1)=12.800000
     DHPenetrationTable(2)=12.800000
     DHPenetrationTable(3)=12.800000
     DHPenetrationTable(4)=12.800000
     DHPenetrationTable(5)=12.800000
     DHPenetrationTable(6)=12.800000
     DHPenetrationTable(7)=12.800000
     DHPenetrationTable(8)=12.800000
     DHPenetrationTable(9)=12.800000
     DHPenetrationTable(10)=12.800000
     ShellDiameter=10.500000
     ShellImpactDamage=Class'DH_Vehicles.DH_Sherman105ShellImpactDamageHEAT'
     ImpactDamage=650
     BallisticCoefficient=2.960000
     SpeedFudgeScale=0.700000
     Speed=22994.000000
     MaxSpeed=22994.000000
     Damage=415.000000
     DamageRadius=700.000000
     MyDamageType=Class'DH_Vehicles.DH_Sherman105CannonShellDamageHEAT'
     Tag="M67 HEAT"
}
