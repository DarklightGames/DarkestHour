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
    DHPenetrationTable(0)=12.6
    DHPenetrationTable(1)=12.6
    DHPenetrationTable(2)=12.6
    DHPenetrationTable(3)=12.6
    DHPenetrationTable(4)=12.6
    DHPenetrationTable(5)=12.6
    DHPenetrationTable(6)=12.6

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
