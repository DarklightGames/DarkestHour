//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DH_ShermanTank_DDay extends DH_ShermanTank;

defaultproperties
{
    PassengerWeapons(0)=(WeaponPawnClass=class'DH_Vehicles.DH_ShermanCannonPawn_DDay')
    VehicleAttachments(0)=(StaticMesh=StaticMesh'DH_allies_vehicles_stc.Sherman.Dday_Sherman_DuctsAttachment',AttachBone="body",bHasCollision=true)
    DestroyedVehicleMesh=StaticMesh'DH_allies_vehicles_stc.Sherman.DDay_Sherman_Dest'
    VehicleHudImage=texture'DH_InterfaceArt_tex.Tank_Hud.shermandd_body'
    VehicleNameString="M4A1 Sherman DD"
    SpawnOverlay(0)=material'DH_InterfaceArt_tex.Vehicles.sherman_dd'
}
