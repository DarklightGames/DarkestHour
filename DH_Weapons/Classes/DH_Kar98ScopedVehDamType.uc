//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_Kar98ScopedVehDamType extends ROVehicleDamageType
    abstract;

defaultproperties
{
    HUDIcon=Texture'InterfaceArt2_tex.deathicons.sniperkill'
    WeaponClass=class'DH_Weapons.DH_Kar98ScopedWeapon'
    DeathString="%o was sniped by %k's Karabiner 98k."
    FemaleSuicide="%o turned the gun on herself."
    MaleSuicide="%o turned the gun on himself."
    GibModifier=0.000000
    PawnDamageEmitter=class'ROEffects.ROBloodPuff'
    KDamageImpulse=200.000000
}
