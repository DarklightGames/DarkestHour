//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_M1919A4_M1917_Gun extends DHMountedMachineGun;

defaultproperties
{
    BeginningIdleAnim="idle"
    VehicleNameString="M1919A4 Browning Machine Gun"
    Mesh=SkeletalMesh'DH_M1919A4_anm.TRIPOD_M1917_BODY'
    Skins(0)=Texture'DH_M1919A4_tex.M1919A4_TRIPODS'
    bCanBeRotated=true
    CollisionRadius=36.0
    CollisionHeight=36.0
    PassengerWeapons(0)=(WeaponPawnClass=Class'DH_M1919A4_M1917_MGPawn',WeaponBone="turret_placement")
    RotationsPerSecond=0.125
    MapIconMaterial=Texture'DH_InterfaceArt2_tex.mg_topdown'
    VehicleHudImage=Texture'DH_M1919A4_tex.HUD.M1919A4_M1917_BODY'
    VehicleHudTurret=TexRotator'DH_M1919A4_tex.HUD.M1919A4_M1917_TURRET_ROT'
    VehicleHudTurretLook=TexRotator'DH_M1919A4_tex.HUD.M1919A4_M1917_TURRET_LOOK'
    VehicleTeam=1    
    MountedWeaponClass=Class'DH_M1919A4_M1917_Weapon'
    DestroyedVehicleMesh=StaticMesh'DH_M1919A4_stc.M1919A4_M2_DESTROYED'
}
