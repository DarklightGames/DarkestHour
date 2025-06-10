//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_M1919A4Gun extends DHATGun
    //abstract
    ;

defaultproperties
{
    BeginningIdleAnim="idle"
    VehicleNameString="M1919A4 Browning Machine Gun"
    Mesh=SkeletalMesh'DH_M1919_anm.M1919A4_M2_BODY_EXT'
    bCanBeRotated=true
    CollisionRadius=36.0
    CollisionHeight=36.0
    PassengerWeapons(0)=(WeaponPawnClass=Class'DH_M1919A4MGPawn',WeaponBone="turret_placement")
    RotationsPerSecond=0.25
    MapIconMaterial=Texture'DH_InterfaceArt2_tex.mg_topdown'
    VehicleHudImage=Texture'DH_Fiat1435_tex.interface.fiat1435_tripod_icon'
    VehicleHudTurret=TexRotator'DH_Fiat1435_tex.interface.fiat1435_turret_wc_icon_rot'
    VehicleHudTurretLook=TexRotator'DH_Fiat1435_tex.interface.fiat1435_turret_wc_icon_look'
    VehicleTeam=1
    // In order for the collision meshes to actually work, for some reason there needs to be karma shapes.
    // However, we don't actually want the gun to move, so we set the max speed and angular speed to 0.
    Begin Object Class=KarmaParamsRBFull Name=KParams0
        KMaxSpeed=0.0
        KMaxAngularSpeed=0.0
    End Object
    KParams=KParams0
}
