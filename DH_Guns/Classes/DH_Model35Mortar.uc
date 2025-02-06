//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_Model35Mortar extends DHATGun;

defaultproperties
{
    VehicleNameString="Mortaio da 81/14 modello 35"
    VehicleTeam=0
    Mesh=SkeletalMesh'DH_Model35Mortar_anm.model35mortar_base'
    Skins(0)=Texture'DH_Model35Mortar_tex.Model35.Model35Mortar_ext'
    PassengerWeapons(0)=(WeaponPawnClass=class'DH_Guns.DH_Model35MortarCannonPawn',WeaponBone="TURRET_PLACEMENT")
    bCanBeRotated=true
    bIsArtilleryVehicle=true
    bTeamLocked=false
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

    MapIconMaterial=Texture'DH_InterfaceArt2_tex.mortar_topdown'

    DestructionEffectOffset=(Z=-60)
}
