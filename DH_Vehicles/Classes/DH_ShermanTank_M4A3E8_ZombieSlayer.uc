//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_ShermanTank_M4A3E8_ZombieSlayer extends DH_ShermanTank_M4A3E8_Fury;

defaultproperties
{
    VehicleNameString="Sherman M4A3E8 'Zombie Slayer'"
    PassengerWeapons(0)=(WeaponPawnClass=class'DH_Vehicles.DH_ShermanCannonPawn_M4A3E8_ZombieSlayer')
    VehicleAttachments(0)=(AttachClass=class'DHDecoAttachment',AttachBone="body",StaticMesh=StaticMesh'DH_ShermanM4A3E8_ZombieSlayer_stc.body.body_stowage',bHasCollision=false)

    DestroyedVehicleMesh=StaticMesh'DH_ShermanM4A3E8_stc.Destroyed.m4a3e8_destroyed'

    Skins(0)=Texture'DHEventVehiclesTex.ZombieSlayer.body_ext_ZombieSlayer'
    Skins(1)=Texture'DHEventVehiclesTex.ZombieSlayer.wheels_ext'
    Skins(2)=Texture'DHEventVehiclesTex.ZombieSlayer.tread_ZombieSlayer'
    Skins(3)=Texture'DHEventVehiclesTex.ZombieSlayer.tread_ZombieSlayer'
}
