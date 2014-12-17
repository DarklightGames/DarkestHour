//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_Flak88Gun extends DH_ATGun;

#exec OBJ LOAD FILE=..\Animations\DH_Flak88_anm.ukx
#exec OBJ LOAD FILE=..\Textures\MilitaryAxisSMT.utx
#exec OBJ LOAD FILE=..\StaticMeshes\MilitaryAxisSM.usx

defaultproperties
{
    VehicleHudTurret=TexRotator'DH_Artillery_Tex.ATGun_Hud.flak88_turret_rot'
    VehicleHudTurretLook=TexRotator'DH_Artillery_Tex.ATGun_Hud.flak88_turret_look'
    VehicleHudThreadsPosX(0)=0.160000
    VehicleHudThreadsPosX(1)=0.960000
    VehicleHudThreadsScale=0.600000
    TreadHitMinAngle=1.900000
    TransRatio=0.000000
    PassengerWeapons(0)=(WeaponPawnClass=class'DH_Guns.DH_Flak88CannonPawn',WeaponBone="Turret_placement")
    DestroyedVehicleMesh=StaticMesh'MilitaryAxisSM.Artillery.Flak88_destroyed'
    DestructionEffectClass=class'AHZ_ROVehicles.ATCannonDestroyedEmitter'
    DisintegrationEffectClass=class'AHZ_ROVehicles.ATCannonDestroyedEmitter'
    DestructionLinearMomentum=(Min=100.000000,Max=350.000000)
    DestructionAngularMomentum=(Min=50.000000,Max=150.000000)
    DamagedEffectClass=none
    DamagedEffectScale=0.850000
    DamagedEffectOffset=(X=-100.000000,Y=20.000000,Z=26.000000)
    BeginningIdleAnim=
    InitialPositionIndex=0
    VehicleHudImage=texture'DH_Artillery_Tex.ATGun_Hud.flak88_body'
    VehicleHudOccupantsX(0)=0.000000
    VehicleHudOccupantsX(1)=0.540000
    VehicleHudOccupantsX(2)=0.000000
    VehicleHudOccupantsY(0)=0.000000
    VehicleHudOccupantsY(1)=0.600000
    VehicleHudOccupantsY(2)=0.000000
    VehHitpoints(0)=(PointRadius=0.000000,PointBone="turret_attachment",bPenetrationPoint=false)
    VehHitpoints(1)=(PointRadius=0.000000,PointBone="turret_attachment")
    VehicleMass=20.000000
    bFPNoZFromCameraPitch=true
    DrivePos=(X=0.000000,Y=0.000000,Z=0.000000)
    DriveAnim=
    ExitPositions(0)=(Y=-200.000000,Z=100.000000)
    EntryRadius=475.000000
    FPCamPos=(X=0.000000,Y=0.000000,Z=0.000000)
    TPCamDistance=600.000000
    TPCamLookat=(X=-50.000000)
    TPCamWorldOffset=(Z=250.000000)
    DriverDamageMult=1.000000
    VehiclePositionString="Using a FlaK 36 Gun"
    VehicleNameString="FlaK 36 Gun"
    HUDOverlayFOV=90.000000
    PitchUpLimit=5000
    PitchDownLimit=60000
    HealthMax=100.000000
    Health=100
    Mesh=SkeletalMesh'DH_Flak88_anm.flak88_body'
    Skins(0)=texture'MilitaryAxisSMT.Artillery.flak_88'
    CollisionRadius=60.000000
    CollisionHeight=175.000000
    Begin Object Class=KarmaParamsRBFull Name=KParams0
        KInertiaTensor(0)=1.000000
        KInertiaTensor(3)=3.000000
        KInertiaTensor(5)=3.000000
        KCOMOffset=(Z=-2.000000)
        KLinearDamping=0.050000
        KAngularDamping=0.050000
        KStartEnabled=true
        bKNonSphericalInertia=true
        KMaxAngularSpeed=0.000000
        bHighDetailOnly=false
        bClientOnly=false
        bKDoubleTickRate=true
        bDestroyOnWorldPenetrate=true
        bDoSafetime=true
        KFriction=50.000000
        KImpactThreshold=700.000000
    End Object
    KParams=KarmaParamsRBFull'DH_Guns.DH_Flak88Gun.KParams0'
}
