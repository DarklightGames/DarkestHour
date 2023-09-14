//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_ShermanTank_M4A3E8_Fury extends DH_ShermanTank_M4A3E8;

defaultproperties
{
    VehicleNameString="Sherman M4A3E8 'Fury'"
    PassengerWeapons(0)=(WeaponPawnClass=class'DH_Vehicles.DH_ShermanCannonPawn_M4A3E8_Fury')
    VehicleAttachments(0)=(AttachClass=class'DHDecoAttachment',AttachBone="body",StaticMesh=StaticMesh'DH_ShermanM4A3E8_stc.body.body_stowage',bHasCollision=false)

    DestroyedVehicleMesh=StaticMesh'DH_ShermanM4A3E8_stc.Destroyed.fury_destroyed'

    VehicleHudImage=Texture'DH_ShermanM4A3E8_tex.Menu.body_fury'
    VehicleHudTurret=TexRotator'DH_ShermanM4A3E8_tex.Menu.turret_fury_look'
    VehicleHudTurretLook=TexRotator'DH_ShermanM4A3E8_tex.Menu.turret_fury_rot'
    SpawnOverlay(0)=Texture'DH_ShermanM4A3E8_tex.Menu.sherman_m4a3e8_fury'
}

