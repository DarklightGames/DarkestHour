//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_PantherGTank_SnowOne extends DH_PantherGTank; // snow topped version of ArdennesOne

defaultproperties
{
    Skins(0)=Texture'DH_VehiclesGE_tex3.PantherG_body_snow1'
    Skins(1)=Texture'axis_vehicles_tex.PantherG_treadsnow'
    Skins(2)=Texture'axis_vehicles_tex.PantherG_treadsnow'
    CannonSkins(0)=Texture'DH_VehiclesGE_tex3.PantherG_body_snow1'
    bDoRandomAttachments=false // TODO: we don't have a schurzen skin for this camo variant, so add here if one gets made // TODO: we don't have a schurzen skin for this camo variant, so add here if one gets made
    DestroyedVehicleMesh=StaticMesh'DH_German_vehicles_stc.PantherG_Destroyed4'
}
