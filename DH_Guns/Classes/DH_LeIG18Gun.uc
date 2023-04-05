//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_LeIG18Gun extends DHATGun;

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
    VehicleNameString="7.5 cm leichtes Infanteriegeschütz 18"
    VehicleTeam=0
    PassengerWeapons(0)=(WeaponPawnClass=class'DH_Guns.DH_LeIG18CannonPawn',WeaponBone="turret_placement")
    Mesh=SkeletalMesh'DH_LeIG18_anm.leig18_body'
    Skins(0)=Texture'DH_LeIG18_tex.LeIG18.IG18_1'
    Skins(1)=Texture'DH_LeIG18_tex.LeIG18.IG18_2'
    DestroyedVehicleMesh=StaticMesh'DH_LeIG18_stc.Destroyed.leig18_destro'
    DestroyedMeshSkins(0)=Material'DH_LeIG18_tex.LeIG18.IG18_2_dest'
    DestroyedMeshSkins(1)=Material'DH_LeIG18_tex.LeIG18.IG18_1_dest'
    DestroyedMeshSkins(2)=Material'DH_LeIG18_tex.LeIG18.IG18_1_dest'
    VehicleHudImage=Texture'DH_LeIG18_tex.HUD.leig18_body'
    VehicleHudTurret=TexRotator'DH_LeIG18_tex.HUD.leig18_turret_rot'
    VehicleHudTurretLook=TexRotator'DH_LeIG18_tex.HUD.leig18_turret_look'
    VehicleHudOccupantsX(1)=0.4
    ExitPositions(1)=(X=-35.00,Y=-65.00,Z=60.00)
    VehicleMass=11.0 // TODO: replace
    SupplyCost=1500
    bCanBeRotated=true
    MapIconAttachmentClass=class'DH_Engine.DHMapIconAttachment_ATGun_Rotating'
    RotateCooldown=2
    ShadowZOffset=10
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
    KParams=KarmaParamsRBFull'DH_Guns.DH_LeIG18Gun.KParams0'
}
