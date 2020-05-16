//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2019
//==============================================================================

class DH_T_IVGEarlyTank extends DH_PanzerIVGEarlyTank;

defaultproperties
{
    // Vehicle properties
    VehicleNameString="T-IV mod.G"
    ReinforcementCost=4
	VehicleTeam=1

    // Hull mesh
    Mesh=SkeletalMesh'axis_Panzer4F2_anm.Panzer4F2_body_ext'
    Skins(0)=Texture'DH_VehiclesSOV_tex.ext_vehicles.sov_PanzerIV_ext'
	CannonSkins(0)=Texture'DH_VehiclesSOV_tex.ext_vehicles.sov_PanzerIV_ext'
   
   
   
    DestroyedMeshSkins(0)=Texture'axis_destroyed_vehicles_tex.Panzer4F2.Panzer4F2_Camo_Destroyed'
    //to do: captured destroyed skin?


}
