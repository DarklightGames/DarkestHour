//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_ShermanTank_DDay extends DH_ShermanTank;

defaultproperties
{
    VehicleNameString="M4A1(75) Sherman DD"
    PassengerWeapons(0)=(WeaponPawnClass=Class'DH_ShermanCannonPawn_DDay')
    VehicleAttachments(0)=(StaticMesh=StaticMesh'DH_allies_vehicles_stc.Dday_Sherman_DuctsAttachment',AttachBone="body",bHasCollision=true)
    DestroyedVehicleMesh=StaticMesh'DH_allies_vehicles_stc.DDay_Sherman_Dest'
    VehicleHudImage=Texture'DH_InterfaceArt_tex.shermandd_body'
    SpawnOverlay(0)=Material'DH_InterfaceArt_tex.sherman_dd'
}
