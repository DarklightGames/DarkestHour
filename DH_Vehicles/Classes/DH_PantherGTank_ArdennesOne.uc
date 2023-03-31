//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_PantherGTank_ArdennesOne extends DH_PantherGTank;

defaultproperties
{
    Skins(0)=Texture'DH_VehiclesGE_tex3.ext_vehicles.PantherG_body_ardennes1'
    CannonSkins(0)=Texture'DH_VehiclesGE_tex3.ext_vehicles.PantherG_body_ardennes1'
    RandomAttachment=(Skins=(none)) // TODO: we don't have a schurzen skin for this camo variant, so add here if one gets made
    DestroyedVehicleMesh=StaticMesh'DH_German_vehicles_stc.PantherG.PantherG_Destroyed4'
}
