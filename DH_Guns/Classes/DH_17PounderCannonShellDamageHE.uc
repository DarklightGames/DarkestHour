//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_17PounderCannonShellDamageHE extends ROTankShellExplosionDamage
      abstract;

defaultproperties
{
    HUDIcon=texture'DH_InterfaceArt_tex.deathicons.ATGunKill'
    TankDamageModifier=0.040000
    APCDamageModifier=0.500000
    VehicleDamageModifier=1.000000
    TreadDamageModifier=0.850000
    DeathString="%o was ripped by shrapnel from %k's 17 Pounder AT-Gun HE shell."
    FemaleSuicide="%o fired her 17 Pounder AT-Gun HE shell prematurely."
    MaleSuicide="%o fired his 17 Pounder AT-Gun HE shell prematurely."
    KDeathVel=300.000000
    KDeathUpKick=60.000000
    KDeadLinZVelScale=0.002000
    KDeadAngVelScale=0.003000
    VehicleMomentumScaling=1.400000
    HumanObliterationThreshhold=325
}
