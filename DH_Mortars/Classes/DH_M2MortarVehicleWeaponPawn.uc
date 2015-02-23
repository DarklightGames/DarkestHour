//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_M2MortarVehicleWeaponPawn extends DH_MortarVehicleWeaponPawn;

#exec OBJ LOAD FILE=..\Animations\DH_Mortars_3rd.ukx

defaultproperties
{
    DriverIdleAnim="crouch_deploy_idle_M2Mortar"
    DriverFiringAnim="crouch_fire_M2Mortar"
    DriverUnflinchAnim="unflinch_M2Mortar"
    OverlayIdleAnim="deploy_idle"
    OverlayFiringAnim="Fire"
    OverlayUndeployingAnim="undeploy"
    OverlayKnobRaisingAnim="knob_raise"
    OverlayKnobLoweringAnim="knob_lower"
    OverlayKnobIdleAnim="knob_lidle"
    OverlayKnobTurnLeftAnim="traverse_left"
    OverlayKnobTurnRightAnim="traverse_right"
    GunIdleAnim="idle_M2Mortar"
    GunFiringAnim="fire_M2Mortar"
    WeaponClass=class'DH_Mortars.DH_M2MortarWeapon'
    HUDMortarTexture=texture'DH_Mortars_tex.60mmMortarM2.60mmMortarM2Side'
    HUDArcTexture=texture'DH_Mortars_tex.HUD.ArcA'
    DriverPositions(0)=(ViewFOV=90.0,PositionMesh=SkeletalMesh'DH_Mortars_3rd.M2_Mortar_turret',ViewPositiveYawLimit=32768,ViewNegativeYawLimit=-32768,bDrawOverlays=true,bExposed=true)
    bMustBeTankCrew=false
    GunClass=class'DH_Mortars.DH_M2MortarVehicleWeapon'
    CameraBone="Camera"
    DrivePos=(X=28.0,Z=38.0)
    DriveAnim="crouch_deploy_idle_M2Mortar"
    TPCamDistance=128.0
    TPCamLookat=(Z=16.0)
    TPCamDistRange=(Min=128.0,Max=128.0)
    HUDOverlayClass=class'DH_Mortars.DH_M2MortarOverlay'
    HUDOverlayOffset=(Z=-2.0)
    HUDOverlayFOV=90.0
}
