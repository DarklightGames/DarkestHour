//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2021
//==============================================================================
// M6A3 Rocket
//==============================================================================

class DH_BazookaM9Rocket extends DHRocketProjectile;

defaultproperties
{
    Speed=4967.0
    MaxSpeed=4967.0
    BallisticCoefficient=0.0475 //guestimate
    Damage=350.0
    DamageRadius=740.0  //700 gramms
    ShellImpactDamage=class'DH_Weapons.DH_BazookaImpactDamType'

    MyDamageType=class'DH_Weapons.DH_BazookaDamType'

    StraightFlightTime=0.5

    //Effects
    bHasSmokeTrail=false // bazooka has no smoke trail irl
    bHasTracer=true // represents glow of burnt out rocket motor
    StaticMesh=StaticMesh'DH_WeaponPickups.Ammo.m6a3_world'

    //Penetration
    // https://forum.axishistory.com/viewtopic.php?p=1609910&sid=1f9a38054c5e7bf8b3bf9e088c494877#p1609910
    DHPenetrationTable(0)=10.2
    DHPenetrationTable(1)=10.2
    DHPenetrationTable(2)=10.2
    DHPenetrationTable(3)=10.2
    DHPenetrationTable(4)=10.2
    DHPenetrationTable(5)=10.2
    DHPenetrationTable(6)=10.2

    //Sounds
    VehicleHitSound=SoundGroup'DH_MN_InfantryWeapons_sound.PIAT.PiatExp01'
    DirtHitSound=SoundGroup'DH_MN_InfantryWeapons_sound.PIAT.PiatExp01'
    RockHitSound=SoundGroup'DH_MN_InfantryWeapons_sound.PIAT.PiatExp01'
    WoodHitSound=SoundGroup'DH_MN_InfantryWeapons_sound.PIAT.PiatExp01'
    WaterHitSound=Sound'ProjectileSounds.cannon_rounds.AP_Impact_Water'
    VehicleDeflectSound=Sound'Vehicle_Weapons.Hits.HE_deflect01'

    ExplosionSound(0)=SoundGroup'DH_MN_InfantryWeapons_sound.PIAT.PiatExp01'
    ExplosionSound(1)=SoundGroup'DH_MN_InfantryWeapons_sound.PIAT.PiatExp02'
    ExplosionSound(2)=SoundGroup'DH_MN_InfantryWeapons_sound.PIAT.PiatExp03'
}
