//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================
// [ ] Projectiles
// [ ] Gun calibration
// [ ] Gun reticle
// [ ] Third person animations
// [ ] UI elements for shells
// [ ] New audio??
// [ ] Add special vision bounding box on the base mesh so it doesn't disappear (not sure if this is a problem)
//==============================================================================

class DH_Cannone4732Gun extends DHATGun;

defaultproperties
{
    VehicleNameString="Cannone da 47/32"
    VehicleTeam=0
    PassengerWeapons(0)=(WeaponPawnClass=class'DH_Guns.DH_Cannone4732CannonPawn',WeaponBone="Turret_placement")
    Mesh=SkeletalMesh'DH_Cannone4732_anm.cannone4732_body'
    Skins(0)=Texture'DH_Cannone4732_tex.cannone4732_body_ext'
    DestroyedVehicleMesh=StaticMesh'DH_Cannone4732_stc.Destroyed.cannone4732_destroyed'
    VehicleHudImage=Texture'DH_Cannone4732_tex.Interface.cannone4732_body_icon'
    VehicleHudTurret=TexRotator'DH_Cannone4732_tex.Interface.cannone4732_turret_rot'
    //VehicleHudTurretLook=TexRotator'DH_Cannone4732_tex.Interface.cannone4732_turret_look'
    ExitPositions(0)=(X=-100,Y=+35.00,Z=50)
    ExitPositions(1)=(X=-100,Y=-35.00,Z=50)
    ExitPositions(2)=(X=-200,Y=0,Z=50)
    VehicleMass=3.0
    ConstructionPlacementOffset=(Z=0.0)
    bCanBeRotated=true
    MapIconAttachmentClass=class'DH_Engine.DHMapIconAttachment_Vehicle'
    MapIconMaterial=Texture'DH_InterfaceArt2_tex.at_topdown'
    ShadowZOffset=10.0
    Begin Object Class=KarmaParamsRBFull Name=KParams0
        KInertiaTensor(0)=1.0
        KInertiaTensor(3)=3.0
        KInertiaTensor(5)=3.0
        KCOMOffset=(X=0,Y=0,Z=0) // default is -0.5
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
