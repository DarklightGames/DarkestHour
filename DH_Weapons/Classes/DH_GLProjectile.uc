//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_GLProjectile extends DH_SatchelCharge10lb10sProjectile;

defaultproperties
{
    MyDamageType=class'DH_Weapons.DH_GLDamType'
    StaticMesh=StaticMesh'DH_WeaponPickups.Weapons.GL_pickup'

    ExplosionSound(0)=SoundGroup'DH_MN_InfantryWeapons_sound.Geballte_Ladung.GeballteLadungExp01'
    ExplosionSound(1)=SoundGroup'DH_MN_InfantryWeapons_sound.Geballte_Ladung.GeballteLadungExp01'
    ExplosionSound(2)=SoundGroup'DH_MN_InfantryWeapons_sound.Geballte_Ladung.GeballteLadungExp01'

    Damage=760.0 // 1260 gramms TNT
    DamageRadius=1100 // about 18 meters
                      // practically, user has to either throw from cover or run away immediately

    EngineDamageMassThreshold=15.1  //1260 gramms TNT should penetrate every top armor, EXCEPT the jagdtiger (~40mm top armor) and KV-1 (30-40mm), which should be problematic
    EngineDamageRadius=240.0
    EngineDamageMax=800.0

    TreadDamageMassThreshold=12.0
    TreadDamageRadius=64.0
    TreadDamageMax=120.0

    FuzeLengthTimer=5.7 //doesnt seem to work here

    BlurTime=4.0
    ShakeRotTime=2.0
    ShakeScale=2.0
}
