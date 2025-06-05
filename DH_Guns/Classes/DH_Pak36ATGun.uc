//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================
// [ ] Finalize ammo loadout
// [ ] Fix visual bug where shell is attached at the beginning by default (and
//     check that it works in MP)
//==============================================================================

class DH_Pak36ATGun extends DHATGun;

defaultproperties
{
    VehicleNameString="3,7cm PaK 36"
    PassengerWeapons(0)=(WeaponPawnClass=class'DH_Guns.DH_Pak36CannonPawn',WeaponBone="Turret_placement")
    Mesh=SkeletalMesh'DH_Pak36_anm.pak36_body_ext'
    Skins(0)=Texture'DH_Pak36_tex.pak36_ext_gray'
    CannonSkins(0)=Texture'DH_Pak36_tex.pak36_ext_gray'
    DestroyedVehicleMesh=StaticMesh'DH_Pak36_stc.pak36_destroyed'
    DestroyedMeshSkins(0)=Material'DH_Pak36_tex.pak36_ext_gray_destroyed'
    VehicleHudImage=Texture'DH_Pak36_tex.pak36_body_icon'
    VehicleHudTurret=TexRotator'DH_Pak36_tex.pak36_turret_icon_rot'
    VehicleHudTurretLook=TexRotator'DH_Pak36_tex.pak36_turret_icon_look'
    ExitPositions(1)=(X=-78,Y=-19,Z=58)
    VehicleMass=11.0
    bCanBeRotated=true
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
    KParams=KParams0
}
