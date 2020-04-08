//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2019
//==============================================================================

class DH_Kz8cmGrW42VehicleWeaponPawn extends DHMortarVehicleWeaponPawn;

defaultproperties
{
    DriverPositions(0)=(PositionMesh=SkeletalMesh'DH_Mortars_3rd.Kz8cmGrW42_deployed',DriverTransitionAnim="crouch_idle_binoc",TransitionUpAnim="optic_out",ViewLocation=(X=0.0,Y=-10.0,Z=40.0),ViewFOV=80.0,bDrawOverlays=true,bExposed=true)
    DriverPositions(1)=(PositionMesh=SkeletalMesh'DH_Mortars_3rd.Kz8cmGrW42_deployed',DriverTransitionAnim="crouch_idle_binoc",TransitionUpAnim="com_open",TransitionDownAnim="optic_in",bDrawOverlays=true,bExposed=true)
    WeaponClass=class'DH_Weapons.DH_Kz8cmGrW42Weapon'
    GunClass=class'DH_Weapons.DH_Kz8cmGrW42VehicleWeapon'
    HUDOverlayClass=class'DH_Weapons.DH_Kz8cmGrW42Overlay'
    DriverFiringAnim="deploy_fire_GrW42"
    DriverUnflinchAnim="flinch_return_GrW42"
    OverlayKnobIdleAnim="traverse_idle"
    DriveAnim="deploy_idle_GrW42"
    DrivePos=(X=28.0,Z=34.0)
    UndeployingDuration=1.4
    HUDHighExplosiveTexture=Texture'DH_Mortars_tex.Kz8cmGrW42.Wgr34-HE'
    HUDSmokeTexture=Texture'DH_Mortars_tex.Kz8cmGrW42.Wgr34-Nb'
    HUDArcTexture=Texture'DH_Mortars_tex.HUD.ArcG'
}
