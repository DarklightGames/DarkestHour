//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_ZiS3Gun extends DHATGun;

defaultproperties
{
    VehicleNameString="ZiS-3 76mm divisional gun"
    VehicleTeam=1
    PassengerWeapons(0)=(WeaponPawnClass=class'DH_Guns.DH_ZiS3CannonPawn',WeaponBone="Gun_attachment")
    Mesh=SkeletalMesh'DH_ZiS3_76mm_anm.ZiS3_base'
    Skins(0)=Texture'DH_Artillery_tex.ZiS3.ZiS3Gun'
    DestroyedVehicleMesh=StaticMesh'DH_Artillery_stc.ZiS3.ZiS3_destroyed'
    VehicleHudImage=Texture'DH_Artillery_Tex.ATGun_Hud.ZiS3_body'
    VehicleHudTurret=TexRotator'DH_Artillery_Tex.ATGun_Hud.ZiS3_turret_rot'
    VehicleHudTurretLook=TexRotator'DH_Artillery_Tex.ATGun_Hud.ZiS3_turret_look'
    VehicleHudOccupantsX(1)=0.44
    VehicleHudOccupantsY(1)=0.65
    ExitPositions(1)=(X=-120.00,Y=-38.00,Z=30.00)
    VehicleMass=11.0
    SupplyCost=1050
    ConstructionPlacementOffset=(Z=16)
    bCanBeRotated=true
    PlayersNeededToRotate=1
    MapIconAttachmentClass=class'DH_Engine.DHMapIconAttachment_ATGun_Rotating'

    Begin Object Class=KarmaParamsRBFull Name=KParams0
        KInertiaTensor(0)=1.0
        KInertiaTensor(3)=3.0
        KInertiaTensor(5)=3.0
        KCOMOffset=(X=-1.0,Y=0.0,Z=-0.45) // default is zero
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
    KParams=KarmaParamsRBFull'DH_Guns.DH_ZiS3Gun.KParams0'
}
