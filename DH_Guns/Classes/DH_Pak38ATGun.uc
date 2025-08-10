//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_Pak38ATGun extends DHATGun;

simulated event DestroyAppearance()
{
    local Combiner DestroyedSkin;

    DestroyedSkin = Combiner(Level.ObjectPool.AllocateObject(Class'Combiner'));
    DestroyedSkin.Material1 = Skins[0];
    DestroyedSkin.Material2 = Texture'DH_FX_Tex.DestroyedVehicleOverlay2';
    DestroyedSkin.FallbackMaterial = Skins[0];
    DestroyedSkin.CombineOperation = CO_Multiply;
    DestroyedMeshSkins[0] = DestroyedSkin;

    super.DestroyAppearance();
}

defaultproperties
{
    VehicleNameString="5.0 cm Pak38 AT gun"
    PassengerWeapons(0)=(WeaponPawnClass=Class'DH_Pak38CannonPawn',WeaponBone="Turret_placement")
    Mesh=SkeletalMesh'DH_Pak38_anm.Pak38_body'
    Skins(0)=Texture'DH_Artillery_Tex.Pak38'
    DestroyedVehicleMesh=StaticMesh'DH_Artillery_stc.pak38_dest'
    VehicleHudImage=Texture'DH_Artillery_Tex.Pak40_body'
    VehicleHudTurret=TexRotator'DH_Artillery_Tex.Pak40_turret_rot'
    VehicleHudTurretLook=TexRotator'DH_Artillery_Tex.Pak40_turret_look'
    VehicleHudOccupantsX(1)=0.47
    VehicleHudOccupantsY(1)=0.6
    ExitPositions(1)=(X=-84.00,Y=-27.00,Z=43.00)
    VehicleMass=11.0
    bCanBeRotated=true
    RotationGunWeight=1000
    MapIconMaterial=Texture'DH_InterfaceArt2_tex.at_topdown'

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
