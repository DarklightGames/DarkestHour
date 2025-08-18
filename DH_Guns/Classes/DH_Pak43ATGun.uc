//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_Pak43ATGun extends DHATGun;

defaultproperties
{
    VehicleNameString="8,8-cm PaK 43"
    PassengerWeapons(0)=(WeaponPawnClass=Class'DH_Guns.DH_Pak43CannonPawn',WeaponBone="Turret_placement")
    Mesh=SkeletalMesh'DH_Pak43_anm.pak43_body_ext'
    Skins(0)=Texture'DH_Pak43_tex.pak43_ext_yellow'
    CannonSkins(0)=Texture'DH_Pak43_tex.pak43_ext_yellow'
    DestroyedMeshSkins(0)=Combiner'DH_Pak43_tex.pak43_ext_yellow_destroyed'
    DestroyedVehicleMesh=StaticMesh'DH_Pak43_stc.pak43_destroyed'
    VehicleHudImage=Texture'DH_Pak43_tex.pak43_body_icon'
    VehicleHudTurret=TexRotator'DH_Pak43_tex.pak43_turret_icon_rot'
    VehicleHudTurretLook=TexRotator'DH_Pak43_tex.pak43_turret_icon_look'
    ExitPositions(1)=(X=-105.00,Y=-37.00,Z=28.00)
    VehicleMass=11.0
    bCanBeRotated=true
    PlayersNeededToRotate=2
    RotationsPerSecond=0.05
    MapIconMaterial=Texture'DH_InterfaceArt2_tex.at_topdown'
    ShadowZOffset=40.0
    Begin Object Class=KarmaParamsRBFull Name=KParams0
        KInertiaTensor(0)=1.0
        KInertiaTensor(3)=3.0
        KInertiaTensor(5)=3.0
        KCOMOffset=(Z=-0.9)
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
