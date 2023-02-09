//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DHShellImpactDamageType extends ROTankShellImpactDamage
    abstract;

var bool bIsArtilleryImpact;

defaultproperties
{
    bIsArtilleryImpact=false
    APCDamageModifier=0.75
    VehicleDamageModifier=1.5
    DeathString="%o was killed by %k's cannon shell."
    MaleSuicide="%o was killed by his own cannon shell."
    FemaleSuicide="%o was killed by her own cannon shell."
}

