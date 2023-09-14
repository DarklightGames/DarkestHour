//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

// Gives a specific death message ("PlayerName was re-spawned by an admin")
// Used by the AdminMenuMutator when player is killed by an admin, either using a kill player option or a role/team switch option
class DHAdminMenu_DamageType extends DamageType
    abstract;

defaultproperties
{
    DeathString="%o was re-spawned by an admin"
    bLocationalHit=false
    bCausesBlood=false
    GibModifier=0.0
}
