//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================
// Granata Modello 1935
//==============================================================================

class DH_Breda2065CannonShellHE extends DHCannonShellHE;

defaultproperties
{
    bNetTemporary=true // so is torn off straight after actor replication, like a bullet instead of a shell, due to volume of fire adding to net load (each shell is a net channel)

    Speed=50092
    MaxSpeed=50092
    ShellDiameter=2.0
    BallisticCoefficient=0.70 //G1 figure based on JBM calculation for US M95 20mm AP

    //Damage
    ImpactDamage=200
    ShellImpactDamage=class'DH_Vehicles.DH_Sdkfz2341CannonShellDamageHE'
    Damage=80.0 // 6.2g PETN
    DamageRadius=375.0
    MyDamageType=class'DH_Engine.DHShellHE20mmDamageType'
    HullFireChance=0.25
    EngineFireChance=0.35

    //Effects
    DrawScale=0.75
    bHasTracer=true
    bHasShellTrail=true
    ShellTrailClass=class'DH_Effects.DH20mmShellTrail_White'
    CoronaClass=class'DH_Effects.DHShellTracer_White'

    ShellHitDirtEffectClass=class'DH_Effects.DH20mmHEHitDirtEffect'
    ShellHitSnowEffectClass=class'DH_Effects.DH20mmHEHitSnowEffect'
    ShellHitWoodEffectClass=class'DH_Effects.DH20mmHEHitWoodEffect'
    ShellHitRockEffectClass=class'DH_Effects.DH20mmHEHitConcreteEffect'
    ShellHitWaterEffectClass=class'ROEffects.TankHEHitWaterEffect'

    ExplosionDecal=class'ROEffects.GrenadeMark'
    ExplosionDecalSnow=class'ROEffects.GrenadeMarkSnow'

    BlurTime=1.9
    BlurEffectScalar=1.3
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
    MechanicalRanges(0)=(Range=0,RangeValue=-2.0)
    MechanicalRanges(1)=(Range=100,RangeValue=11.0)
    MechanicalRanges(2)=(Range=200,RangeValue=18.0)
    MechanicalRanges(3)=(Range=300,RangeValue=26.0)
    MechanicalRanges(4)=(Range=400,RangeValue=35.0)
    MechanicalRanges(5)=(Range=500,RangeValue=42.0)
    MechanicalRanges(6)=(Range=600,RangeValue=52.0)
    MechanicalRanges(7)=(Range=700,RangeValue=61.0)
    MechanicalRanges(8)=(Range=800,RangeValue=73.0)
    MechanicalRanges(9)=(Range=900,RangeValue=85.0)
    MechanicalRanges(10)=(Range=1000,RangeValue=100.0)
    MechanicalRanges(11)=(Range=1100,RangeValue=116.0)
    MechanicalRanges(12)=(Range=1200,RangeValue=132.0)
    bMechanicalAiming=true
}
