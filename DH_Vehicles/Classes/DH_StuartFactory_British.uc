//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_StuartFactory_British extends DH_BritishVehicles;

defaultproperties
{
    VehicleClass=class'DH_Vehicles.DH_StuartTank_British'
    Mesh=SkeletalMesh'DH_Stuart_anm.Stuart_body_extB'
    Skins(0)=Texture'DH_VehiclesUK_tex.ext_vehicles.Brit_M5_body_ext'
    Skins(4)=Texture'DH_VehiclesUK_tex.ext_vehicles.Brit_M5_armor'
}
