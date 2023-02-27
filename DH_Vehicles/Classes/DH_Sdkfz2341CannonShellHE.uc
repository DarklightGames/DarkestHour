//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_Sdkfz2341CannonShellHE extends DHCannonShellHE;

defaultproperties
{
    bNetTemporary=true // so is torn off straight after actor replication, like a bullet instead of a shell, due to volume of fire adding to net load (each shell is a net channel)

    Speed=47075.0
    MaxSpeed=47075.0
    ShellDiameter=2.0
    BallisticCoefficient=0.68 //G1 figure based on JBM calculation for US M95 20mm AP

    //Damage
    ImpactDamage=200
    ShellImpactDamage=class'DH_Vehicles.DH_Sdkfz2341CannonShellDamageHE'
    Damage=75.0 //10.2 gr of TNT
    DamageRadius=250
    MyDamageType=class'DH_Engine.DHShellHE20mmDamageType'
    HullFireChance=0.25
    EngineFireChance=0.35

    //Effects
    DrawScale=0.75
    bHasTracer=true
    bHasShellTrail=true
    ShellTrailClass=class'DH_Effects.DH20mmShellTrail_YellowOrange'
    CoronaClass=class'DH_Effects.DHShellTracer_Orange'

    ShellHitDirtEffectClass=class'DH_Effects.DH20mmHEHitDirtEffect'
    ShellHitSnowEffectClass=class'DH_Effects.DH20mmHEHitSnowEffect'
    ShellHitWoodEffectClass=class'DH_Effects.DH20mmHEHitWoodEffect'
    ShellHitRockEffectClass=class'DH_Effects.DH20mmHEHitConcreteEffect'
    ShellHitWaterEffectClass=class'ROEffects.TankHEHitWaterEffect'

    ExplosionDecal=class'ROEffects.GrenadeMark'
    ExplosionDecalSnow=class'ROEffects.GrenadeMarkSnow'

    BlurTime=2.0
    BlurEffectScalar=0.9
    PenetrationMag=110.0

    //Sound
    VehicleHitSound=SoundGroup'ProjectileSounds.Bullets.PTRD_penetrate'

    bDebugInImperial=false

    //Penetration
    DHPenetrationTable(0)=1.9
    DHPenetrationTable(1)=1.6
    DHPenetrationTable(2)=1.3
    DHPenetrationTable(3)=1.1
    DHPenetrationTable(4)=0.9
    DHPenetrationTable(5)=0.5
    DHPenetrationTable(6)=0.3
    DHPenetrationTable(7)=0.1

    //Gunsights adjustment
    MechanicalRanges(1)=(Range=100,RangeValue=33.0)
    MechanicalRanges(2)=(Range=200,RangeValue=37.0)
    MechanicalRanges(3)=(Range=300,RangeValue=41.0)
    MechanicalRanges(4)=(Range=400,RangeValue=48.0)
    MechanicalRanges(5)=(Range=500,RangeValue=56.0)
    MechanicalRanges(6)=(Range=600,RangeValue=64.0)
    MechanicalRanges(7)=(Range=700,RangeValue=76.0)
    MechanicalRanges(8)=(Range=800,RangeValue=87.0)
    MechanicalRanges(9)=(Range=900,RangeValue=97.0)
    MechanicalRanges(10)=(Range=1000,RangeValue=109.0)
    MechanicalRanges(11)=(Range=1100,RangeValue=122.0)
    MechanicalRanges(12)=(Range=1200,RangeValue=131.0)
    bMechanicalAiming=true
}
