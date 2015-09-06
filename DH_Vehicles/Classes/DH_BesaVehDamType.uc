//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DH_BesaVehDamType extends DHVehicleDamageType
    abstract;

defaultproperties
{
    HUDIcon=texture'InterfaceArt_tex.deathicons.b792mm'
    WeaponClass=class'DH_Weapons.DH_30calWeapon' // BESA is vehicle-mounted only, so doesn't have corresponding WeaponClass in DH_Weapons - nevermind, we just add its name to death strings below
    DeathString="%o was killed by %k's vehicle Besa machine gun."
    FemaleSuicide="%o was killed by her own vehicle Besa machine gun."
    MaleSuicide="%o was killed by his own vehicle Besa machine gun."
}
