//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DH_Pak43CannonShellDamageAP extends DHTankShellImpactDamage
    abstract;

defaultproperties
{
    HUDIcon=texture'DH_InterfaceArt_tex.deathicons.ATGunKill'
    APCDamageModifier=0.75
    VehicleDamageModifier=1.5
    DeathString="%o was killed by %k's Pak43 APCBC shell."
    FemaleSuicide="%o fired her Pak43 APCBC shell prematurely."
    MaleSuicide="%o fired his Pak43 APCBC shell prematurely."
}
