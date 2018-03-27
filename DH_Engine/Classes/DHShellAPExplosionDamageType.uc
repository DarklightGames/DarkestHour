//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2018
//==============================================================================

class DHShellAPExplosionDamageType extends DHVehicleWeaponDamageType
    abstract;

defaultproperties
{
    DeathString="%o was blown up by %k's cannon shell."
    MaleSuicide="%o was blown up his own cannon shell."
    FemaleSuicide="%o was blown up by her own cannon shell."

    VehicleMomentumScaling=1.0
    KDamageImpulse=1000.0
    KDeathVel=150.0
    KDeathUpKick=50.0
    HumanObliterationThreshhold=180
    KDeadLinZVelScale=0.002
    KDeadAngVelScale=0.003

    TankDamageModifier=0.0
    APCDamageModifier=0.05
    VehicleDamageModifier=0.25
    TreadDamageModifier=0.05
}
