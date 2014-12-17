//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_CanisterShotDamType extends DHWeaponProjectileDamageType
    abstract;

defaultproperties
{
    HUDIcon=Texture'DH_InterfaceArt_tex.deathicons.canisterkill'
    DeathString="%o was filled with holes by %k's canister shot."
    KDamageImpulse=2250.000000
}
