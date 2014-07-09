//==============================================================================
// DH_WolverineCannonShellHVAP
//
// Darkest Hour Source - (c) Darkest Hour Team 2010
// Red Orchestra Source - (c) Tripwire Interactive 2006
//
// American Tank Destroyer - 76mm HVAP M93
//==============================================================================
class DH_WolverineCannonShellHVAP extends DH_ROTankCannonShellHVAP;

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
     DHPenetrationTable(0)=19.200001
     DHPenetrationTable(1)=17.700001
     DHPenetrationTable(2)=16.500000
     DHPenetrationTable(3)=14.600000
     DHPenetrationTable(4)=13.700000
     DHPenetrationTable(5)=12.500000
     DHPenetrationTable(6)=11.300000
     DHPenetrationTable(7)=10.600000
     DHPenetrationTable(8)=9.400000
     DHPenetrationTable(9)=8.000000
     DHPenetrationTable(10)=6.700000
     ShellDiameter=7.620000
     ShellImpactDamage=Class'DH_Vehicles.DH_WolverineCannonShellDamageHVAP'
     ImpactDamage=450
     BallisticCoefficient=0.888000
     SpeedFudgeScale=0.400000
     Speed=62525.000000
     MaxSpeed=62525.000000
     Tag="M93 HVAP"
}
