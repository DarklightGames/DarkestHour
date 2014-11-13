//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_GreyhoundCannonShell extends DH_ROTankCannonShell;

defaultproperties
{
     MechanicalRanges(1)=(Range=400)
     MechanicalRanges(2)=(Range=800)
     MechanicalRanges(3)=(Range=1200)
     MechanicalRanges(4)=(Range=1600)
     bMechanicalAiming=true
     DHPenetrationTable(0)=7.100000
     DHPenetrationTable(1)=6.700000
     DHPenetrationTable(2)=6.300000
     DHPenetrationTable(3)=6.100000
     DHPenetrationTable(4)=5.700000
     DHPenetrationTable(5)=5.200000
     DHPenetrationTable(6)=4.800000
     DHPenetrationTable(7)=4.500000
     DHPenetrationTable(8)=4.100000
     DHPenetrationTable(9)=3.500000
     DHPenetrationTable(10)=3.000000
     ShellDiameter=3.700000
     bShatterProne=true
     ShellShatterEffectClass=class'DH_Effects.DH_TankAPShellShatterSmall'
     TracerEffect=class'DH_Effects.DH_RedTankShellTracer'
     ShellImpactDamage=class'DH_Vehicles.DH_GreyhoundCannonShellDamageAP'
     ImpactDamage=250
     VehicleDeflectSound=SoundGroup'ProjectileSounds.Bullets.PTRD_deflect'
     VehicleHitSound=SoundGroup'ProjectileSounds.Bullets.PTRD_penetrate'
     ShellHitVehicleEffectClass=class'ROEffects.TankAPHitPenetrateSmall'
     BallisticCoefficient=0.984000
     Speed=53291.000000
     MaxSpeed=53291.000000
     Tag="M51B1 APC"
}
