//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2021
//==============================================================================
// [ ] destroyed mesh
// [ ] new ammo types, range calibration table etc.
// [ ] remove bullet collision from the karma box [is this even possible]?
// [ ] fix cam animation to not clip through the gunsight
// [ ] fix size of wheels
// [ ] final export for the mesh
//==============================================================================
// [ x] traverse wheel
// [x] elevation wheel
// [x] collision mesh for shield/gun
// [x] winter version ( set up in construction class also)
// [x] interface art
// [x] lock cam during transitions
// [x] vis sphere
//==============================================================================

class DH_M1927Gun extends DHATGun;

simulated function ClientKDriverEnter(PlayerController PC)
{
    local DHPlayer DHP;

    super.ClientKDriverEnter(PC);

    DHP = DHPlayer(PC);

    if (DHP != none && DHP.IsArtilleryOperator())
    {
        DHP.QueueHint(50, false);
    }
}


defaultproperties
{
    VehicleNameString="76 mm regimental gun M1927"
    VehicleTeam=1
    PassengerWeapons(0)=(WeaponPawnClass=class'DH_Guns.DH_M1927CannonPawn',WeaponBone="body")
    Mesh=SkeletalMesh'DH_M1927_anm.m1927_body'
    Skins(0)=Texture'DH_M1927_tex.world.m1927_body'
    DestroyedVehicleMesh=StaticMesh'DH_LeIG18_stc.Destroyed.leig18_destro'
    DestroyedMeshSkins(0)=Material'DH_LeIG18_tex.LeIG18.IG18_2_dest'
    DestroyedMeshSkins(1)=Material'DH_LeIG18_tex.LeIG18.IG18_1_dest'
    DestroyedMeshSkins(2)=Material'DH_LeIG18_tex.LeIG18.IG18_1_dest'
    VehicleHudImage=Texture'DH_M1927_tex.interface.m1927_body_hud'
    VehicleHudTurret=TexRotator'DH_M1927_tex.interface.m1927_turret_rot'
    VehicleHudTurretLook=TexRotator'DH_M1927_tex.interface.m1927_turret_look'
    ExitPositions(1)=(X=-75.00,Y=-35.00,Z=50.00)
    ExitPositions(2)=(X=-75.00,Y=35.00,Z=50.00)
    VehicleMass=11.0
    SupplyCost=2000
    bCanBeRotated=true
    MapIconAttachmentClass=class'DH_Engine.DHMapIconAttachment_ATGun_Rotating'
    ShadowZOffset=20.0
    bIsArtilleryVehicle=true

    Begin Object Class=KarmaParamsRBFull Name=KParams0
        KInertiaTensor(0)=1.0
        KInertiaTensor(3)=3.0
        KInertiaTensor(5)=3.0
        KCOMOffset=(Z=-10)
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
    KParams=KarmaParamsRBFull'DH_Guns.DH_M1927Gun.KParams0'
}
