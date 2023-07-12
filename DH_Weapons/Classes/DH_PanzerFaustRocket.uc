//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
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
