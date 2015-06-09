//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DH_Cromwell6PdrCannonShellDamageHE extends ROTankShellExplosionDamage;

defaultproperties
{
    TankDamageModifier=0.0
    APCDamageModifier=0.5
    VehicleDamageModifier=1.0
    TreadDamageModifier=0.75
    DeathString="%o was ripped apart by shrapnel from %k's Cromwell 6 Pounder HE shell."
    FemaleSuicide="%o fired her Cromwell 6 Pounder HE shell prematurely."
    MaleSuicide="%o fired his Cromwell 6 Pounder HE shell prematurely."
    KDeathVel=300.0
    KDeathUpKick=60.0
    KDeadLinZVelScale=0.002
    KDeadAngVelScale=0.003
    HumanObliterationThreshhold=200
}
