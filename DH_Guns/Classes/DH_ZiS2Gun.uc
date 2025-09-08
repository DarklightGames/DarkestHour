//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_ZiS2Gun extends DHATGun;

defaultproperties
{
    VehicleNameString="ZiS-2 57mm"
    VehicleTeam=1
    PassengerWeapons(0)=(WeaponPawnClass=Class'DH_ZiS2CannonPawn',WeaponBone="turret_placement")
    Mesh=SkeletalMesh'DH_ZiS_anm.ZIS_BODY_EXT'
    Skins(0)=Texture'DH_ZiS_tex.ZIS_BODY_EXT'
    DestroyedVehicleMesh=StaticMesh'DH_ZiS_stc.ZIS2_DESTROYED'
    DestroyedMeshSkins(0)=Combiner'DH_ZiS_tex.ZIS_BODY_EXT_DESTROYED'
    DestroyedMeshSkins(1)=Combiner'DH_ZiS_tex.ZIS_TURRET_EXT_DESTROYED'
    VehicleHudImage=Texture'DH_ZiS_tex.ZIS_BODY_ICON'
    VehicleHudTurret=TexRotator'DH_ZiS_tex.ZIS2_TURRET_ICON_ROT'
    VehicleHudTurretLook=TexRotator'DH_ZiS_tex.ZIS2_TURRET_ICON_LOOK'
    ExitPositions(1)=(X=-100.00,Y=-30.00,Z=30.00)
    VehicleMass=11.0
    bCanBeRotated=true
    PlayersNeededToRotate=1
    MapIconMaterial=Texture'DH_InterfaceArt2_tex.at_topdown'

    ShadowZOffset=40.0

    Begin Object Class=KarmaParamsRBFull Name=KParams0
        KInertiaTensor(0)=1.0
        KInertiaTensor(3)=3.0
        KInertiaTensor(5)=3.0
        KCOMOffset=(X=0,Y=0,Z=0.25)
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
