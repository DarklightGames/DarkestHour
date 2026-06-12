//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_VickersGun extends DHMountedMachineGun;

defaultproperties
{
    VehicleNameString="Vickers Gun"
    MountedWeaponClass=Class'DH_VickersWeapon'
    Mesh=SkeletalMesh'DH_Fiat1435_anm.FIAT1435_TRIPOD_3RD'
    Skins(0)=Texture'DH_Fiat1435_tex.FIAT1435_3RD'
    CannonSkins(0)=Texture'DH_Fiat1435_tex.FIAT1435_3RD'
    bCanBeRotated=true
    CollisionRadius=36.0
    CollisionHeight=36.0
    PassengerWeapons(0)=(WeaponPawnClass=Class'DH_VickersMGPawn',WeaponBone="turret_placement")
    RotationsPerSecond=0.125
    MapIconMaterial=Texture'DH_InterfaceArt2_tex.mg_topdown'
    VehicleHudImage=Texture'DH_Fiat1435_tex.fiat1435_tripod_icon'
    VehicleHudTurret=TexRotator'DH_Fiat1435_tex.fiat35_turret_icon_rot'
    VehicleHudTurretLook=TexRotator'DH_Fiat1435_tex.fiat35_turret_icon_look'
    DestroyedVehicleMesh=StaticMesh'DH_Fiat1435_stc.FIAT35_DESTROYED'
    VehicleTeam=1
}
