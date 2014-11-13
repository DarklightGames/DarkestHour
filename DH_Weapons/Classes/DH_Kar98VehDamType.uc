//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_Kar98VehDamType extends ROVehicleDamageType
    abstract;

//=============================================================================
// defaultproperties
//=============================================================================

defaultproperties
{
     HUDIcon=Texture'InterfaceArt_tex.deathicons.b792mm'
     WeaponClass=Class'DH_Weapons.DH_Kar98Weapon'
     DeathString="%o was killed by %k's Karabiner 98k."
     FemaleSuicide="%o turned the gun on herself."
     MaleSuicide="%o turned the gun on himself."
     GibModifier=0.000000
     PawnDamageEmitter=Class'ROEffects.ROBloodPuff'
     KDamageImpulse=200.000000
}
