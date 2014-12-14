//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_BARVehDamType extends ROVehicleDamageType
    abstract;

defaultproperties
{
    HUDIcon=Texture'InterfaceArt_tex.deathicons.b792mm'
    WeaponClass=class'DH_Weapons.DH_BARWeapon'
    DeathString="%o was killed by %k's M1918A2 Browning Automatic Rifle."
    FemaleSuicide="%o turned the gun on herself."
    MaleSuicide="%o turned the gun on himself."
    GibModifier=0.000000
    PawnDamageEmitter=class'ROEffects.ROBloodPuff'
    KDamageImpulse=200.000000
}
