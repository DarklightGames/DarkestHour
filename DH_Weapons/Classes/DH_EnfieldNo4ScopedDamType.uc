//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_EnfieldNo4ScopedDamType extends ROWeaponProjectileDamageType
    abstract;

//=============================================================================
// defaultproperties
//=============================================================================

defaultproperties
{
     HUDIcon=Texture'InterfaceArt_tex.deathicons.b792mm'
     WeaponClass=Class'DH_Weapons.DH_EnfieldNo4ScopedWeapon'
     DeathString="%o was sniped by %k's scoped Enfield No.4."
     FemaleSuicide="%o turned the gun on herself."
     MaleSuicide="%o turned the gun on himself."
     GibModifier=0.000000
     PawnDamageEmitter=Class'ROEffects.ROBloodPuff'
     KDamageImpulse=2500.000000
}
