//==============================================================================
// DH_AT57CannonShell
//
// Darkest Hour Source - (c) Darkest Hour Team 2010
// Red Orchestra Source - (c) Tripwire Interactive 2006
// AHZ AT Gun Source -(c) William "Teufelhund" Miller
//
// American 57mm APC shell M86
//==============================================================================
class DH_AT57CannonShell extends DH_ROTankCannonShell;

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
     DHPenetrationTable(0)=11.500000
     DHPenetrationTable(1)=11.000000
     DHPenetrationTable(2)=10.300000
     DHPenetrationTable(3)=9.600000
     DHPenetrationTable(4)=9.000000
     DHPenetrationTable(5)=8.400000
     DHPenetrationTable(6)=7.800000
     DHPenetrationTable(7)=7.300000
     DHPenetrationTable(8)=6.800000
     DHPenetrationTable(9)=6.000000
     DHPenetrationTable(10)=5.200000
     ShellDiameter=5.700000
     bShatterProne=true
     ShellShatterEffectClass=Class'DH_Effects.DH_TankAPShellShatterSmall'
     TracerEffect=Class'DH_Effects.DH_RedTankShellTracer'
     ShellImpactDamage=Class'DH_Guns.DH_AT57CannonShellDamageAP'
     ImpactDamage=350
     BallisticCoefficient=1.620000
     Speed=50152.000000
     MaxSpeed=50152.000000
     Tag="M86 APC"
}
