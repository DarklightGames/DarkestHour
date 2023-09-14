//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
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

    // Penetration
    // Many sources say this could penetrate 101.6mm (4") of armor at 30 degrees AOI.
    // Most of the US sources assume a 30 degree AOI in testing.
    // Therefore the effective penetration value against at a straight target is 117mm.
    // http://www.inert-ord.net/atrkts/bazoo/
    // https://en.wikipedia.org/wiki/Bazooka#Field_experience_induced_changes
    DHPenetrationTable(0)=11.7
    DHPenetrationTable(1)=11.7
    DHPenetrationTable(2)=11.7
    DHPenetrationTable(3)=11.7
    DHPenetrationTable(4)=11.7
    DHPenetrationTable(5)=11.7
    DHPenetrationTable(6)=11.7

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
