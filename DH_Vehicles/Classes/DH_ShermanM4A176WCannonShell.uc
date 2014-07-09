//==============================================================================
// DH_ShermanM4A176WCannonShell
//
// Darkest Hour Source - (c) Darkest Hour Team 2010
// Red Orchestra Source - (c) Tripwire Interactive 2006
//
// M4 American Sherman Tank - 76mm APC M62
//==============================================================================
class DH_ShermanM4A176WCannonShell extends DH_ROTankCannonShell;

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
     DHPenetrationTable(0)=12.500000
     DHPenetrationTable(1)=12.100000
     DHPenetrationTable(2)=11.600000
     DHPenetrationTable(3)=11.100000
     DHPenetrationTable(4)=10.600000
     DHPenetrationTable(5)=10.100000
     DHPenetrationTable(6)=9.700000
     DHPenetrationTable(7)=9.300000
     DHPenetrationTable(8)=8.900000
     DHPenetrationTable(9)=8.700000
     DHPenetrationTable(10)=7.400000
     ShellDiameter=7.620000
     bShatterProne=True
     ShellImpactDamage=Class'DH_Vehicles.DH_ShermanM4A176WCannonShellDamageAP'
     ImpactDamage=580
     BallisticCoefficient=1.627000
     Speed=47799.000000
     MaxSpeed=47799.000000
     Tag="M62 APC"
}
