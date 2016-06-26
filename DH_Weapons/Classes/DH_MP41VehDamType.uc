//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DH_MP41VehDamType extends DHVehicleDamageType
    abstract;

defaultproperties
{
    HUDIcon=Texture'InterfaceArt_tex.deathicons.b9mm'
    WeaponClass=Class'DH_Weapons.DH_MP41Weapon'
    DeathString="%o was killed by %k's MP41."
    FemaleSuicide="%o turned the gun on herself."
    MaleSuicide="%o turned the gun on himself."
    GibModifier=0.000000
    PawnDamageEmitter=Class'ROEffects.ROBloodPuff'
    KDamageImpulse=200.000000
}
