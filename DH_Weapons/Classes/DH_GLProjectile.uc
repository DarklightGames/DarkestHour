//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2019
//==============================================================================

class DH_GLProjectile extends DH_SatchelCharge10lb10sProjectile;

defaultproperties
{
    MyDamageType=class'DH_Weapons.DH_GLDamType'
    StaticMesh=StaticMesh'DH_WeaponPickups.Weapons.GL'

    ExplosionSound(0)=SoundGroup'DH_MN_InfantryWeapons_sound.Geballte_Ladung.GeballteLadungExp01'
    ExplosionSound(1)=SoundGroup'DH_MN_InfantryWeapons_sound.Geballte_Ladung.GeballteLadungExp01'
    ExplosionSound(2)=SoundGroup'DH_MN_InfantryWeapons_sound.Geballte_Ladung.GeballteLadungExp01'

    Damage=1260.0 // 1260 gramms TNT +some fragmentation, since its a bundle of potato mashers
    DamageRadius=1300 // about 22 meters, a lot because its powerful and its made from hand grenades with some fragmentation
                      // practically, user has to either throw from cover or run away immediately
    EngineDamageMassThreshold=10.0
    EngineDamageRadius=185.0
    EngineDamageMax=400.0

    TreadDamageMassThreshold=12.0
    TreadDamageRadius=64.0
    TreadDamageMax=200.0
    FuzeLengthTimer=5.7 //doesnt seem to work here
}
