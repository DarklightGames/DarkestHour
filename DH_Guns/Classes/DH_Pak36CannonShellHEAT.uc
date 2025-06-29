
//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================
// Stielgranate 41 for PaK 36
// [1] https://en.wikipedia.org/wiki/Stielgranate_41
//==============================================================================

class DH_Pak36CannonShellHEAT extends DHCannonShellHEAT;

defaultproperties
{
    Speed=6639  // [1] 110m/s
    MaxSpeed=6639
    DrawScale=1.0
    ImpactDamage=455
    
    Damage=600
    DamageRadius=600
    EngineFireChance=0.85  //more powerful HEAT round than most
    StaticMesh=StaticMesh'DH_Pak36_stc.STIELGRANATE_41'

    // Penetration
    DHPenetrationTable(0)=18.0  // [1] 1.8 cm of penetration
    DHPenetrationTable(1)=18.0
    DHPenetrationTable(2)=18.0
    DHPenetrationTable(3)=18.0
    DHPenetrationTable(4)=18.0
    DHPenetrationTable(5)=18.0
    DHPenetrationTable(6)=18.0

    // TODO: this sound is very WEAK, replace it
    VehicleHitSound=Sound'DH_WeaponSounds.faust_explode011'
    DirtHitSound=Sound'DH_WeaponSounds.faust_explode031'
    RockHitSound=Sound'DH_WeaponSounds.faust_explode011'
    WoodHitSound=Sound'DH_WeaponSounds.faust_explode021'
    WaterHitSound=Sound'ProjectileSounds.AP_Impact_Water'
    VehicleDeflectSound=Sound'Vehicle_Weapons.HE_deflect01'

    ExplosionSound(0)=Sound'DH_WeaponSounds.faust_explode011'
    ExplosionSound(1)=Sound'DH_WeaponSounds.faust_explode021'
    ExplosionSound(2)=Sound'DH_WeaponSounds.faust_explode031'

    bHasTracer=false
    bHasShellTrail=false
}
