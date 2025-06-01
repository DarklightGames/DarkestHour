//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DHShellImpactDamageType extends ROTankShellImpactDamage
    abstract;

var bool bIsArtilleryImpact;

defaultproperties
{
    bIsArtilleryImpact=false
    APCDamageModifier=0.75
    VehicleDamageModifier=1.5
}

