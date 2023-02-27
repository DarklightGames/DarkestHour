//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_PantherGTank_CamoOne extends DH_PantherGTank;

defaultproperties
{
    Skins(0)=Texture'DH_VehiclesGE_tex.ext_vehicles.PantherG_body_camo1'
    CannonSkins(0)=Texture'DH_VehiclesGE_tex.ext_vehicles.PantherG_body_camo1'
    RandomAttachment=(Skins=(Texture'DH_VehiclesGE_tex.ext_vehicles.PantherG_armor_camo1'))
    DestroyedVehicleMesh=StaticMesh'DH_German_vehicles_stc.PantherG.PantherG_Destroyed'
}
