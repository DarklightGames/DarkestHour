//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_Kz8cmGrW42VehicleWeaponPawn extends DHMortarVehicleWeaponPawn;

defaultproperties
{
    DriverPositions(0)=(PositionMesh=SkeletalMesh'DH_Mortars_3rd.Kz8cmGrW42_deployed',TransitionUpAnim="Overlay_Out",bExposed=true)
    DriverPositions(1)=(ViewFOV=20.0,PositionMesh=SkeletalMesh'DH_Mortars_3rd.Kz8cmGrW42_deployed',TransitionDownAnim="Overlay_In",bExposed=true)
    WeaponClass=Class'DH_Kz8cmGrW42Weapon'
    GunClass=Class'DH_Kz8cmGrW42VehicleWeapon'
    HUDOverlayClass=Class'DH_Kz8cmGrW42Overlay'
    DriverFiringAnim="deploy_fire_GrW42"
    DriverUnflinchAnim="flinch_return_GrW42"
    OverlayKnobIdleAnim="traverse_idle"
    DriveAnim="deploy_idle_GrW42"
    DrivePos=(X=28.0,Z=34.0)
    UndeployingDuration=1.4
    HUDHighExplosiveTexture=Texture'DH_Mortars_tex.Kz8cmGrW42.Wgr34-HE'
    HUDSmokeTexture=Texture'DH_Mortars_tex.Kz8cmGrW42.Wgr34-Nb'
    HUDArcTexture=Texture'DH_Mortars_tex.ArcG'
    ArtillerySpottingScopeClass=Class'DHArtillerySpottingScope_AxisMortar'
}
