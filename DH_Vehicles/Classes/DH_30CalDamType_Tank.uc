//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_30CalDamType_Tank extends ROWeaponProjectileDamageType
    abstract;

defaultproperties
{
     HUDIcon=Texture'InterfaceArt_tex.deathicons.b792mm'
     WeaponClass=class'DH_Weapons.DH_30calWeapon'
     DeathString="%o was killed by %k's vehicle .30 cal."
     FemaleSuicide="%o turned the gun on herself."
     MaleSuicide="%o turned the gun on himself."
     GibModifier=0.000000
     PawnDamageEmitter=class'ROEffects.ROBloodPuff'
     KDamageImpulse=1500.000000
     KDeathVel=110.000000
     KDeathUpKick=2.000000
}
