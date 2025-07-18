//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

// Original model by William "Teufelhund" Miller of the AHZ Red Orchestra mod team (heavily adapted here)

class DH_45mmM1937Gun extends DHATGun;

defaultproperties
{
    VehicleNameString="45mm 53-K (1937) AT gun"
    VehicleTeam=1
    PassengerWeapons(0)=(WeaponPawnClass=Class'DH_45mmM1937GunCannonPawn',WeaponBone="Turret_placement")
    Mesh=SkeletalMesh'DH_45mm_anm.45mmM1937_base'
    Skins(0)=Texture'DH_Artillery_tex.45mmATGun'
    DestroyedVehicleMesh=StaticMesh'DH_Artillery_stc.45mmGunM1937_destroyed'
    VehicleHudImage=Texture'DH_Artillery_Tex.45mmATGun_body'
    VehicleHudTurret=TexRotator'DH_Artillery_Tex.45mmATGun_turret_rot'
    VehicleHudTurretLook=TexRotator'DH_Artillery_Tex.45mmATGun_turret_look'
    VehicleHudOccupantsX(1)=0.44
    VehicleHudOccupantsY(1)=0.62
    ExitPositions(1)=(X=-88.0,Y=-8.0,Z=25.0)
    VehicleMass=8.0
    bCanBeRotated=true
    MapIconMaterial=Texture'DH_InterfaceArt2_tex.at_topdown'
}
