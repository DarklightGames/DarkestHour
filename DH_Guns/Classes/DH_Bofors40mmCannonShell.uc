//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2019
//==============================================================================

class DH_Bofors40mmCannonShell extends DHBullet_ArmorPiercing;

defaultproperties
{
    Speed=53170.0
    MaxSpeed=53170.0
    ShellDiameter=4.0
    BallisticCoefficient=0.984 // TODO: try to find an accurate BC (this is same as US 37mm)

    //Damage
    ImpactDamage=265
    ShellImpactDamage=class'DH_Engine.DHShellAPGunImpactDamageType'
    HullFireChance=0.23
    EngineFireChance=0.35

    bShatterProne=true

    //Effects
    bHasTracer=true
    DrawType=DT_StaticMesh
    StaticMesh=StaticMesh'WeaponPickupSM.Ammo.76mm_Shell'
    DeflectedMesh=StaticMesh'WeaponPickupSM.Ammo.76mm_Shell'
    ShellShatterEffectClass=class'DH_Effects.DHShellShatterEffect_Small'
    TracerEffectClass=class'DH_Effects.DHBulletTracer_RedLarge'
    VehicleDeflectSound=SoundGroup'ProjectileSounds.Bullets.PTRD_deflect'
    VehicleHitSound=SoundGroup'ProjectileSounds.Bullets.PTRD_penetrate'
    ShellHitVehicleEffectClass=class'ROEffects.TankAPHitPenetrateSmall'

    //Penetration
    DHPenetrationTable(0)=6.0  // 100m // TODO: try to get some accurate penetration data (this uses reported penetration at 100, 500, 1k & 2k ranges, with the gaps then estimated)
    DHPenetrationTable(1)=5.5  // 250m
    DHPenetrationTable(2)=4.9  // 500m
    DHPenetrationTable(3)=4.4
    DHPenetrationTable(4)=4.0  // 1000m
    DHPenetrationTable(5)=3.6
    DHPenetrationTable(6)=3.3  // 1500m
    DHPenetrationTable(7)=3.0
    DHPenetrationTable(8)=2.7  // 2000m
    DHPenetrationTable(9)=2.2
    DHPenetrationTable(10)=1.7 // 3000m
}
