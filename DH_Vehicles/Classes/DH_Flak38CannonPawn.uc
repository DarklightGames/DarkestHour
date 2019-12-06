//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2019
//==============================================================================

class DH_Flak38CannonPawn extends DHATGunCannonPawn;

// Modified to update sight & aiming wheel rotation, if gun yaw or pitch has changed
function HandleTurretRotation(float DeltaTime, float YawChange, float PitchChange)
{
    super.HandleTurretRotation(DeltaTime, YawChange, PitchChange);

    if (Level.NetMode != NM_DedicatedServer && ((YawChange != 0.0 && !bTurretRingDamaged) || (PitchChange != 0.0 && !bGunPivotDamaged)) && DH_Flak38Cannon(Gun) != none)
    {
        DH_Flak38Cannon(Gun).UpdateSightAndWheelRotation();
    }
}

defaultproperties
{
    GunClass=class'DH_Vehicles.DH_Flak38Cannon'
    DriverPositions(0)=(ViewLocation=(X=25.0,Y=0.0,Z=0.0),ViewFOV=28.33,PositionMesh=SkeletalMesh'DH_Flak38_anm.Flak38_turret',TransitionUpAnim="optic_out",bDrawOverlays=true,bExposed=true)
    DriverPositions(1)=(ViewFOV=72.0,PositionMesh=SkeletalMesh'DH_Flak38_anm.Flak38_turret',TransitionUpAnim="lookover_up",TransitionDownAnim="optic_in",bExposed=true)
    DriverPositions(2)=(PositionMesh=SkeletalMesh'DH_Flak38_anm.Flak38_turret',TransitionDownAnim="lookover_down",ViewPitchUpLimit=6000,ViewPitchDownLimit=63500,ViewPositiveYawLimit=20000,ViewNegativeYawLimit=-20000,bExposed=true)
    DriverPositions(3)=(ViewFOV=12.0,PositionMesh=SkeletalMesh'DH_Flak38_anm.Flak38_turret',ViewPitchUpLimit=6000,ViewPitchDownLimit=63500,ViewPositiveYawLimit=20000,ViewNegativeYawLimit=-20000,bDrawOverlays=true,bExposed=true)
    IntermediatePositionIndex=1 // the open sights position (used to play a special 'intermediate' firing anim in that position)
    RaisedPositionIndex=2
    BinocPositionIndex=3
    DriveAnim="VIS2_driver_idle_close"
    DrivePos=(X=-35.0,Y=26.0,Z=13.0)
    CameraBone="Camera_com"
    GunsightOverlay=Texture'DH_VehicleOptics_tex.German.ZF_3x8_Flak2cm'
    GunsightSize=0.282 // 8 degrees visible FOV at 3x magnification (ZF 3x8 Flak sight)
    OverlayCorrectionX=-6
    AmmoShellTexture=Texture'DH_InterfaceArt_tex.Tank_Hud.2341Mag'
    AmmoShellReloadTexture=Texture'DH_InterfaceArt_tex.Tank_Hud.2341Mag_reload'
}
