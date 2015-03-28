//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DH_CanisterShotVehDamType extends DHVehicleDamageType
    abstract;

defaultproperties
{
    HUDIcon=texture'DH_InterfaceArt_tex.deathicons.canisterkill'
    VehicleDamageModifier=0.1
    DeathString="%o's vehicle was filled with holes by %k's canister shot."
}
