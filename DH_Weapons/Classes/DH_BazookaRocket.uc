//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_BazookaRocket extends DHRocketProjectile;

defaultproperties
{
    Speed=4967.0
    MaxSpeed=4967.0
    BallisticCoefficient=0.0475 //guestimate
    Damage=350.0
    DamageRadius=740.0  //700 gramms
    ShellImpactDamage=Class'DH_BazookaImpactDamType'

    MyDamageType=Class'DH_BazookaDamType'

    StraightFlightTime=0.5

    //Effects
    bHasSmokeTrail=false // bazooka has no smoke trail irl
    bHasTracer=true // represents glow of burnt out rocket motor
    StaticMesh=StaticMesh'DH_WeaponPickups.Bazooka_shell'

    //Penetration
    DHPenetrationTable(0)=9.8
    DHPenetrationTable(1)=9.8
    DHPenetrationTable(2)=9.8
    DHPenetrationTable(3)=9.8
    DHPenetrationTable(4)=9.8
    DHPenetrationTable(5)=9.8
    DHPenetrationTable(6)=9.8

    //Sounds
    VehicleHitSound=SoundGroup'DH_MN_InfantryWeapons_sound.PiatExp01'
    DirtHitSound=SoundGroup'DH_MN_InfantryWeapons_sound.PiatExp01'
    RockHitSound=SoundGroup'DH_MN_InfantryWeapons_sound.PiatExp01'
    WoodHitSound=SoundGroup'DH_MN_InfantryWeapons_sound.PiatExp01'
    WaterHitSound=Sound'ProjectileSounds.AP_Impact_Water'
    VehicleDeflectSound=Sound'Vehicle_Weapons.HE_deflect01'

    ExplosionSound(0)=SoundGroup'DH_MN_InfantryWeapons_sound.PiatExp01'
    ExplosionSound(1)=SoundGroup'DH_MN_InfantryWeapons_sound.PiatExp02'
    ExplosionSound(2)=SoundGroup'DH_MN_InfantryWeapons_sound.PiatExp03'
}
