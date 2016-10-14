//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DH_BT7CannonShellHE extends DHCannonShellHE;

defaultproperties
{
    ShellDiameter=4.5
    BallisticCoefficient=1.2
    Speed=45806 // 759 m/s
    MaxSpeed=45806
    Damage=225.0
    DamageRadius=500.0
    MyDamageType=class'DH_Engine.DHShellHE50mmDamageType'
    ImpactDamage=275
    ShellImpactDamage=class'DH_Vehicles.DH_BT7CannonShellDamageAP'
    PenetrationMag=630.0
    Tag="UO-243"
    bMechanicalAiming=true

    ShellHitDirtEffectClass=class'ROEffects.TankHEHitDirtEffect'
    ShellHitSnowEffectClass=class'ROEffects.TankHEHitSnowEffect'
    ShellHitWoodEffectClass=class'ROEffects.TankHEHitWoodEffect'
    ShellHitRockEffectClass=class'ROEffects.TankHEHitRockEffect'
    ShellHitWaterEffectClass=class'ROEffects.TankHEHitWaterEffect'

    DHPenetrationTable[0]=2.9
    DHPenetrationTable[1]=2.7
    DHPenetrationTable[2]=2.4
    DHPenetrationTable[3]=2.1
    DHPenetrationTable[4]=1.9
    DHPenetrationTable[5]=1.6
    DHPenetrationTable[6]=1.3
    DHPenetrationTable[7]=1.2
    DHPenetrationTable[8]=1.0
    DHPenetrationTable[9]=0.9
    DHPenetrationTable[10]=0.7

    MechanicalRanges(0)=(Range=0,RangeValue=0)
    MechanicalRanges(1)=(Range=250,RangeValue=0)
    MechanicalRanges(2)=(Range=500,RangeValue=0)
    MechanicalRanges(3)=(Range=750,RangeValue=0)
    MechanicalRanges(4)=(Range=1000,RangeValue=0)
    MechanicalRanges(5)=(Range=1500,RangeValue=0)
    MechanicalRanges(6)=(Range=2000,RangeValue=0)
    MechanicalRanges(7)=(Range=2500,RangeValue=0)

    OpticalRanges(0)=(Range=0,RangeValue=0.48)
    OpticalRanges(1)=(Range=250,RangeValue=0.496)
    OpticalRanges(2)=(Range=500,RangeValue=0.512)
    OpticalRanges(3)=(Range=750,RangeValue=0.540) // guess
    OpticalRanges(4)=(Range=1000,RangeValue=0.5426)
    OpticalRanges(5)=(Range=1500,RangeValue=0.5885)
    OpticalRanges(6)=(Range=2000,RangeValue=0.6441)
    OpticalRanges(7)=(Range=2500,RangeValue=0.7053)
}
