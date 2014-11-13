//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_AT57Gun extends DH_ATGun;

#exec OBJ LOAD FILE=..\Animations\DH_AT57_anm.ukx

defaultproperties
{
     VehicleHudTurret=TexRotator'DH_Artillery_Tex.ATGun_Hud.57mm_turret_rot'
     VehicleHudTurretLook=TexRotator'DH_Artillery_Tex.ATGun_Hud.57mm_turret_look'
     VehicleHudThreadsPosX(0)=0.160000
     VehicleHudThreadsPosX(1)=0.960000
     VehicleHudThreadsScale=0.600000
     TransRatio=0.000000
     PassengerWeapons(0)=(WeaponPawnClass=class'DH_Guns.DH_AT57CannonPawn',WeaponBone="Turret_placement")
     DestroyedVehicleMesh=StaticMesh'DH_Artillery_stc.57mm_Gun.AT57mm_destroyed'
     DestructionEffectClass=class'AHZ_ROVehicles.ATCannonDestroyedEmitter'
     DisintegrationEffectClass=class'AHZ_ROVehicles.ATCannonDestroyedEmitter'
     DestructionLinearMomentum=(Min=100.000000,Max=350.000000)
     DestructionAngularMomentum=(Min=50.000000,Max=150.000000)
     DamagedEffectClass=none
     DamagedEffectScale=0.850000
     DamagedEffectOffset=(X=-100.000000,Y=20.000000,Z=26.000000)
     VehicleTeam=1
     BeginningIdleAnim=
     InitialPositionIndex=0
     VehicleHudImage=Texture'DH_Artillery_Tex.ATGun_Hud.57mm_body'
     VehicleHudOccupantsX(0)=0.000000
     VehicleHudOccupantsX(1)=0.470000
     VehicleHudOccupantsX(2)=0.000000
     VehicleHudOccupantsY(0)=0.000000
     VehicleHudOccupantsY(1)=0.600000
     VehicleHudOccupantsY(2)=0.000000
     VehHitpoints(0)=(PointRadius=0.000000,PointBone="turret_attachment",bPenetrationPoint=false,DamageMultiplier=1.000000)
     VehHitpoints(1)=(PointBone="turret_attachment",bPenetrationPoint=true,DamageMultiplier=10.000000,HitPointType=HP_AmmoStore)
     VehicleMass=11.000000
     bFPNoZFromCameraPitch=true
     DrivePos=(X=0.000000,Y=0.000000,Z=0.000000)
     DriveAnim=
     ExitPositions(0)=(Y=-200.000000,Z=100.000000)
     EntryRadius=500.000000
     FPCamPos=(X=0.000000,Y=0.000000,Z=0.000000)
     TPCamDistance=600.000000
     TPCamLookat=(X=-50.000000)
     TPCamWorldOffset=(Z=250.000000)
     DriverDamageMult=1.000000
     VehiclePositionString="Using a 57mm M1 AT-Gun"
     VehicleNameString="57mm M1 AT-Gun"
     HUDOverlayFOV=90.000000
     PitchUpLimit=5000
     PitchDownLimit=60000
     HealthMax=101.000000
     Health=101
     Mesh=SkeletalMesh'DH_AT57_anm.AT57_body'
     Skins(0)=Texture'DH_Artillery_Tex.57mmGun.57mmGun'
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
     KParams=KarmaParamsRBFull'DH_Guns.DH_AT57Gun.KParams0'

}
