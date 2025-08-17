//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_M1927Gun extends DHATGun;

defaultproperties
{
    VehicleNameString="76 mm regimental gun M1927"
    VehicleTeam=1
    PassengerWeapons(0)=(WeaponPawnClass=Class'DH_M1927CannonPawn',WeaponBone="body")
    Mesh=SkeletalMesh'DH_M1927_anm.m1927_body'
    Skins(0)=Texture'DH_M1927_tex.m1927_body'
    DestroyedVehicleMesh=StaticMesh'DH_M1927_stc.m1927_destroyed'
    DestroyedMeshSkins(0)=Material'DH_M1927_tex.m1927_body_destroyed'
    VehicleHudImage=Texture'DH_M1927_tex.m1927_body_hud'
    VehicleHudTurret=TexRotator'DH_M1927_tex.m1927_turret_rot'
    VehicleHudTurretLook=TexRotator'DH_M1927_tex.m1927_turret_look'
    ExitPositions(1)=(X=-75.00,Y=-35.00,Z=50.00)
    ExitPositions(2)=(X=-75.00,Y=35.00,Z=50.00)
    VehicleMass=11.0
    bCanBeRotated=true
    RotationBaseYaw=780
    MapIconMaterial=Texture'DH_InterfaceArt2_tex.artillery_topdown'
    ShadowZOffset=20.0
    bIsArtilleryVehicle=true
    RotateCooldown=2

    Begin Object Class=KarmaParamsRBFull Name=KParams0
        KInertiaTensor(0)=1.0
        KInertiaTensor(3)=3.0
        KInertiaTensor(5)=3.0
        KCOMOffset=(Z=-10)
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
    KParams=KarmaParamsRBFull'DH_Guns.KParams0'
}
