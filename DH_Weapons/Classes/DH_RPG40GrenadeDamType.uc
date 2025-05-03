//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2020
//==============================================================================

class DH_RPG40GrenadeDamType extends DHThrowableExplosiveDamageType
    abstract;

defaultproperties
{
    WeaponClass=class'DH_Weapons.DH_RPG40GrenadeWeapon'
    HUDIcon=Texture'DH_InterfaceArt_tex.deathicons.rpg43kill'

    GibModifier=2.0
    KDamageImpulse=1266.0
    KDeathVel=300.0
    KDeathUpKick=75.0
    KDeadLinZVelScale=0.0015
    KDeadAngVelScale=0.0015
    HumanObliterationThreshhold=200
}
