//==============================================================================
// DH_AT57CannonShellHE
//
// Darkest Hour Source - (c) Darkest Hour Team 2010
// Red Orchestra Source - (c) Tripwire Interactive 2006
// AHZ AT Gun Source -(c) William "Teufelhund" Miller
//
// American 57mm HE shell M303
//==============================================================================
class DH_AT57CannonShellHE extends DH_ROTankCannonShellHE;

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
     OpticalRanges(1)=(Range=400)
     OpticalRanges(2)=(Range=800)
     OpticalRanges(3)=(Range=1200)
     OpticalRanges(4)=(Range=1600)
     OpticalRanges(5)=(Range=2000)
     OpticalRanges(6)=(Range=2400)
     OpticalRanges(7)=(Range=2800)
     OpticalRanges(8)=(Range=3200)
     OpticalRanges(9)=(Range=4200)
     DHPenetrationTable(0)=2.900000
     DHPenetrationTable(1)=2.700000
     DHPenetrationTable(2)=2.400000
     DHPenetrationTable(3)=2.100000
     DHPenetrationTable(4)=1.900000
     DHPenetrationTable(5)=1.600000
     DHPenetrationTable(6)=1.300000
     DHPenetrationTable(7)=1.200000
     DHPenetrationTable(8)=1.000000
     DHPenetrationTable(9)=0.900000
     DHPenetrationTable(10)=0.700000
     ShellDiameter=5.700000
     bHasTracer=True
     PenetrationMag=630.000000
     ShellImpactDamage=Class'DH_Guns.DH_AT57CannonShellDamageAP'
     ImpactDamage=295
     ShellHitDirtEffectClass=Class'ROEffects.TankHEHitDirtEffect'
     ShellHitSnowEffectClass=Class'ROEffects.TankHEHitSnowEffect'
     ShellHitWoodEffectClass=Class'ROEffects.TankHEHitWoodEffect'
     ShellHitRockEffectClass=Class'ROEffects.TankHEHitRockEffect'
     ShellHitWaterEffectClass=Class'ROEffects.TankHEHitWaterEffect'
     BallisticCoefficient=1.620000
     Speed=50152.000000
     MaxSpeed=50152.000000
     Damage=250.000000
     DamageRadius=600.000000
     MyDamageType=Class'DH_Guns.DH_AT57CannonShellDamageHE'
     Tag="M303 HE"
}
