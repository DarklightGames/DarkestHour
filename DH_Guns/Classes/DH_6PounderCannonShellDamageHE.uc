//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_6PounderCannonShellDamageHE extends ROTankShellExplosionDamage;

defaultproperties
{
    HUDIcon=texture'DH_InterfaceArt_tex.deathicons.ATGunKill'
    TankDamageModifier=0.0
    APCDamageModifier=0.5
    VehicleDamageModifier=1.0
    TreadDamageModifier=0.75
    DeathString="%o was ripped by shrapnel from %k's 6 Pounder HE shell."
    FemaleSuicide="%o fired her 6 Pounder AT-Gun HE shell prematurely."
    MaleSuicide="%o fired his 6 Pounder AT-Gun HE shell prematurely."
    bArmorStops=true
    KDeathVel=300.0
    KDeathUpKick=60.0
    KDeadLinZVelScale=0.002
    KDeadAngVelScale=0.003
    HumanObliterationThreshhold=200
}
