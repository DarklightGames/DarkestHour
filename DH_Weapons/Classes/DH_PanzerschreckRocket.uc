//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2020
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

    VehicleHitSound=SoundGroup'DH_MN_InfantryWeapons_sound.Geballte_Ladung.GeballteLadungExp01'
    DirtHitSound=SoundGroup'DH_MN_InfantryWeapons_sound.Geballte_Ladung.GeballteLadungExp01'
    RockHitSound=SoundGroup'DH_MN_InfantryWeapons_sound.Geballte_Ladung.GeballteLadungExp01'
    WoodHitSound=SoundGroup'DH_MN_InfantryWeapons_sound.Geballte_Ladung.GeballteLadungExp01'
    WaterHitSound=Sound'ProjectileSounds.cannon_rounds.AP_Impact_Water'
    VehicleDeflectSound=Sound'Vehicle_Weapons.Hits.HE_deflect01'

    ExplosionSound(0)=SoundGroup'DH_MN_InfantryWeapons_sound.Geballte_Ladung.GeballteLadungExp01'
    ExplosionSound(1)=SoundGroup'DH_MN_InfantryWeapons_sound.Geballte_Ladung.GeballteLadungExp01'
    ExplosionSound(2)=SoundGroup'DH_MN_InfantryWeapons_sound.Geballte_Ladung.GeballteLadungExp01'
}
