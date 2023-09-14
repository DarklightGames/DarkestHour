//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_AT57Gun extends DHATGun;

defaultproperties
{
    VehicleNameString="57mm M1 AT gun"
    VehicleTeam=1
    PassengerWeapons(0)=(WeaponPawnClass=class'DH_Guns.DH_AT57CannonPawn',WeaponBone="Turret_placement")
    Mesh=SkeletalMesh'DH_6PounderGun_anm.6pounder_body'
    Skins(0)=Texture'DH_Artillery_Tex.6pounder.6pounder'
    DestroyedVehicleMesh=StaticMesh'DH_Artillery_stc.57mmGun.AT57mm_destroyed'
    VehicleHudImage=Texture'DH_Artillery_Tex.ATGun_Hud.57mm_body'
    VehicleHudTurret=TexRotator'DH_Artillery_Tex.ATGun_Hud.57mm_turret_rot'
    VehicleHudTurretLook=TexRotator'DH_Artillery_Tex.ATGun_Hud.57mm_turret_look'
    VehicleHudOccupantsX(1)=0.47
    VehicleHudOccupantsY(1)=0.6
    ExitPositions(1)=(X=-100.0,Y=0.0,Z=0.0)
    VehicleMass=11.0
    SupplyCost=1050
    ConstructionPlacementOffset=(Z=10.0)
    bCanBeRotated=true
    MapIconAttachmentClass=class'DH_Engine.DHMapIconAttachment_ATGun_Rotating'

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
    KParams=KarmaParamsRBFull'DH_Guns.DH_AT57Gun.KParams0'
}
