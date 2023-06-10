//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_PanzerschreckRocket extends DHRocketProjectile;

defaultproperties
{
    Speed=6337.0
    MaxSpeed=6337.0
    StraightFlightTime=0.5

    //Damage
    ImpactDamage=455  //couldnt find info on filler, so i assume something about 1 KG
    Damage=600
    DamageRadius=600
    ShellImpactDamage=class'DH_Weapons.DH_PanzerschreckImpactDamType'
    MyDamageType=class'DH_Weapons.DH_PanzerschreckDamType'
    EngineFireChance=0.85  //more powerful HEAT round than most

    bDebugInImperial=false

    //Effects
    StaticMesh=StaticMesh'DH_WeaponPickups.Ammo.Panzerschreck_shell'
    bHasTracer=true // represents glow of burnt out rocket motor
    bHasShellTrail=true
    ShellTrailClass=class'DH_Effects.DHPanzerschreckTrail'

    //Penetration
    DHPenetrationTable(0)=17.6
    DHPenetrationTable(1)=17.6
    DHPenetrationTable(2)=17.6
    DHPenetrationTable(3)=17.6
    DHPenetrationTable(4)=17.6
    DHPenetrationTable(5)=17.6
    DHPenetrationTable(6)=17.6

    VehicleHitSound=Sound'DH_WeaponSounds.faust.faust_explode011'
    DirtHitSound=Sound'DH_WeaponSounds.faust.faust_explode031'
    RockHitSound=Sound'DH_WeaponSounds.faust.faust_explode011'
    WoodHitSound=Sound'DH_WeaponSounds.faust.faust_explode021'
    WaterHitSound=Sound'ProjectileSounds.cannon_rounds.AP_Impact_Water'
    VehicleDeflectSound=Sound'Vehicle_Weapons.Hits.HE_deflect01'

    ExplosionSound(0)=Sound'DH_WeaponSounds.faust.faust_explode011'
    ExplosionSound(1)=Sound'DH_WeaponSounds.faust.faust_explode021'
    ExplosionSound(2)=Sound'DH_WeaponSounds.faust.faust_explode031'
}
