//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2019
//==============================================================================

class DH_MolotovDamType extends DHThrowableExplosiveDamageType
    abstract;

defaultproperties
{
    WeaponClass = class'DH_Weapons.DH_MolotovWeapon'
    
    HUDIcon = Texture'DH_InterfaceArt_tex.deathicons.PlayerFireKill'
    DeathString = "%o was burned to a crisp by a fire that %k started."
    MaleSuicide = "%o burned himself to a crisp."
    FemaleSuicide = "%o burned herself to a crisp."
    
    bLocationalHit = false
    GibModifier = 0.0
    TankDamageModifier = 1.0
}
