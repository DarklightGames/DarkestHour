//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_Pak40CannonShellDamageHE extends ROTankShellExplosionDamage;

defaultproperties
{
    HUDIcon=texture'DH_InterfaceArt_tex.deathicons.ATGunKill'
    TankDamageModifier=0.04
    APCDamageModifier=0.5
    VehicleDamageModifier=1.0
    TreadDamageModifier=0.85
    DeathString="%o was ripped by shrapnel from %k's Pak40 HE shell."
    FemaleSuicide="%o fired her Pak40 HE shell prematurely."
    MaleSuicide="%o fired his Pak40 shell prematurely."
    bArmorStops=true
    KDeathVel=300.0
    KDeathUpKick=60.0
    KDeadLinZVelScale=0.002
    KDeadAngVelScale=0.003
    VehicleMomentumScaling=1.4
    HumanObliterationThreshhold=265
}
