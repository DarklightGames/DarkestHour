//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_Flak88CannonShellDamageAP extends DHTankShellImpactDamage
    abstract;

defaultproperties
{
    HUDIcon=texture'DH_InterfaceArt_tex.deathicons.ATGunKill'
    APCDamageModifier=0.75
    VehicleDamageModifier=1.5
    DeathString="%o was killed by %k's Flak 36 AT-Gun APCBC shell."
    FemaleSuicide="%o fired her Flak 36 AT-Gun APCBC shell prematurely."
    MaleSuicide="%o fired his Flak 36 AT-Gun APCBC shell prematurely."
}
