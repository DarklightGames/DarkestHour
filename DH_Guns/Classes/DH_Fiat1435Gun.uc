//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_Fiat1435Gun extends DHATGun
    abstract;

defaultproperties
{
    VehicleNameString="Fiat-Revelli modello 14/35"
    Mesh=SkeletalMesh'DH_Fiat1435_anm.FIAT1435_TRIPOD_3RD'
    bCanBeRotated=true
    RotationBaseYaw=40
    CollisionRadius=36.0
    CollisionHeight=36.0
    PassengerWeapons(0)=(WeaponPawnClass=Class'DH_Fiat1435MGPawn',WeaponBone=turret_placement)
    RotationsPerSecond=0.25
    MapIconMaterial=Texture'DH_InterfaceArt2_tex.mg_topdown'
    VehicleHudImage=Texture'DH_Fiat1435_tex.fiat1435_tripod_icon'
    VehicleHudTurret=TexRotator'DH_Fiat1435_tex.fiat1435_turret_wc_icon_rot'
    VehicleHudTurretLook=TexRotator'DH_Fiat1435_tex.fiat1435_turret_wc_icon_look'
    // In order for the collision meshes to actually work, for some reason there needs to be karma shapes.
    // However, we don't actually want the gun to move, so we set the max speed and angular speed to 0.
    Begin Object Class=KarmaParamsRBFull Name=KParams0
        KMaxSpeed=0.0
        KMaxAngularSpeed=0.0
    End Object
    KParams=KParams0
}
