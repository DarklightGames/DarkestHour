//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DHExitMovingVehicleDamageType extends DamageType
    abstract;

defaultproperties
{
    DeathString="%o was killed jumping from a speeding vehicle."
    FemaleSuicide="%o was killed jumping from a speeding vehicle."
    MaleSuicide="%o was killed jumping from a speeding vehicle."
    bLocationalHit=false
    bCausedByWorld=true
    GibModifier=0.0
}
