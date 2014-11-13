//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_EnfieldNo2DamType extends ROWeaponProjectileDamageType
    abstract;

//=============================================================================
// defaultproperties
//=============================================================================

defaultproperties
{
     HUDIcon=Texture'InterfaceArt_tex.deathicons.b762mm'
     WeaponClass=Class'DH_Weapons.DH_EnfieldNo2Weapon'
     DeathString="%o was killed by %k's Enfield No2."
     FemaleSuicide="%o turned the gun on herself."
     MaleSuicide="%o turned the gun on himself."
     GibModifier=0.000000
     PawnDamageEmitter=Class'ROEffects.ROBloodPuff'
     KDamageImpulse=750.000000
     KDeathVel=100.000000
     KDeathUpKick=0.000000
}
