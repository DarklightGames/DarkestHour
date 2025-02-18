//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

// Gives a specific death message ("PlayerName was re-spawned by an admin")
// Used by the AdminMenuMutator when player is killed by an admin, either using a kill player option or a role/team switch option
class DHAdminMenu_DamageType extends DamageType
    abstract;

defaultproperties
{
    bLocationalHit=false
    bCausesBlood=false
    GibModifier=0.0
}
