//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_ThompsonDamType extends ROWeaponProjectileDamageType
    abstract;

defaultproperties
{
     HUDIcon=Texture'InterfaceArt_tex.deathicons.b762mm'
     WeaponClass=Class'DH_Weapons.DH_ThompsonWeapon'
     DeathString="%o was killed by %k's M1A1 Thompson."
     FemaleSuicide="%o turned the gun on herself."
     MaleSuicide="%o turned the gun on himself."
     GibModifier=0.000000
     PawnDamageEmitter=Class'ROEffects.ROBloodPuff'
     KDamageImpulse=1000.000000
     KDeathVel=100.000000
     KDeathUpKick=0.000000
}
