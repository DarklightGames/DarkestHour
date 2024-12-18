//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_Cannone4732CannonShellHE extends DHCannonShellHE;

defaultproperties
{
    Speed=15088 // 250 m/s
    MaxSpeed=15088
    ShellDiameter=4.7
    BallisticCoefficient=1.8218

    SpeedFudgeScale=0.75    // Increased from the normal 0.5 because the shell is so slow

    //Damage
    ImpactDamage=350            // TODO: pick an appropriate value
    ShellImpactDamage=class'DH_Engine.DHShellHEGunImpactDamageType'

    Damage=260.0                // TODO: pick an appropriate value
    DamageRadius=650.0          // TODO: pick an appropriate value

    MyDamageType=class'DH_Engine.DHShellHE50mmATDamageType'
    
    PenetrationMag=550.0
    HullFireChance=0.5
    EngineFireChance=0.5

    //Effects
    ShellHitDirtEffectClass=class'ROEffects.TankHEHitDirtEffect'
    ShellHitSnowEffectClass=class'ROEffects.TankHEHitSnowEffect'
    ShellHitWoodEffectClass=class'ROEffects.TankHEHitWoodEffect'
    ShellHitRockEffectClass=class'ROEffects.TankHEHitRockEffect'
    ShellHitWaterEffectClass=class'ROEffects.TankHEHitWaterEffect'

    //Penetration (values based on the Krupp calculations)
    DHPenetrationTable(0)=2.3   // 100m
    DHPenetrationTable(1)=2.2   // 250m
    DHPenetrationTable(2)=2.1   // 500m
    DHPenetrationTable(3)=2.0   // 750m
    DHPenetrationTable(4)=2.0   // 1000m
    DHPenetrationTable(5)=1.9   // 1250m
    DHPenetrationTable(6)=1.8   // 1500m
    DHPenetrationTable(7)=1.7   // 1750m
    DHPenetrationTable(8)=1.7   // 2000m
    DHPenetrationTable(9)=1.6   // 2500m
    DHPenetrationTable(10)=1.5  // 3000m

    bMechanicalAiming=true
    MechanicalRanges(0)=(Range=0,RangeValue=123)
    MechanicalRanges(1)=(Range=100,RangeValue=123)
    MechanicalRanges(2)=(Range=200,RangeValue=193)
    MechanicalRanges(3)=(Range=300,RangeValue=278)
    MechanicalRanges(4)=(Range=400,RangeValue=403)
    MechanicalRanges(5)=(Range=500,RangeValue=532)
    // TODO: anything beyond this stretches credulity with how far the pitch of the projectile is from the gun itself. should we turn this into a howitzer?
}
