//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DH_StuartFactory_British extends DH_BritishVehicles;

defaultproperties
{
    VehicleClass=class'DH_Vehicles.DH_StuartTank_British'
    Mesh=SkeletalMesh'DH_Stuart_anm.Stuart_body_extB'
    Skins(0)=texture'DH_VehiclesUK_tex.ext_vehicles.Brit_M5_body_ext'
    Skins(1)=texture'DH_VehiclesUK_tex.ext_vehicles.Brit_M5_armor'
    Skins(4)=texture'DH_VehiclesUS_tex.int_vehicles.M5_body_int'
}
