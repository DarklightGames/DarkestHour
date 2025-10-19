//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================
// [ ] Add foliage adding mechanics.
//==============================================================================

class DH_Pak40ATGun extends DHATGun;

defaultproperties
{
    VehicleNameString="7,5cm Pak 40"
    PassengerWeapons(0)=(WeaponPawnClass=Class'DH_Guns.DH_Pak40CannonPawn',WeaponBone="Turret_placement")
    Mesh=SkeletalMesh'DH_Pak40_anm.Pak40_body_ext'
    Skins(0)=Texture'DH_Pak40_tex.Pak40.pak40_ext_gray'

    DestroyedVehicleMesh=StaticMesh'DH_Pak40_stc.pak40_destroyed'
    DestroyedMeshSkins(0)=Combiner'DH_Pak40_tex.pak40_ext_gray_destroyed'
    VehicleHudImage=Texture'DH_Pak40_tex.interface.Pak40_base'
    VehicleHudTurret=TexRotator'DH_Pak40_tex.interface.Pak40_turret_rot'
    VehicleHudTurretLook=TexRotator'DH_Pak40_tex.interface.Pak40_turret_look'

    ExitPositions(1)=(X=-120.00,Y=-27.00,Z=35.00)
    VehicleMass=11.0
    bCanBeRotated=true
    MapIconMaterial=Texture'DH_InterfaceArt2_tex.at_topdown'
    ShadowZOffset=40.0
    Begin Object Class=KarmaParamsRBFull Name=KParams0
        KInertiaTensor(0)=1.0
        KInertiaTensor(3)=3.0
        KInertiaTensor(5)=3.0
        KCOMOffset=(Z=-2.0)
        KLinearDamping=0.05
        KAngularDamping=0.05
        KStartEnabled=true
        bKNonSphericalInertia=true
        KMaxAngularSpeed=0.0
        bHighDetailOnly=false
        bClientOnly=false
        bKDoubleTickRate=true
        bDestroyOnWorldPenetrate=true
        bDoSafetime=true
        KFriction=50.0
        KImpactThreshold=700.0
    End Object
    KParams=KParams0
}
