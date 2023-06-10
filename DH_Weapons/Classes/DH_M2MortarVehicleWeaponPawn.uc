//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_M2MortarVehicleWeaponPawn extends DHMortarVehicleWeaponPawn;

defaultproperties
{
    DriverPositions(0)=(PositionMesh=SkeletalMesh'DH_Mortars_3rd.Kz8cmGrW42_deployed',TransitionUpAnim="Overlay_Out",bExposed=true)
    DriverPositions(1)=(ViewFOV=20.0,PositionMesh=SkeletalMesh'DH_Mortars_3rd.Kz8cmGrW42_deployed',TransitionDownAnim="Overlay_In",bExposed=true)
    WeaponClass=class'DH_Weapons.DH_M2MortarWeapon'
    GunClass=class'DH_Weapons.DH_M2MortarVehicleWeapon'
    HUDOverlayClass=class'DH_Weapons.DH_M2MortarOverlay'
    HUDOverlayOffset=(Z=-2.0)
    DriverFiringAnim="deploy_fire_M2Mortar"
    DriverUnflinchAnim="flinch_return_M2Mortar"
    OverlayKnobIdleAnim="knob_lidle"
    DriveAnim="deploy_idle_M2Mortar"
    DrivePos=(X=28.0,Z=38.0)
    UndeployingDuration=2.7
    HUDHighExplosiveTexture=Texture'DH_Mortars_tex.60mmMortarM2.M49A2-HE'
    HUDSmokeTexture=Texture'DH_Mortars_tex.60mmMortarM2.M302-WP'
    HUDArcTexture=Texture'DH_Mortars_tex.HUD.ArcA'
    ArtillerySpottingScopeClass=class'DH_Weapons.DHArtillerySpottingScope_AlliedMortar'
}
