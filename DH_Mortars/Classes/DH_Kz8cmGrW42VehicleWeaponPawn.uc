//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_Kz8cmGrW42VehicleWeaponPawn extends DH_MortarVehicleWeaponPawn;

#exec OBJ LOAD FILE=..\Animations\DH_Mortars_3rd.ukx

defaultproperties
{
     DriverIdleAnim="deploy_idle_GrW42"
     DriverFiringAnim="deploy_fire_GrW42"
     DriverUnflinchAnim="flinch_return_GrW42"
     OverlayIdleAnim="deploy_idle"
     OverlayFiringAnim="Fire"
     OverlayUndeployingAnim="undeploy"
     OverlayKnobRaisingAnim="knob_raise"
     OverlayKnobLoweringAnim="knob_lower"
     OverlayKnobIdleAnim="traverse_idle"
     OverlayKnobTurnLeftAnim="traverse_left"
     OverlayKnobTurnRightAnim="traverse_right"
     GunIdleAnim="deploy_idle_GrW42"
     GunFiringAnim="deploy_fire_GrW42"
     WeaponClass=Class'DH_Mortars.DH_Kz8cmGrW42Weapon'
     HUDMortarTexture=Texture'DH_Mortars_tex.Kz8cmGrW42.Kz8cmGrW42Side'
     HUDHighExplosiveTexture=Texture'DH_Mortars_tex.Kz8cmGrW42.Wgr34-HE'
     HUDSmokeTexture=Texture'DH_Mortars_tex.Kz8cmGrW42.Wgr34-Nb'
     HUDArcTexture=Texture'DH_Mortars_tex.HUD.ArcG'
     DriverPositions(0)=(ViewFOV=90.000000,PositionMesh=SkeletalMesh'DH_Mortars_3rd.Kz8cmGrW42_turret',bDrawOverlays=true,bExposed=true)
     bMustBeTankCrew=false
     GunClass=Class'DH_Mortars.DH_Kz8cmGrW42VehicleWeapon'
     CameraBone="Camera"
     DrivePos=(X=28.000000,Z=34.000000)
     DriveAnim="deploy_idle_GrW42"
     TPCamDistance=128.000000
     TPCamLookat=(Z=16.000000)
     TPCamDistRange=(Min=128.000000,Max=128.000000)
     HUDOverlayClass=Class'DH_Mortars.DH_Kz8cmGrW42Overlay'
     HUDOverlayFOV=90.000000
     HitPoints(0)=(PointBone="Baseplate",DamageMultiplier=1.000000)
}

