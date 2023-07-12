//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_KubelwagenFactory_WH extends DH_GermanVehicles;

defaultproperties
{
    VehicleClass=class'DH_Vehicles.DH_KubelwagenCar_WH'
    Mesh=SkeletalMesh'DH_Kubelwagen_anm.kubelwagen_body_ext'
    Skins(0)=FinalBlend'DH_VehiclesGE_tex.ext_vehicles.kubelwagen_glass_FB'
    Skins(1)=Texture'DH_VehiclesGE_tex.ext_vehicles.kubelwagen_body_grau'
}
