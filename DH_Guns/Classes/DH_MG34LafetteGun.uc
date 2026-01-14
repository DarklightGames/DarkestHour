//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================
// REFERENCES
//==============================================================================
// https://www.german-smallarms.com/mg34top.html - MG34
// https://www.german-smallarms.com/lafette_top.html - MG34+Lafette
// https://www.german-smallarms.com/MGaccessory_p_top.html - MG34/42 ammo related equipment 
// https://www.german-smallarms.com/MGaccessorytop.html - MG accessories
//==============================================================================

class DH_MG34LafetteGun extends DHATGun;

defaultproperties
{
    VehicleTeam=AXIS_TEAM_INDEX
    VehicleNameString="Maschinengewehr 34 (Lafette)"
    Mesh=SkeletalMesh'DH_MG34_anm.LAFETTE_BODY_EXT'
    //Skins(0)=Texture'DH_Maxim_tex.MAXIM_BODY_EXT'
    BeginningIdleAnim="LAFETTE_BODY_HIGH"
    bCanBeRotated=true
    CollisionRadius=40.0
    CollisionHeight=16.0
    PassengerWeapons(0)=(WeaponPawnClass=Class'DH_MG34LafetteMGPawn',WeaponBone="TURRET_PLACEMENT")
    RotationsPerSecond=0.125
    MapIconMaterial=Texture'DH_InterfaceArt2_tex.mg_topdown'
    VehicleHudImage=Texture'DH_Maxim_tex.MAXIM_BODY_ICON'
    VehicleHudTurret=TexRotator'DH_Maxim_tex.MAXIM_TURRET_ROT'
    VehicleHudTurretLook=TexRotator'DH_Maxim_tex.MAXIM_TURRET_LOOK'
    MountedWeaponClass=Class'DH_MG34LafetteWeapon'

    ExitPositions(0)=(X=0,Y=0,Z=80)         // Failsafe exit position (ontop of the gun)
    ExitPositions(1)=(X=-80,Y=0,Z=30)       // Main exit position (behind the gun)
    ExitPositions(2)=(X=0,Y=-80.0,Z=30)     // Beside the gun
    ExitPositions(3)=(X=0,Y=+80.0,Z=30)     
    ExitPositions(4)=(X=-80,Y=-80.0,Z=30)
    ExitPositions(5)=(X=-80,Y=80.0,Z=30)

    // In order for the collision meshes to actually work, for some reason there needs to be karma shapes.
    // However, we don't actually want the gun to move, so we set the max speed and angular speed to 0.
    Begin Object Class=KarmaParamsRBFull Name=KParams0
        KMaxSpeed=0.0
        KMaxAngularSpeed=0.0
    End Object
    KParams=KParams0
}
