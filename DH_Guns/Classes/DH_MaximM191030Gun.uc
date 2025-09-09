//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_MaximM191030Gun extends DHATGun;

defaultproperties
{
    VehicleTeam=ALLIES_TEAM_INDEX
    VehicleNameString="Maxim M1910/30"
    Mesh=SkeletalMesh'DH_Maxim_anm.MAXIM_BODY_EXT'
    bCanBeRotated=true
    CollisionRadius=20.0
    CollisionHeight=16.0
    PassengerWeapons(0)=(WeaponPawnClass=Class'DH_MaximM191030MGPawn',WeaponBone="TURRET_PLACEMENT")
    RotationsPerSecond=0.25
    MapIconMaterial=Texture'DH_InterfaceArt2_tex.mg_topdown'
    VehicleHudImage=Texture'DH_Fiat1435_tex.fiat1435_tripod_icon'                   // TODO: replace
    VehicleHudTurret=TexRotator'DH_Fiat1435_tex.fiat1435_turret_wc_icon_rot'        // TODO: replace
    VehicleHudTurretLook=TexRotator'DH_Fiat1435_tex.fiat1435_turret_wc_icon_look'   // TODO: replace
    StationaryWeaponClass=Class'DH_MaximM191030Weapon'
    ExitPositions(0)=(X=-64.0,Z=58)
    ExitPositions(1)=(X=-64.0,Z=58)
    ExitPositions(2)=(Y=-64.0,Z=58)
    ExitPositions(3)=(Y=64.0,Z=58)
    // In order for the collision meshes to actually work, for some reason there needs to be karma shapes.
    // However, we don't actually want the gun to move, so we set the max speed and angular speed to 0.
    Begin Object Class=KarmaParamsRBFull Name=KParams0
        KMaxSpeed=0.0
        KMaxAngularSpeed=0.0
    End Object
    KParams=KParams0
}
