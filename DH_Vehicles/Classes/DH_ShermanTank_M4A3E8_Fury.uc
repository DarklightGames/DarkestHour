//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_ShermanTank_M4A3E8_Fury extends DH_ShermanTank_M4A3E8;

defaultproperties
{
    VehicleNameString="Sherman M4A3E8 'Fury'"
    PassengerWeapons(0)=(WeaponPawnClass=Class'DH_ShermanCannonPawn_M4A3E8_Fury')
    VehicleAttachments(0)=(AttachClass=Class'DHDecoAttachment',AttachBone="body",StaticMesh=StaticMesh'DH_ShermanM4A3E8_stc.body_stowage',bHasCollision=false)

    DestroyedVehicleMesh=StaticMesh'DH_ShermanM4A3E8_stc.fury_destroyed'

    VehicleHudImage=Texture'DH_ShermanM4A3E8_tex.body_fury'
    VehicleHudTurret=TexRotator'DH_ShermanM4A3E8_tex.turret_fury_look'
    VehicleHudTurretLook=TexRotator'DH_ShermanM4A3E8_tex.turret_fury_rot'
    SpawnOverlay(0)=Texture'DH_ShermanM4A3E8_tex.sherman_m4a3e8_fury'
}

