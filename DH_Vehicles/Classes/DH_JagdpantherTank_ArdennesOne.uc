//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_JagdpantherTank_ArdennesOne extends DH_JagdpantherTank;

defaultproperties
{
    Skins(0)=Texture'DH_VehiclesGE_tex3.jagdpanther_body_ardennes'
    CannonSkins(0)=Texture'DH_VehiclesGE_tex3.jagdpanther_body_ardennes'
    bDoRandomAttachments=false // no schurzen for this camo variant
    DestroyedMeshSkins(0)=none // remove inherited skin, as the inherited DestroyedVehicleMesh is correct for this camo variant & don't want it changed
}
