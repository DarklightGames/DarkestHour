//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_JacksonCannonShellHE extends DH_ROTankCannonShellHE;

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
     DHPenetrationTable(0)=5.200000
     DHPenetrationTable(1)=4.900000
     DHPenetrationTable(2)=4.300000
     DHPenetrationTable(3)=4.000000
     DHPenetrationTable(4)=3.800000
     DHPenetrationTable(5)=3.200000
     DHPenetrationTable(6)=3.000000
     DHPenetrationTable(7)=2.700000
     DHPenetrationTable(8)=2.300000
     DHPenetrationTable(9)=1.900000
     DHPenetrationTable(10)=1.500000
     ShellDiameter=9.000000
     PenetrationMag=1020.000000
     ShellImpactDamage=class'DH_Vehicles.DH_JacksonCannonShellDamageAP'
     ImpactDamage=510
     BallisticCoefficient=1.790000
     Speed=49609.000000
     MaxSpeed=49609.000000
     Damage=450.000000
     DamageRadius=1570.000000
     MyDamageType=class'DH_Vehicles.DH_JacksonCannonShellDamageHE'
     Tag="M71 HE"
}
