//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_PantherGTank_SnowTwo extends DH_PantherGTank; // snow topped version of ArdennesTwo

defaultproperties
{
    Skins(0)=Texture'DH_VehiclesGE_tex3.ext_vehicles.PantherG_body_snow2'
    Skins(1)=Texture'axis_vehicles_tex.Treads.PantherG_treadsnow'
    Skins(2)=Texture'axis_vehicles_tex.Treads.PantherG_treadsnow'
    CannonSkins(0)=Texture'DH_VehiclesGE_tex3.ext_vehicles.PantherG_body_snow2'
    bDoRandomAttachments=false // TODO: we don't have a schurzen skin for this camo variant, so add here if one gets made
    DestroyedVehicleMesh=StaticMesh'DH_German_vehicles_stc.PantherG.PantherG_Destroyed6'
}
