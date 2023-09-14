//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_Sdkfz251Transport_Polish extends DH_Sdkfz251Transport;

defaultproperties
{
    VehicleTeam=1
    Skins(0)=Texture'DH_VehiclesPOL_tex.ext_vehicles.halftrack_polish'
    DestroyedVehicleMesh=StaticMesh'DH_German_vehicles_stc.Halftrack.Halftrack_Destoyed' // note SM spelling is incorrect
    bUsesCodedDestroyedSkins=true
}
