//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2018
//==============================================================================

class DHSuicideDamageType extends DHDamageType
    abstract;

defaultproperties
{
    DeathString="%o killed himself."
    MaleSuicide="%o killed himself."
    FemaleSuicide="%o killed himself."

    HUDIcon=texture'InterfaceArt_tex.deathicons.mine'

    bLocationalHit=false
    bArmorStops=false
}
