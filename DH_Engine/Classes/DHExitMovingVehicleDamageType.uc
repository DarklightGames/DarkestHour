//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
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
