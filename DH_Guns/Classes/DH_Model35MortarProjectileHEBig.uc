//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_Model35MortarProjectileHEBig extends DH_Model35MortarProjectileHE;

defaultproperties
{
    Speed=6500
    MaxSpeed=6500
    StaticMesh=StaticMesh'DH_Model35Mortar_stc.projectiles.IT_SMOKE_M110_A' // TODO: the name is incorrect here
    Damage=500.0
    DamageRadius=1350.0 // ~23 meters
}
