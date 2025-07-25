//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_PantherGTank_ArdennesOne extends DH_PantherGTank;

defaultproperties
{
    Skins(0)=Texture'DH_VehiclesGE_tex3.PantherG_body_ardennes1'
    CannonSkins(0)=Texture'DH_VehiclesGE_tex3.PantherG_body_ardennes1'
    bDoRandomAttachments=false // TODO: we don't have a schurzen skin for this camo variant, so add here if one gets made
    DestroyedVehicleMesh=StaticMesh'DH_German_vehicles_stc.PantherG_Destroyed4'
}
