//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_Kar98ScopedDamType extends ROWeaponProjectileDamageType
    abstract;

defaultproperties
{
     HUDIcon=Texture'InterfaceArt_tex.deathicons.b792mm'
     WeaponClass=class'DH_Weapons.DH_Kar98ScopedWeapon'
     DeathString="%o was sniped by %k's Karabiner 98k."
     FemaleSuicide="%o turned the gun on herself."
     MaleSuicide="%o turned the gun on himself."
     GibModifier=0.000000
     PawnDamageEmitter=class'ROEffects.ROBloodPuff'
     KDamageImpulse=2500.000000
}
