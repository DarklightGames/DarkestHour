//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DH_PantherGTank_ArdennesOne extends DH_PantherGTank;

defaultproperties
{
    DestroyedVehicleMesh=StaticMesh'DH_German_vehicles_stc.PantherG.PantherG_Destroyed4'
    Skins(0)=texture'DH_VehiclesGE_tex3.ext_vehicles.PantherG_body_ardennes1'
    CannonSkins(0)=texture'DH_VehiclesGE_tex3.ext_vehicles.PantherG_body_ardennes1'
    RandomAttachment=(Skin=none) // TODO: we don't have a schurzen skin for this camo variant, so add here if one gets made
}
