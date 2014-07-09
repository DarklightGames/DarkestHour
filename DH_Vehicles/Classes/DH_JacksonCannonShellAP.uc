//==============================================================================
// DH_JacksonCannonShellAP
//
// Darkest Hour Source - (c) Darkest Hour Team 2010
// Red Orchestra Source - (c) Tripwire Interactive 2006
//
// M36 American tank destroyer - 90mm AP shot M77
//==============================================================================
class DH_JacksonCannonShellAP extends DH_ROTankCannonShell;

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
     DHPenetrationTable(0)=18.799999
     DHPenetrationTable(1)=17.900000
     DHPenetrationTable(2)=16.299999
     DHPenetrationTable(3)=15.000000
     DHPenetrationTable(4)=13.700000
     DHPenetrationTable(5)=12.500000
     DHPenetrationTable(6)=11.500000
     DHPenetrationTable(7)=10.500000
     DHPenetrationTable(8)=9.600000
     DHPenetrationTable(9)=8.100000
     DHPenetrationTable(10)=6.800000
     ShellDiameter=9.000000
     ShellImpactDamage=Class'DH_Vehicles.DH_JacksonCannonShellDamageAPShot'
     ImpactDamage=625
     BallisticCoefficient=1.564000
     Speed=49609.000000
     MaxSpeed=49609.000000
     Tag="M77 AP"
}
