//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_Granatwerfer34Mortar extends DHMortar;

defaultproperties
{
    VehicleNameString="Granatwerfer 34"
    VehicleTeam=0
    Mesh=SkeletalMesh'DH_Granatwerfer34_anm.grw34_body_ext'
    Skins(0)=Texture'DH_Granatwerfer34_tex.grw34_ext_yellow'
    PassengerWeapons(0)=(WeaponPawnClass=class'DH_Guns.DH_Granatwerfer34CannonPawn',WeaponBone="TURRET_PLACEMENT")
    CollisionRadius=32.0
    CollisionHeight=8.0
    // Reversed because the gunner uses index 1.
    ExitPositions(0)=(X=-50.00,Y=35.0,Z=20)
    ExitPositions(1)=(X=-50.00,Y=-35.0,Z=20)

    bUsesCodedDestroyedSkins=true
    DestroyedVehicleMesh=StaticMesh'DH_Model35Mortar_stc.Destroyed.model35mortar_destroyed'

    VehicleHudImage=Texture'DH_Model35Mortar_tex.interface.model35mortar_body_icon'
    VehicleHudTurret=TexRotator'DH_Model35Mortar_tex.interface.model35mortar_tube_icon_rot'
    VehicleHudTurretLook=TexRotator'DH_Model35Mortar_tex.interface.model35mortar_tube_icon_look'

    DestructionEffectOffset=(Z=-60)
}
