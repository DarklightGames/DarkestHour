//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DHCannonShellDamageSmoke extends ROTankShellExplosionDamage
    abstract;

defaultproperties
{
    TankDamageModifier=0.0
    APCDamageModifier=0.75
    VehicleDamageModifier=1.0
    TreadDamageModifier=0.5
    DeathString="%o was killed by shrapnel from %k's smoke shell."
    MaleSuicide="%o was killed by shrapnel from his own smoke shell."
    FemaleSuicide="%o was killed by shrapnel from her own smoke shell."
    KDamageImpulse=3000.0
    VehicleMomentumScaling=1.1
    HumanObliterationThreshhold=180
}
