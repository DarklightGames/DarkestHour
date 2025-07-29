//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_Sdkfz251Transport_PolishSnow extends DH_Sdkfz251Transport;

defaultproperties
{
    VehicleTeam=1
    Skins(0)=Texture'DH_VehiclesPOL_tex.halftracksnow_ext_Polish'
    Skins(1)=Texture'axis_vehicles_tex.Halftrack_treadsnow'
    Skins(2)=Texture'axis_vehicles_tex.Halftrack_treadsnow'
    DestroyedVehicleMesh=StaticMesh'DH_German_vehicles_stc.Halftrack_Destoyed' // note SM spelling is incorrect
    bUsesCodedDestroyedSkins=true
}
