//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2017
//==============================================================================

class DHSpawnKillDamageType extends ROWeaponDamageType
    abstract;

defaultproperties
{
    HUDIcon=texture'DH_InterfaceArt_tex.deathicons.spawnkill'
    DeathString="%o was spawn killed by %k."
    MaleSuicide="%o spawn killed himself."
    FemaleSuicide="%o spawn killed herself."
    bLocationalHit=false
    GibModifier=0.0
}
