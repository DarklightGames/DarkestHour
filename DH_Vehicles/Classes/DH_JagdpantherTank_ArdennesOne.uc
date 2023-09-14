//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_JagdpantherTank_ArdennesOne extends DH_JagdpantherTank;

defaultproperties
{
    Skins(0)=Texture'DH_VehiclesGE_tex3.ext_vehicles.jagdpanther_body_ardennes'
    CannonSkins(0)=Texture'DH_VehiclesGE_tex3.ext_vehicles.jagdpanther_body_ardennes'
    RandomAttachment=(Skins=(Texture'DH_VehiclesGE_tex3.ext_vehicles.Jagdpanther_armor_ardennes'))
    DestroyedMeshSkins(0)=none // remove inherited skin, as the inherited DestroyedVehicleMesh is correct for this camo variant & don't want it changed
}
