//==============================================================================
// DH_ShermanCannonShellHE
//
// Darkest Hour Source - (c) Darkest Hour Team 2010
// Red Orchestra Source - (c) Tripwire Interactive 2006
//
// M4 American Sherman tank - 75mm HE M48
//==============================================================================
class DH_ShermanCannonShellHE extends DH_ROTankCannonShellHE;

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
     DHPenetrationTable(0)=3.300000
     DHPenetrationTable(1)=3.100000
     DHPenetrationTable(2)=2.800000
     DHPenetrationTable(3)=2.400000
     DHPenetrationTable(4)=2.000000
     DHPenetrationTable(5)=1.700000
     DHPenetrationTable(6)=1.300000
     DHPenetrationTable(7)=1.100000
     DHPenetrationTable(8)=0.900000
     DHPenetrationTable(9)=0.500000
     DHPenetrationTable(10)=0.300000
     ShellDiameter=7.500000
     PenetrationMag=1000.000000
     ShellImpactDamage=Class'DH_Vehicles.DH_ShermanCannonShellDamageAP'
     ImpactDamage=475
     BallisticCoefficient=1.686000
     Speed=27943.000000
     MaxSpeed=27943.000000
     Damage=415.000000
     DamageRadius=1550.000000
     MyDamageType=Class'DH_Vehicles.DH_ShermanCannonShellDamageHE'
     Tag="M48 HE"
}
