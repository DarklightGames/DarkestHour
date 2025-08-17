//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_AT57Gun extends DHATGun;

defaultproperties
{
    VehicleNameString="57mm M1 AT gun"
    VehicleTeam=1
    PassengerWeapons(0)=(WeaponPawnClass=Class'DH_AT57CannonPawn',WeaponBone="Turret_placement")
    Mesh=SkeletalMesh'DH_6PounderGun_anm.6pounder_body'
    Skins(0)=Texture'DH_Artillery_Tex.6pounder'
    DestroyedVehicleMesh=StaticMesh'DH_Artillery_stc.AT57mm_destroyed'
    VehicleHudImage=Texture'DH_Artillery_Tex.57mm_body'
    VehicleHudTurret=TexRotator'DH_Artillery_Tex.57mm_turret_rot'
    VehicleHudTurretLook=TexRotator'DH_Artillery_Tex.57mm_turret_look'
    VehicleHudOccupantsX(1)=0.47
    VehicleHudOccupantsY(1)=0.6
    ExitPositions(1)=(X=-100.0,Y=0.0,Z=0.0)
    VehicleMass=11.0
    bCanBeRotated=true
    MapIconMaterial=Texture'DH_InterfaceArt2_tex.at_topdown'

    Begin Object Class=KarmaParamsRBFull Name=KParams0
        KInertiaTensor(0)=1.0
        KInertiaTensor(3)=3.0
        KInertiaTensor(5)=3.0
        KCOMOffset=(Z=-1.0) // default is -0.5
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
