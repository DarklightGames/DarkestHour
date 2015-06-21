//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DH_Kz8cmGrW42VehicleWeaponPawn extends DHMortarVehicleWeaponPawn;

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
    WeaponClass=class'DH_Mortars.DH_Kz8cmGrW42Weapon'
    HUDHighExplosiveTexture=texture'DH_Mortars_tex.Kz8cmGrW42.Wgr34-HE'
    HUDSmokeTexture=texture'DH_Mortars_tex.Kz8cmGrW42.Wgr34-Nb'
    HUDArcTexture=texture'DH_Mortars_tex.HUD.ArcG'
    bMustBeTankCrew=false
    GunClass=class'DH_Mortars.DH_Kz8cmGrW42VehicleWeapon'
    CameraBone="Camera"
    DrivePos=(X=28.0,Z=34.0)
    DriveAnim="deploy_idle_GrW42"
    TPCamDistance=128.0
    TPCamLookat=(Z=16.0)
    TPCamDistRange=(Min=128.0,Max=128.0)
    HUDOverlayClass=class'DH_Mortars.DH_Kz8cmGrW42Overlay'
    HUDOverlayFOV=90.0
    HitPoints(0)=(PointBone="Baseplate",DamageMultiplier=1.0)
}

