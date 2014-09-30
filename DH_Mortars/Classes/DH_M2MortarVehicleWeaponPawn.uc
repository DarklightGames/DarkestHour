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
     WeaponClass=Class'DH_Mortars.DH_M2MortarWeapon'
     HUDMortarTexture=Texture'DH_Mortars_tex.60mmMortarM2.60mmMortarM2Side'
     HUDArcTexture=Texture'DH_Mortars_tex.HUD.ArcA'
     DriverPositions(0)=(ViewFOV=90.000000,PositionMesh=SkeletalMesh'DH_Mortars_3rd.M2_Mortar_turret',ViewPositiveYawLimit=32768,ViewNegativeYawLimit=-32768,bDrawOverlays=true,bExposed=true)
     bMustBeTankCrew=false
     GunClass=Class'DH_Mortars.DH_M2MortarVehicleWeapon'
     CameraBone="Camera"
     DrivePos=(X=28.000000,Z=38.000000)
     DriveAnim="crouch_deploy_idle_M2Mortar"
     TPCamDistance=128.000000
     TPCamLookat=(Z=16.000000)
     TPCamDistRange=(Min=128.000000,Max=128.000000)
     HUDOverlayClass=Class'DH_Mortars.DH_M2MortarOverlay'
     HUDOverlayOffset=(Z=-2.000000)
     HUDOverlayFOV=90.000000
}
