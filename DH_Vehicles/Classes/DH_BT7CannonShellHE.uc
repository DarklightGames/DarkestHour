//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DH_BT7CannonShellHE extends DHCannonShellHE;

defaultproperties
{
    Tag="UO-243"
    BallisticCoefficient=1.2
    Speed=45806 // 759 M/S, (60.35 * 759), using BR-240 SP ( Armor Piercing Ballistic Cap )
    MaxSpeed=45806
    SpeedFudgeScale=0.50
    bDebugBallistics=false
    bMechanicalAiming=True
    ShellDiameter=4.5
    ImpactDamage=275.0
    Damage=225.0
    DamageRadius=500.0  //~9.0 meters
    MyDamageType=Class'DH_Engine.DHShellHE50mmDamageType'
    ShellImpactDamage=Class'DH_Vehicles.DH_BT7CannonShellDamageAP'
    PenetrationMag=630.0

    //New Penetration Table - based on 0 degree impact
    DHPenetrationTable[0]=2.9    //50
    DHPenetrationTable[1]=2.7    //100
    DHPenetrationTable[2]=2.4    //300
    DHPenetrationTable[3]=2.1    //600
    DHPenetrationTable[4]=1.9    //900
    DHPenetrationTable[5]=1.6    //1200
    DHPenetrationTable[6]=1.3    //1500
    DHPenetrationTable[7]=1.2    //1800
    DHPenetrationTable[8]=1.0    //2100
    DHPenetrationTable[9]=0.9    //2400
    DHPenetrationTable[10]=0.7   //2700

    //adjusts the range bar // disabled anyway
    OpticalRanges(0)=(Range=0,RangeValue=0.48)
    OpticalRanges(1)=(Range=250,RangeValue=0.496)
    OpticalRanges(2)=(Range=500,RangeValue=0.512)
    OpticalRanges(3)=(Range=750,RangeValue=0.540) // guess
    OpticalRanges(4)=(Range=1000,RangeValue=0.5426)
    OpticalRanges(5)=(Range=1500,RangeValue=0.5885)
    OpticalRanges(6)=(Range=2000,RangeValue=0.6441)
    OpticalRanges(7)=(Range=2500,RangeValue=0.7053)

    //adjusts the strike of the round (changed to normal superelevation angles)
    MechanicalRanges(0)=(Range=0,RangeValue=0)
    MechanicalRanges(1)=(Range=250,RangeValue=0)
    MechanicalRanges(2)=(Range=500,RangeValue=0)
    MechanicalRanges(3)=(Range=750,RangeValue=0)
    MechanicalRanges(4)=(Range=1000,RangeValue=0)
    MechanicalRanges(5)=(Range=1500,RangeValue=0) //
    MechanicalRanges(6)=(Range=2000,RangeValue=0) //
    MechanicalRanges(7)=(Range=2500,RangeValue=0) //

    ShellHitDirtEffectClass=Class'ROEffects.TankHEHitDirtEffect'
    ShellHitSnowEffectClass=Class'ROEffects.TankHEHitSnowEffect'
    ShellHitWoodEffectClass=Class'ROEffects.TankHEHitWoodEffect'
    ShellHitRockEffectClass=Class'ROEffects.TankHEHitRockEffect'
    ShellHitWaterEffectClass=Class'ROEffects.TankHEHitWaterEffect'
}
