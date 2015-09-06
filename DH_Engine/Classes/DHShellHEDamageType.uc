//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DHShellHEDamageType extends ROTankShellExplosionDamage // Matt: this DH class is not used by any HE shell damage types
    abstract;                                                // TODO: examine differences, modify as necessary & get them to extend from this class

defaultproperties
{
    TankDamageModifier=0.03   // RO is 0.05
    APCDamageModifier=1.0     // RO is 0.25
    VehicleDamageModifier=1.0 // RO is 0.50
    TreadDamageModifier=0.85  // RO is 0.25
    DeathString="%o was blown apart by %k's HE shell."
    MaleSuicide="%o was blown apart his own HE shell."
    FemaleSuicide="%o was blown apart by her own HE shell."
    KDeathVel=300.0         // RO is 250
    KDeathUpKick=60.0       // RO is 50
    KDeadLinZVelScale=0.002 // RO is default 0
    KDeadAngVelScale=0.003  // RO is default 0
    HumanObliterationThreshhold=265 // RO is default 1,000,000
}
