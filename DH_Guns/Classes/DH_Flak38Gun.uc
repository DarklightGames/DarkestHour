//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_Flak38Gun extends DHATGun;

defaultproperties
{
    VehicleNameString="2cm FlaK 38 gun"
    PassengerWeapons(0)=(WeaponPawnClass=Class'DH_Flak38CannonPawn',WeaponBone="turret_placement")
    Mesh=SkeletalMesh'DH_Flak38_anm.Flak38_base_static'
    Skins(0)=Texture'DH_Artillery_tex.Flak38_gun'
    DestroyedVehicleMesh=StaticMesh'DH_Artillery_stc.Flak38_static_dest'
    VehicleHudImage=Texture'DH_Artillery_tex.flak38_body_static'
    VehicleHudTurret=TexRotator'DH_Artillery_tex.flak38_turret_rot'
    VehicleHudTurretLook=TexRotator'DH_Artillery_tex.flak38_turret_look'
    ExitPositions(1)=(X=-30.0,Y=70.0,Z=50.0)
    MapIconMaterial=Texture'DH_InterfaceArt2_tex.at_static_topdown'

    Begin Object Class=KarmaParamsRBFull Name=KParams0
        KInertiaTensor(0)=1.0
        KInertiaTensor(3)=3.0
        KInertiaTensor(5)=3.0
        KCOMOffset=(Z=-10.0) // relatively, COM is high, gun is light & it's base is not so stable, so any karma impulse can make it rock - this lowers COM to approx ground level
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
