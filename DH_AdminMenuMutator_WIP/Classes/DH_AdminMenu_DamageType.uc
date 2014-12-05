//===============================================================================================================================
// DH_AdminMenu_DamageType - by Matt UK
//===============================================================================================================================
//
// Gives a specific death message ("PlayerName was re-spawned by an admin")
// Used by the AdminMenuMutator when player is killed by an admin, either using a kill player option or a role/team switch option
//
//===============================================================================================================================
class DH_AdminMenu_DamageType extends DamageType
    abstract;

defaultproperties
{
    DeathString="%o was re-spawned by an admin"
    bLocationalHit=false
    bArmorStops=false
    bCausesBlood=false
    GibModifier=0.0
}
