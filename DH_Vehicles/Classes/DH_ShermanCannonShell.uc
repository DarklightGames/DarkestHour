//==============================================================================
// DH_ShermanCannonShell
//
// Darkest Hour Source - (c) Darkest Hour Team 2010
// Red Orchestra Source - (c) Tripwire Interactive 2006
//
// M4 American Sherman tank - 75mm APC M61
//==============================================================================
class DH_ShermanCannonShell extends DH_ROTankCannonShell;

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
     DHPenetrationTable(0)=8.800000
     DHPenetrationTable(1)=8.500000
     DHPenetrationTable(2)=8.100000
     DHPenetrationTable(3)=7.700000
     DHPenetrationTable(4)=7.300000
     DHPenetrationTable(5)=6.900000
     DHPenetrationTable(6)=6.500000
     DHPenetrationTable(7)=6.200000
     DHPenetrationTable(8)=5.900000
     DHPenetrationTable(9)=5.300000
     DHPenetrationTable(10)=4.700000
     ShellDiameter=7.500000
     ShellImpactDamage=Class'DH_Vehicles.DH_ShermanCannonShellDamageAP'
     ImpactDamage=540
     BallisticCoefficient=1.735000
     Speed=37358.000000
     MaxSpeed=37358.000000
     Tag="M61 APC"
}
