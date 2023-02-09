//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_17PounderGun extends DHATGun;

defaultproperties
{
    VehicleNameString="17 Pounder AT gun"
    VehicleTeam=1
    PassengerWeapons(0)=(WeaponPawnClass=class'DH_Guns.DH_17PounderGunCannonPawn',WeaponBone="Turret_placement1")
    Mesh=SkeletalMesh'DH_17PounderGun_anm.17Pounder_body'
    Skins(0)=Texture'DH_Artillery_Tex.17pounder.17Pounder'
    DestroyedVehicleMesh=StaticMesh'DH_Artillery_stc.17pounder.17Pounder_dest'
    VehicleHudImage=Texture'DH_Artillery_Tex.ATGun_Hud.pak43_body'
    VehicleHudTurret=TexRotator'DH_Artillery_Tex.ATGun_Hud.Pak43_turret_rot'
    VehicleHudTurretLook=TexRotator'DH_Artillery_Tex.ATGun_Hud.Pak43_turret_look'
    VehicleHudOccupantsX(1)=0.47
    VehicleHudOccupantsY(1)=0.6
    ExitPositions(1)=(X=-100.0,Y=0.0,Z=10.0)
    VehicleMass=11.0
    SupplyCost=1600
    ConstructionPlacementOffset=(Z=12.0)
    bCanBeRotated=true
    PlayersNeededToRotate=2
    MapIconAttachmentClass=class'DH_Engine.DHMapIconAttachment_ATGun_Rotating'

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
    KParams=KarmaParamsRBFull'DH_Guns.DH_17PounderGun.KParams0'
}
