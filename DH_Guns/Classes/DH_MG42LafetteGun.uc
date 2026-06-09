//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_MG42LafetteGun extends DHMountedMachineGun;

defaultproperties
{
    VehicleTeam=AXIS_TEAM_INDEX
    VehicleNameString="Maschinengewehr 42 (Lafette)"
    Mesh=SkeletalMesh'DH_MG34_anm.LAFETTE_BODY_EXT'
    Skins(0)=Texture'DH_MG34_tex.Lafette.LAFETTE_BODY_GRAY'
    BeginningIdleAnim="LAFETTE_BODY_HIGH"
    bCanBeRotated=true
    CollisionRadius=40.0
    CollisionHeight=16.0
    PassengerWeapons(0)=(WeaponPawnClass=Class'DH_MG42LafetteMGPawn',WeaponBone="TURRET_PLACEMENT")
    RotationsPerSecond=0.125
    MapIconMaterial=Texture'DH_InterfaceArt2_tex.mg_topdown'
    VehicleHudImage=Texture'DH_MG34_tex.LAFETTE_BODY_ICON'
    VehicleHudTurret=TexRotator'DH_MG42_tex.MG42_TURRET_ICON_ROT'
    VehicleHudTurretLook=TexRotator'DH_MG42_tex.MG42_TURRET_ICON_LOOK'
    MountedWeaponClass=Class'DH_MG42LafetteWeapon'
    UnmountedWeaponClass=Class'DH_MG42Weapon'

    ExitPositions(0)=(X=0,Y=0,Z=80)         // Failsafe exit position (ontop of the gun)
    ExitPositions(1)=(X=-80,Y=0,Z=30)       // Main exit position (behind the gun)
    ExitPositions(2)=(X=0,Y=-80.0,Z=30)     // Beside the gun
    ExitPositions(3)=(X=0,Y=+80.0,Z=30)     
    ExitPositions(4)=(X=-80,Y=-80.0,Z=30)
    ExitPositions(5)=(X=-80,Y=80.0,Z=30)
}
