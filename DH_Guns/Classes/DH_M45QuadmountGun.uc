//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_M45QuadmountGun extends DHATGun;

defaultproperties
{
    VehicleNameString="M45 Quadmount"
    VehicleTeam=1
    PassengerWeapons(0)=(WeaponPawnClass=Class'DH_M45QuadmountMGPawn',WeaponBone="turret_placement")
    Mesh=SkeletalMesh'DH_M45_anm.m45_base_trailer'
    Skins(0)=Texture'DH_Artillery_tex.m45_trailer'
    Skins(1)=Shader'DH_Artillery_Tex.m45_sight_s'
    DestroyedVehicleMesh=StaticMesh'DH_Artillery_stc.m45_dest'
    VehicleHudImage=Texture'DH_Artillery_tex.m45_body'
    VehicleHudTurret=TexRotator'DH_Artillery_tex.m45_turret_rot'
    VehicleHudTurretLook=TexRotator'DH_Artillery_tex.m45_turret_look'
    ExitPositions(1)=(X=-100.0,Y=40.0,Z=50.0)  // right of seat
    ExitPositions(2)=(X=-100.0,Y=-40.0,Z=50.0) // left
    MapIconMaterial=Texture'DH_InterfaceArt2_tex.aa_topdown'
}
