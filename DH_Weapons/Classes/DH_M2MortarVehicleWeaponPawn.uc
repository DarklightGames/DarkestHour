//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2021
//==============================================================================

class DH_M2MortarVehicleWeaponPawn extends DHMortarVehicleWeaponPawn;

defaultproperties
{
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
}
