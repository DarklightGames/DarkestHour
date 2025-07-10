//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_Flak88Gun extends DHATGun;

defaultproperties
{
    VehicleNameString="8.8cm FlaK 36 gun"
    PassengerWeapons(0)=(WeaponPawnClass=Class'DH_Flak88CannonPawn',WeaponBone="Turret_placement")
    Mesh=SkeletalMesh'DH_Flak88_anm.flak88_base'
    Skins(0)=Texture'MilitaryAxisSMT.flak_88'
    DestroyedVehicleMesh=StaticMesh'MilitaryAxisSM.Flak88_destroyed'
    DestroyedMeshSkins(0)=Combiner'DH_Artillery_tex.flak_88_dest'
    VehicleHudImage=Texture'DH_Artillery_Tex.flak88_body'
    VehicleHudTurret=TexRotator'DH_Artillery_Tex.flak88_turret_rot'
    VehicleHudTurretLook=TexRotator'DH_Artillery_Tex.flak88_turret_look'
    ExitPositions(1)=(X=-50.0,Y=75.0,Z=50.0)
    VehicleMass=20.0
    MapIconMaterial=Texture'DH_InterfaceArt2_tex.at_static_topdown'

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
    KParams=KarmaParamsRBFull'DH_Guns.KParams0'
}
