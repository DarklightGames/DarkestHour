//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_Pak38ATGun extends DHATGun;

simulated event DestroyAppearance()
{
    local Combiner DestroyedSkin;

    DestroyedSkin = Combiner(Level.ObjectPool.AllocateObject(class'Combiner'));
    DestroyedSkin.Material1 = Skins[0];
    DestroyedSkin.Material2 = Texture'DH_FX_Tex.Overlays.DestroyedVehicleOverlay2';
    DestroyedSkin.FallbackMaterial = Skins[0];
    DestroyedSkin.CombineOperation = CO_Multiply;
    DestroyedMeshSkins[0] = DestroyedSkin;

    super.DestroyAppearance();
}

defaultproperties
{
    VehicleNameString="5.0 cm Pak38 AT gun"
    PassengerWeapons(0)=(WeaponPawnClass=class'DH_Guns.DH_Pak38CannonPawn',WeaponBone="Turret_placement")
    Mesh=SkeletalMesh'DH_Pak38_anm.Pak38_body'
    Skins(0)=Texture'DH_Artillery_Tex.Pak38.Pak38'
    DestroyedVehicleMesh=StaticMesh'DH_Artillery_stc.Pak38.pak38_dest'
    VehicleHudImage=Texture'DH_Artillery_Tex.ATGun_Hud.Pak40_body'
    VehicleHudTurret=TexRotator'DH_Artillery_Tex.ATGun_Hud.Pak40_turret_rot'
    VehicleHudTurretLook=TexRotator'DH_Artillery_Tex.ATGun_Hud.Pak40_turret_look'
    VehicleHudOccupantsX(1)=0.47
    VehicleHudOccupantsY(1)=0.6
    ExitPositions(1)=(X=-84.00,Y=-27.00,Z=43.00)
    VehicleMass=11.0
    SupplyCost=900
    ConstructionPlacementOffset=(Z=13.0)
    bCanBeRotated=true
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
    KParams=KarmaParamsRBFull'DH_Guns.DH_Pak38ATGun.KParams0'
}
