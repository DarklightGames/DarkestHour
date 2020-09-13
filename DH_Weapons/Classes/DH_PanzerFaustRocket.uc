//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2020
//==============================================================================

class DH_PanzerFaustRocket extends DHRocketProjectile;

defaultproperties
{
    StraightFlightTime=0.25
    DHPenetrationTable(0)=21.6
    DHPenetrationTable(1)=21.6
    DHPenetrationTable(2)=21.6
    DHPenetrationTable(3)=21.6
    DHPenetrationTable(4)=21.6
    DHPenetrationTable(5)=21.6
    DHPenetrationTable(6)=21.6
    bDebugInImperial=false
    bHasTracer=false


    ShellImpactDamage=class'DH_Weapons.DH_PanzerFaustImpactDamType'
    ImpactDamage=490   //1.5 KG
    Damage=1000
    DamageRadius=700 //less than other projectiles with similar amount of explosives, but thats because this one has no fragmentation what so ever and usually explodes on armored vehicle, thus not hitting debree on the ground
    EngineFireChance=0.9 //more powerful HEAT round than most

    BallisticCoefficient=0.075
    Speed=2716.0
    MaxSpeed=2716.0
    MyDamageType=class'DH_Weapons.DH_PanzerFaustDamType'
    StaticMesh=StaticMesh'DH_Military_Axis.Weapons.Panzerfaust_warhead'

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
