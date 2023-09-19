//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================
// [x] Add collision meshes
// [ ] Version without wheels on
// [ ] Adjust COM
// [ ] Destroyed mesh
// [ ] Projectiles
// [ ] Gun calibration & sight
// [ ] Third person animations
// [ ] Replace texture
// [ ] Add as option for Italians to build re: construction
// [ ] UI elements (gun & shells)
// [ ] New audio??
// [ ] Fix weird misalignment between body & mount
// [ ] Add special vision bounding box on the base mesh so it doesn't disappear
//==============================================================================

class DH_Cannone4732Gun extends DHATGun;

defaultproperties
{
    VehicleNameString="Cannone 47/32"
    VehicleTeam=0
    PassengerWeapons(0)=(WeaponPawnClass=class'DH_Guns.DH_Cannone4732CannonPawn',WeaponBone="Turret_placement")
    Mesh=SkeletalMesh'DH_Cannone4732_anm.cannone4732_body'
    Skins(0)=Texture'DH_Cannone4732_tex.cannone4732_body_ext'
    //DestroyedVehicleMesh=StaticMesh'DH_Cannone4732_stc.57mmGun.AT57mm_destroyed'
    //VehicleHudImage=Texture'DH_Cannone4732_tex.Interface.cannone4732_body_icon'
    //VehicleHudTurret=TexRotator'DH_Cannone4732_tex.Interface.cannone4732_turret_rot'
    //VehicleHudTurretLook=TexRotator'DH_Cannone4732_tex.Interface.cannone4732_turret_look
    //VehicleHudOccupantsX(1)=0.5
    //VehicleHudOccupantsY(1)=0.4
    //ExitPositions(1)=(X=-100.0,Y=0.0,Z=0.0) ??
    VehicleMass=11.0
    SupplyCost=700
    ConstructionPlacementOffset=(Z=10.0)
    bCanBeRotated=true
    MapIconAttachmentClass=class'DH_Engine.DHMapIconAttachment_ATGun_Rotating'

    ShadowZOffset=10.0

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
    KParams=KarmaParamsRBFull'DH_Guns.DH_Cannone4732Gun.KParams0'
}
