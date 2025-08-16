//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_Flakvierling38Gun extends DHATGun;

defaultproperties
{
    VehicleNameString="2,0cm Flakvierling 38"
    PassengerWeapons(0)=(WeaponPawnClass=Class'DH_Vehicles.DH_Flakvierling38CannonPawn',WeaponBone="Turret_placement")
    Mesh=SkeletalMesh'DH_Flak38_anm.flakvierling_base'
    Skins(0)=Texture'DH_Artillery_tex.FlakVeirling38'
    DestroyedVehicleMesh=StaticMesh'DH_Artillery_stc.Flakvierling38_dest'
    VehicleHudImage=Texture'DH_Artillery_tex.flakv38_base'
    VehicleHudTurret=TexRotator'DH_Artillery_tex.flakv38_turret_rot'
    VehicleHudTurretLook=TexRotator'DH_Artillery_tex.flakv38_turret_look'
    ExitPositions(1)=(X=-100.0,Y=40.0,Z=50.0)  // right of seat
    ExitPositions(2)=(X=-100.0,Y=-40.0,Z=50.0) // left
    MapIconMaterial=Texture'DH_InterfaceArt2_tex.aa_topdown'
}
