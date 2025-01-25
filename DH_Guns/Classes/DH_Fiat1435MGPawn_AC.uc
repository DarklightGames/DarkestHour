//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_Fiat1435MGPawn_AC extends DH_Fiat1435MGPawn;

defaultproperties
{
    GunClass=class'DH_Guns.DH_Fiat1435MG_AC'
    HandsReloadSequence="RELOAD_AC" // TODO: replace
    DriverPositions(0)=(PositionMesh=SkeletalMesh'DH_Fiat1435_anm.FIAT1435_GUN_AC_1ST',bExposed=true)
    GunsightCameraBone="GUNSIGHT_CAMERA_AC"
    //VehicleMGReloadTexture=Texture'DH_Fiat1435_tex.fiat1435_wc_ammo_reload'
}