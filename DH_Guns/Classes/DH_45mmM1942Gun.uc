//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_45mmM1942Gun extends DHATGun;

defaultproperties
{
    VehicleNameString="45mm M-42 AT Gun"
    VehicleTeam=1
    PassengerWeapons(0)=(WeaponPawnClass=Class'DH_45mmM1942GunCannonPawn',WeaponBone="turret_placement")
    Mesh=SkeletalMesh'DH_Pak36_anm.45mm_body_ext'
    Skins(0)=Texture'DH_Pak36_tex.45mm_ext'
    DestroyedVehicleMesh=StaticMesh'DH_Pak36_stc.45mm_m42_destroyed'
    DestroyedMeshSkins(0)=Combiner'DH_Pak36_tex.45mm_ext_destroyed'
    VehicleHudImage=Texture'DH_Pak36_tex.45mm_body_icon'
    VehicleHudTurret=TexRotator'DH_Pak36_tex.m42_turret_icon_rot'
    VehicleHudTurretLook=TexRotator'DH_Pak36_tex.m42_turret_icon_look'
    ExitPositions(1)=(X=-88.0,Y=-8.0,Z=25.0)
    VehicleMass=8.0
    bCanBeRotated=true
    MapIconMaterial=Texture'DH_InterfaceArt2_tex.at_topdown'
}
