//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_ShermanTank_DDay extends DH_ShermanTank;

defaultproperties
{
    VehicleNameString="M4A1(75) Sherman DD"
    PassengerWeapons(0)=(WeaponPawnClass=class'DH_Vehicles.DH_ShermanCannonPawn_DDay')
    VehicleAttachments(0)=(StaticMesh=StaticMesh'DH_allies_vehicles_stc.Sherman.Dday_Sherman_DuctsAttachment',AttachBone="body",bHasCollision=true)
    DestroyedVehicleMesh=StaticMesh'DH_allies_vehicles_stc.Sherman.DDay_Sherman_Dest'
    VehicleHudImage=Texture'DH_InterfaceArt_tex.Tank_Hud.shermandd_body'
    SpawnOverlay(0)=Material'DH_InterfaceArt_tex.Vehicles.sherman_dd'
}
