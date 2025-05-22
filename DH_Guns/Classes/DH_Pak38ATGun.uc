//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================
// [ ] Third-person player animations
// [ ] Cannon animations (camera transition, firing etc.)
// [ ] Destroyed mesh
// [ ] Variants
// [ ] Foliage attachments
// [ ] UI elements
// [ ] Finalize mesh
// [ ] Finalize textures
//==============================================================================

class DH_Pak38ATGun extends DHATGun;

defaultproperties
{
    VehicleNameString="5,0cm PaK 38"
    PassengerWeapons(0)=(WeaponPawnClass=class'DH_Guns.DH_Pak38CannonPawn',WeaponBone="Turret_placement")
    Mesh=SkeletalMesh'DH_Pak38_anm.pak38_body_ext'
    //Skins(0)=Texture'DH_Artillery_Tex.Pak38.Pak38'
    DestroyedVehicleMesh=StaticMesh'DH_Artillery_stc.Pak38.pak38_dest'
    VehicleHudImage=Texture'DH_Artillery_Tex.ATGun_Hud.Pak40_body'
    VehicleHudTurret=TexRotator'DH_Artillery_Tex.ATGun_Hud.Pak40_turret_rot'
    VehicleHudTurretLook=TexRotator'DH_Artillery_Tex.ATGun_Hud.Pak40_turret_look'
    VehicleHudOccupantsX(1)=0.47
    VehicleHudOccupantsY(1)=0.6
    ExitPositions(1)=(X=-84.00,Y=-27.00,Z=43.00)
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
    KParams=KarmaParamsRBFull'DH_Guns.DH_Pak38ATGun.KParams0'
}
