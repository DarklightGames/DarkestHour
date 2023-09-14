//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DHBurningDamageType extends ROWeaponDamageType
    abstract;

defaultproperties
{
    HUDIcon=Texture'DH_InterfaceArt_tex.deathicons.PlayerFireKill'
    DeathString="%o was burned to a crisp by a fire that %k started."
    MaleSuicide="%o burned himself to a crisp."
    FemaleSuicide="%o burned herself to a crisp."
    bLocationalHit=false
    GibModifier=0.0
}
