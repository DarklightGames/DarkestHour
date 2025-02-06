//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
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
