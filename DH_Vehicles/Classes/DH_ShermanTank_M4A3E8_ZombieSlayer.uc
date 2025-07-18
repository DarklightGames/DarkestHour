//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_ShermanTank_M4A3E8_ZombieSlayer extends DH_ShermanTank_M4A3E8_Fury;

defaultproperties
{
    VehicleNameString="Sherman M4A3E8 'Zombie Slayer'"
    PassengerWeapons(0)=(WeaponPawnClass=Class'DH_ShermanCannonPawn_M4A3E8_ZombieSlayer')
    VehicleAttachments(0)=(AttachClass=Class'DHDecoAttachment',AttachBone="body",StaticMesh=StaticMesh'DH_ShermanM4A3E8_ZombieSlayer_stc.body_stowage',bHasCollision=false)

    DestroyedVehicleMesh=StaticMesh'DH_ShermanM4A3E8_stc.m4a3e8_destroyed'

    Skins(0)=Texture'DHEventVehiclesTex.body_ext_ZombieSlayer'
    Skins(1)=Texture'DHEventVehiclesTex.wheels_ext'
    Skins(2)=Texture'DHEventVehiclesTex.tread_ZombieSlayer'
    Skins(3)=Texture'DHEventVehiclesTex.tread_ZombieSlayer'
}
