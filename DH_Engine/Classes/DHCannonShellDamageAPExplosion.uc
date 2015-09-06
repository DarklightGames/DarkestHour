//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DHCannonShellDamageAPExplosion extends ROTankShellExplosionDamage
    abstract;

defaultproperties
{
    TankDamageModifier=0.0
    APCDamageModifier=0.05
    VehicleDamageModifier=0.25
    TreadDamageModifier=0.05
    DeathString="%o was killed by shrapnel from %k's AP shell."
    MaleSuicide="%o was killed by shrapnel from his own AP shell."
    FemaleSuicide="%o was killed by shrapnel from her own AP shell."
}
