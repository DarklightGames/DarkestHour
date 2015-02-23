//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_17PounderCannonShellDamageHE extends ROTankShellExplosionDamage
    abstract;

defaultproperties
{
    HUDIcon=texture'DH_InterfaceArt_tex.deathicons.ATGunKill'
    TankDamageModifier=0.04
    APCDamageModifier=0.5
    VehicleDamageModifier=1.0
    TreadDamageModifier=0.85
    DeathString="%o was ripped by shrapnel from %k's 17 Pounder AT-Gun HE shell."
    FemaleSuicide="%o fired her 17 Pounder AT-Gun HE shell prematurely."
    MaleSuicide="%o fired his 17 Pounder AT-Gun HE shell prematurely."
    KDeathVel=300.0
    KDeathUpKick=60.0
    KDeadLinZVelScale=0.002
    KDeadAngVelScale=0.003
    VehicleMomentumScaling=1.4
    HumanObliterationThreshhold=325
}
