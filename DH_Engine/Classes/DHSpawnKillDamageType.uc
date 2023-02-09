//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DHSpawnKillDamageType extends DHInstantObituaryDamageTypes
    abstract;

defaultproperties
{
    HUDIcon=Texture'DH_InterfaceArt_tex.deathicons.spawnkill'
    DeathString="%o was spawn killed by %k."
    MaleSuicide="%o spawn killed himself."
    FemaleSuicide="%o spawn killed herself."
}
