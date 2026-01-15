//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_PantherDCannonPawn extends DHGermanCannonPawn;

defaultproperties
{
    GunClass=Class'DH_PantherDCannon'
    DriverPositions(0)=(ViewLocation=(X=34.0,Y=-27.0,Z=7.0),ViewFOV=34.0,PositionMesh=SkeletalMesh'DH_Panther_anm.Panther_turret_int',ViewPitchUpLimit=3276,ViewPitchDownLimit=64080,ViewPositiveYawLimit=19000,ViewNegativeYawLimit=-20000,bDrawOverlays=true)
    DriverPositions(1)=(PositionMesh=SkeletalMesh'DH_Panther_anm.Panther_turret_int',TransitionUpAnim="com_open",DriverTransitionAnim="VPanther_com_close",ViewPitchUpLimit=5000,ViewPitchDownLimit=64000,ViewPositiveYawLimit=6000,ViewNegativeYawLimit=-10000)
    DriverPositions(2)=(PositionMesh=SkeletalMesh'DH_Panther_anm.Panther_turret_int',TransitionDownAnim="com_close",DriverTransitionAnim="VPanther_com_open",ViewPitchUpLimit=10000,ViewPitchDownLimit=64000,ViewPositiveYawLimit=6000,ViewNegativeYawLimit=-10000,bExposed=true)
    DriverPositions(3)=(ViewFOV=12.0,PositionMesh=SkeletalMesh'DH_Panther_anm.Panther_turret_int',DriverTransitionAnim="stand_idleiron_binoc",ViewPitchUpLimit=10000,ViewPitchDownLimit=64000,ViewPositiveYawLimit=6000,ViewNegativeYawLimit=-10000,bDrawOverlays=true,bExposed=true)
    DriveAnim="VPanther_com_idle_close"
    CannonScopeCenter=Texture'DH_VehicleOptics_tex.Panther_sight_graticule'
    GunsightSize=0.824 // 28 degrees visible FOV at 2.5x magnification (TZF12 sight)
    RangeRingRotator=TexRotator'DH_VehicleOptics_tex.Panther_sight_center'
    RangeRingScale=0.74
    RangeRingRotationFactor=502
    AmmoShellTexture=Texture'InterfaceArt_tex.Panthershell'
    AmmoShellReloadTexture=Texture'InterfaceArt_tex.Panthershell_reload'
    PoweredRotateSound=Sound'Vehicle_Weapons.hydraul_turret_traverse'
    PoweredPitchSound=Sound'Vehicle_Weapons.manual_turret_elevate'
    PoweredRotateAndPitchSound=Sound'Vehicle_Weapons.hydraul_turret_traverse'
    FireImpulse=(X=-110000.0)
}
