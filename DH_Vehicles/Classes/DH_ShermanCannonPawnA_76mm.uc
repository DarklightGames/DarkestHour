//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_ShermanCannonPawnA_76mm extends DHAmericanCannonPawn;

defaultproperties
{
    GunClass=Class'DH_ShermanCannonA_76mm'
    DriverPositions(0)=(ViewLocation=(X=18.0,Y=20.0,Z=7.0),ViewFOV=17.0,ViewPitchUpLimit=5461,ViewPitchDownLimit=63715,ViewPositiveYawLimit=19000,ViewNegativeYawLimit=-20000,bDrawOverlays=true)
    DriverPositions(1)=(ViewLocation=(X=0.0,Y=0.0,Z=10.0),TransitionUpAnim="com_open",ViewPitchUpLimit=1,ViewPitchDownLimit=65535,ViewPositiveYawLimit=65536,ViewNegativeYawLimit=-65536,bDrawOverlays=true)
    DriverPositions(2)=(TransitionDownAnim="com_close",DriverTransitionAnim="stand_idlehip_binoc",ViewPitchUpLimit=10000,ViewPitchDownLimit=63500,ViewPositiveYawLimit=10000,ViewNegativeYawLimit=-10000,bExposed=true)
    DriverPositions(3)=(ViewFOV=12.0,DriverTransitionAnim="stand_idleiron_binoc",ViewPitchUpLimit=10000,ViewPitchDownLimit=63500,ViewPositiveYawLimit=10000,ViewNegativeYawLimit=-10000,bDrawOverlays=true,bExposed=true)
    PeriscopePositionIndex=1
    DrivePos=(X=3.0,Y=2.0,Z=-17.0)
    DriveAnim="stand_idlehip_binoc"
    GunsightOverlay=Texture'DH_VehicleOptics_tex.Sherman76mm_sight_background'
    GunsightSize=0.765 // 13 degrees visible FOV at 5x magnification (M71D sight)
    AmmoShellTexture=Texture'DH_InterfaceArt_tex.WolverineShell'
    AmmoShellReloadTexture=Texture'DH_InterfaceArt_tex.WolverineShell_reload'
    PoweredRotateSound=Sound'DH_AlliedVehicleSounds.ShermanTurretTraverse'
    PoweredPitchSound=Sound'Vehicle_Weapons.manual_turret_elevate'
    PoweredRotateAndPitchSound=Sound'DH_AlliedVehicleSounds.ShermanTurretTraverse'
    FireImpulse=(X=-95000.0)
}
