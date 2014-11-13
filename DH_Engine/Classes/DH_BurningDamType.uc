//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_BurningDamType extends ROWeaponDamageType
    abstract;

defaultproperties
{
     HUDIcon=Texture'DH_InterfaceArt_tex.deathicons.PlayerFireKill'
     DeathString="%o was burned to a crisp by a fire that %k lit."
     FemaleSuicide="%o burned himself to a crisp."
     MaleSuicide="%o burned himself to a crisp."
     bLocationalHit=false
     GibModifier=0.000000
}
