//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_M116Gun extends DHATGun;

defaultproperties
{
    VehicleNameString="75mm Pack Howitzer M1"   // Redesignated to M116 in 1962
    VehicleTeam=1
    PassengerWeapons(0)=(WeaponPawnClass=class'DH_Guns.DH_M116CannonPawn',WeaponBone="turret_placement")
    Mesh=SkeletalMesh'DH_M116_anm.m116_body'
    Skins(0)=Texture'DH_M116_tex.M116.M116_body'
    DestroyedVehicleMesh=StaticMesh'DH_M116_stc.destroyed.m116_destroyed'
    DestroyedMeshSkins(0)=Material'DH_M116_tex.destroyed.M116_body_destroyed_fb'
    VehicleHudImage=Texture'DH_M116_tex.Interface.M116_body_hud'
    VehicleHudTurret=TexRotator'DH_M116_tex.Interface.M116_turret_rot'
    VehicleHudTurretLook=TexRotator'DH_M116_tex.Interface.M116_turret_look'
    ExitPositions(1)=(X=-78.00,Y=-50.00,Z=48.00)
    ExitPositions(2)=(X=-78.00,Y=50.00,Z=48.00)
    VehicleMass=11.0
    bCanBeRotated=true
    MapIconAttachmentClass=class'DH_Engine.DHMapIconAttachment_ATGun_Rotating' // TODO: howitzer icon would be good
    ShadowZOffset=10.0
    RotateCooldown=2
    ConstructionBaseMesh=Mesh'DH_M116_anm.m116_base'
    SupplyCost=1500
    bIsArtilleryVehicle=true

    Begin Object Class=KarmaParamsRBFull Name=KParams0
        KInertiaTensor(0)=1.0
        KInertiaTensor(3)=3.0
        KInertiaTensor(5)=3.0
        KCOMOffset=(Z=-1.0)
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
    KParams=KarmaParamsRBFull'DH_Guns.DH_M116Gun.KParams0'
}

