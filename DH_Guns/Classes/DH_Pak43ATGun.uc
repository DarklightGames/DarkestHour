//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DH_Pak43ATGun extends DHATGun;

#exec OBJ LOAD FILE=..\Animations\DH_Pak43_anm.ukx

defaultproperties
{
    VehicleHudTurret=TexRotator'DH_Artillery_Tex.ATGun_Hud.Pak43_turret_rot'
    VehicleHudTurretLook=TexRotator'DH_Artillery_Tex.ATGun_Hud.Pak43_turret_look'
    VehicleHudThreadsPosX(0)=0.16
    VehicleHudThreadsPosX(1)=0.96
    VehicleHudThreadsScale=0.6
    TreadHitMinAngle=1.9
    TransRatio=0.0
    PassengerWeapons(0)=(WeaponPawnClass=class'DH_Guns.DH_Pak43CannonPawn',WeaponBone="Turret_placement")
    DestroyedVehicleMesh=StaticMesh'DH_Artillery_stc.Pak43.Pak43_dest'
    DestructionEffectClass=class'AHZ_ROVehicles.ATCannonDestroyedEmitter'
    DisintegrationEffectClass=class'AHZ_ROVehicles.ATCannonDestroyedEmitter'
    DestructionLinearMomentum=(Min=100.0,Max=350.0)
    DestructionAngularMomentum=(Min=50.0,Max=150.0)
    DamagedEffectClass=none
    DamagedEffectScale=0.85
    DamagedEffectOffset=(X=-100.0,Y=20.0,Z=26.0)
    BeginningIdleAnim=""
    InitialPositionIndex=0
    VehicleHudImage=texture'DH_Artillery_Tex.ATGun_Hud.pak43_body'
    VehicleHudOccupantsX(0)=0.0
    VehicleHudOccupantsX(1)=0.47
    VehicleHudOccupantsX(2)=0.0
    VehicleHudOccupantsY(0)=0.0
    VehicleHudOccupantsY(1)=0.6
    VehicleHudOccupantsY(2)=0.0
    VehicleMass=11.0
    bFPNoZFromCameraPitch=true
    DrivePos=(X=0.0,Y=0.0,Z=0.0)
    DriveAnim=
    ExitPositions(1)=(X=-105.00,Y=-37.00,Z=28.00)
    EntryRadius=475.0
    DriverDamageMult=1.0
    VehicleNameString="8.8 cm Pak43/41 AT gun"
    HUDOverlayFOV=90.0
    PitchUpLimit=5000
    PitchDownLimit=60000
    HealthMax=101.0
    Health=101
    Mesh=SkeletalMesh'DH_Pak43_anm.pak43_body'
    Skins(0)=texture'DH_Artillery_Tex.Pak43.pak43_nocamo_ext'
    Skins(1)=texture'DH_Artillery_Tex.Pak43.Pak43_wheel'
    CollisionRadius=60.0
    CollisionHeight=175.0
    Begin Object Class=KarmaParamsRBFull Name=KParams0
        KInertiaTensor(0)=1.0
        KInertiaTensor(3)=3.0
        KInertiaTensor(5)=3.0
        KCOMOffset=(Z=-0.9)
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
    KParams=KarmaParamsRBFull'DH_Guns.DH_Pak43ATGun.KParams0'
}
