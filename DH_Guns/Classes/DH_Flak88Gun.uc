//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DH_Flak88Gun extends DHATGun;

#exec OBJ LOAD FILE=..\Animations\DH_Flak88_anm.ukx
#exec OBJ LOAD FILE=..\Textures\MilitaryAxisSMT.utx
#exec OBJ LOAD FILE=..\StaticMeshes\MilitaryAxisSM.usx

defaultproperties
{
    VehicleHudTurret=TexRotator'DH_Artillery_Tex.ATGun_Hud.flak88_turret_rot'
    VehicleHudTurretLook=TexRotator'DH_Artillery_Tex.ATGun_Hud.flak88_turret_look'
    VehicleHudThreadsPosX(0)=0.16
    VehicleHudThreadsPosX(1)=0.96
    VehicleHudThreadsScale=0.6
    TreadHitMinAngle=1.9
    TransRatio=0.0
    PassengerWeapons(0)=(WeaponPawnClass=class'DH_Guns.DH_Flak88CannonPawn',WeaponBone="Turret_placement")
    DestroyedVehicleMesh=StaticMesh'MilitaryAxisSM.Artillery.Flak88_destroyed'
    DestructionEffectClass=class'AHZ_ROVehicles.ATCannonDestroyedEmitter'
    DisintegrationEffectClass=class'AHZ_ROVehicles.ATCannonDestroyedEmitter'
    DestructionLinearMomentum=(Min=100.0,Max=350.0)
    DestructionAngularMomentum=(Min=50.0,Max=150.0)
    DamagedEffectClass=none
    DamagedEffectScale=0.85
    DamagedEffectOffset=(X=-100.0,Y=20.0,Z=26.0)
    BeginningIdleAnim=
    InitialPositionIndex=0
    VehicleHudImage=texture'DH_Artillery_Tex.ATGun_Hud.flak88_body'
    VehicleHudOccupantsX(0)=0.0
    VehicleHudOccupantsX(1)=0.54
    VehicleHudOccupantsX(2)=0.0
    VehicleHudOccupantsY(0)=0.0
    VehicleHudOccupantsY(1)=0.6
    VehicleHudOccupantsY(2)=0.0
    VehHitpoints(0)=(PointRadius=0.0,PointBone="turret_attachment")
    VehHitpoints(1)=(PointRadius=0.0,PointBone="turret_attachment")
    VehicleMass=20.0
    bFPNoZFromCameraPitch=true
    DrivePos=(X=0.0,Y=0.0,Z=0.0)
    DriveAnim=
    ExitPositions(1)=(X=-50.0,Y=50.0,Z=50.0)
    EntryRadius=475.0
    DriverDamageMult=1.0
    VehicleNameString="FlaK 36 Gun"
    HUDOverlayFOV=90.0
    PitchUpLimit=5000
    PitchDownLimit=60000
    HealthMax=100.0
    Health=100
    Mesh=SkeletalMesh'DH_Flak88_anm.flak88_base'
    Skins(0)=texture'MilitaryAxisSMT.Artillery.flak_88'
    CollisionRadius=60.0
    CollisionHeight=175.0
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
    KParams=KarmaParamsRBFull'DH_Guns.DH_Flak88Gun.KParams0'
}
