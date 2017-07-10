//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2017
//==============================================================================

class DH_JagdpantherTank_CamoTwo extends DH_JagdpantherTank;

defaultproperties
{
    Skins(0)=texture'DH_VehiclesGE_tex2.ext_vehicles.Jagdpanther_body_ambush'
    CannonSkins(0)=texture'DH_VehiclesGE_tex2.ext_vehicles.Jagdpanther_body_ambush'
    RandomAttachment=(Skin=none) // TODO: we don't have a schurzen skin for this camo variant, so add here if one gets made
    DestroyedVehicleMesh=StaticMesh'DH_German_vehicles_stc2.Jagdpanther.Jagdpanther_dest2'
    DestroyedMeshSkins(0)=none // remove inherited skin, as we have a specific DestroyedVehicleMesh for this camo variant & don't want it changed
}
