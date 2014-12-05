//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_6PounderCannonShellDamageHE extends ROTankShellExplosionDamage;

defaultproperties
{
    HUDIcon=Texture'DH_InterfaceArt_tex.deathicons.ATGunKill'
    TankDamageModifier=0.000000
    APCDamageModifier=0.500000
    VehicleDamageModifier=1.000000
    TreadDamageModifier=0.750000
    DeathString="%o was ripped by shrapnel from %k's 6 Pounder HE shell."
    FemaleSuicide="%o fired her 6 Pounder AT-Gun HE shell prematurely."
    MaleSuicide="%o fired his 6 Pounder AT-Gun HE shell prematurely."
    bArmorStops=true
    KDeathVel=300.000000
    KDeathUpKick=60.000000
    KDeadLinZVelScale=0.002000
    KDeadAngVelScale=0.003000
    HumanObliterationThreshhold=200
}
