//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_Sdkfz251Transport_SnowOne extends DH_Sdkfz251Transport; // snow topped version of CamoOne

defaultproperties
{
    bIsWinterVariant=true
    Skins(0)=Texture'DH_VehiclesGE_tex3.ext_vehicles.Halftrack_body_snow1'
    Skins(1)=Texture'axis_vehicles_tex.Treads.Halftrack_treadsnow'
    Skins(2)=Texture'axis_vehicles_tex.Treads.Halftrack_treadsnow'
    DestroyedVehicleMesh=StaticMesh'DH_German_vehicles_stc.Halftrack.Halftrack_Destoyed'
}
