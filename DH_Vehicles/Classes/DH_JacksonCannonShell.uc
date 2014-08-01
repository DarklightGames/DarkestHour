//==============================================================================
// DH_JacksonCannonShell
//
// Darkest Hour Source - (c) Darkest Hour Team 2010
// Red Orchestra Source - (c) Tripwire Interactive 2006
//
// M36 American tank destroyer - 90mm APC M82
//==============================================================================
class DH_JacksonCannonShell extends DH_ROTankCannonShell;

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
     bMechanicalAiming=true
     DHPenetrationTable(0)=16.900000
     DHPenetrationTable(1)=16.799999
     DHPenetrationTable(2)=16.400000
     DHPenetrationTable(3)=15.700000
     DHPenetrationTable(4)=15.100000
     DHPenetrationTable(5)=14.400000
     DHPenetrationTable(6)=13.800000
     DHPenetrationTable(7)=13.300000
     DHPenetrationTable(8)=12.700000
     DHPenetrationTable(9)=11.500000
     DHPenetrationTable(10)=10.400000
     ShellDiameter=9.000000
     ShellImpactDamage=Class'DH_Vehicles.DH_JacksonCannonShellDamageAP'
     ImpactDamage=700
     BallisticCoefficient=2.134000
     Speed=49127.000000
     MaxSpeed=49127.000000
     Tag="M82 APC"
}
