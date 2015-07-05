//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DH_M2MortarVehicleWeaponPawn extends DHMortarVehicleWeaponPawn;

#exec OBJ LOAD FILE=..\Animations\DH_Mortars_3rd.ukx

defaultproperties
{
    WeaponClass=class'DH_Mortars.DH_M2MortarWeapon'
    GunClass=class'DH_Mortars.DH_M2MortarVehicleWeapon'
    HUDOverlayClass=class'DH_Mortars.DH_M2MortarOverlay'
    HUDOverlayOffset=(Z=-2.0)
    DriverFiringAnim="crouch_fire_M2Mortar"
    DriverUnflinchAnim="unflinch_M2Mortar"
    OverlayKnobIdleAnim="knob_lidle"
    DriveAnim="crouch_deploy_idle_M2Mortar"
    DrivePos=(X=28.0,Z=38.0)
    UndeployingDuration=2.7
    HUDHighExplosiveTexture=texture'DH_Mortars_tex.60mmMortarM2.M49A2-HE'
    HUDSmokeTexture=texture'DH_Mortars_tex.60mmMortarM2.M302-WP'
    HUDArcTexture=texture'DH_Mortars_tex.HUD.ArcA'
}
