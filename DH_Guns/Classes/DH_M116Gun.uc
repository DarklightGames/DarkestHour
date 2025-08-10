//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_M116Gun extends DHATGun;

defaultproperties
{
    VehicleNameString="75mm Pack Howitzer M1"   // Redesignated to M116 in 1962
    VehicleTeam=1
    PassengerWeapons(0)=(WeaponPawnClass=Class'DH_M116CannonPawn',WeaponBone="turret_placement")
    Mesh=SkeletalMesh'DH_M116_anm.m116_body'
    Skins(0)=Texture'DH_M116_tex.M116_body'
    DestroyedVehicleMesh=StaticMesh'DH_M116_stc.m116_destroyed'
    DestroyedMeshSkins(0)=Material'DH_M116_tex.M116_body_destroyed_fb'
    VehicleHudImage=Texture'DH_M116_tex.M116_body_hud'
    VehicleHudTurret=TexRotator'DH_M116_tex.M116_turret_rot'
    VehicleHudTurretLook=TexRotator'DH_M116_tex.M116_turret_look'
    ExitPositions(1)=(X=-78.00,Y=-50.00,Z=48.00)
    ExitPositions(2)=(X=-78.00,Y=50.00,Z=48.00)
    VehicleMass=11.0
    bCanBeRotated=true
    RotationGunWeight=653
    MapIconMaterial=Texture'DH_InterfaceArt2_tex.artillery_topdown'
    ShadowZOffset=10.0
    RotateCooldown=2
    ConstructionBaseMesh=Mesh'DH_M116_anm.m116_base'
    bIsArtilleryVehicle=true

    Begin Object Class=KarmaParamsRBFull Name=KParams0
        KInertiaTensor(0)=1.0
        KInertiaTensor(3)=3.0
        KInertiaTensor(5)=3.0
        KCOMOffset=(Z=-1.0)
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

