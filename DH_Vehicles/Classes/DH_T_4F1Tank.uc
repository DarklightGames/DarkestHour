//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2019
//==============================================================================

class DH_T_IVF1Tank extends DH_PanzerIVF1Tank;

defaultproperties
{
    // Vehicle properties
    VehicleNameString="T-IV mod.F"
    ReinforcementCost=4
    VehicleTeam=1

    // Hull mesh
    Mesh=SkeletalMesh'DH_PanzerIV_anm.Panzer4Glate_body_ext'
    Skins(0)=Texture'DH_VehiclesSOV_tex.ext_vehicles.sov_PanzerIV_ext'
	CannonSkins(0)=Texture'DH_VehiclesSOV_tex.ext_vehicles.sov_PanzerIV_ext'
 
 
    DestroyedMeshSkins(0)=combiner'DH_VehiclesGE_tex.Destroyed.PanzerIV_body_dest'
    //to do: captured destroyed skin? 

  
}
