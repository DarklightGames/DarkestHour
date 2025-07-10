//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_Fiat1435MGPawn_WC extends DH_Fiat1435MGPawn;

defaultproperties
{
    GunClass=Class'DH_Fiat1435MG_WC'
    HandsReloadSequence="RELOAD_WC"
    DriverPositions(0)=(PositionMesh=SkeletalMesh'DH_Fiat1435_anm.FIAT1435_GUN_WC_1ST',bExposed=true)
    GunsightCameraBone="GUNSIGHT_CAMERA_WC"
    VehicleMGReloadTexture=Texture'DH_Fiat1435_tex.fiat1435_wc_ammo_reload'
}