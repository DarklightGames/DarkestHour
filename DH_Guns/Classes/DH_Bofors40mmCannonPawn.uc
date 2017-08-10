//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2017
//==============================================================================

class DH_Bofors40mmCannonPawn extends DHATGunCannonPawn;

// Modified to update sight rotation, if gun pitch has changed
function HandleTurretRotation(float DeltaTime, float YawChange, float PitchChange)
{
    super.HandleTurretRotation(DeltaTime, YawChange, PitchChange);

    if (Level.NetMode != NM_DedicatedServer && ((YawChange != 0.0 && !bTurretRingDamaged) || (PitchChange != 0.0 && !bGunPivotDamaged)) && DH_Bofors40mmCannon(Gun) != none)
    {
        DH_Bofors40mmCannon(Gun).UpdateSightAndWheelRotation();
    }
}

defaultproperties
{
    GunClass=class'DH_Guns.DH_Bofors40mmCannon'
    DriverPositions(0)=(ViewLocation=(X=25.0,Y=0.0,Z=0.0),ViewFOV=12.0,PositionMesh=SkeletalMesh'DH_Bofors_anm.bofors_turret',TransitionUpAnim="optic_out",bDrawOverlays=true,bExposed=true)
    DriverPositions(1)=(PositionMesh=SkeletalMesh'DH_Bofors_anm.bofors_turret',TransitionUpAnim="lookover_up",TransitionDownAnim="optic_in",bExposed=true)
    DriverPositions(2)=(PositionMesh=SkeletalMesh'DH_Bofors_anm.bofors_turret',TransitionDownAnim="lookover_down",ViewPitchUpLimit=6000,ViewPitchDownLimit=63500,ViewPositiveYawLimit=20000,ViewNegativeYawLimit=-20000,bExposed=true)
    DriverPositions(3)=(ViewFOV=12.0,PositionMesh=SkeletalMesh'DH_Bofors_anm.bofors_turret',ViewPitchUpLimit=6000,ViewPitchDownLimit=63500,ViewPositiveYawLimit=20000,ViewNegativeYawLimit=-20000,bDrawOverlays=true,bExposed=true)
    IntermediatePositionIndex=1 // the open sights position (used to play a special 'intermediate' firing anim in that position)
    RaisedPositionIndex=2
    BinocPositionIndex=3
    DriveAnim="VIS2_driver_idle_close"
    DrivePos=(X=-35.0,Y=26.0,Z=13.0)
    GunsightOverlay=texture'DH_Artillery_tex.ATGun_Hud.Flakvierling38_sight'
    GunsightSize=1.0
    AmmoShellTexture=texture'DH_InterfaceArt_tex.Tank_Hud.2341Mag'
    AmmoShellReloadTexture=texture'DH_InterfaceArt_tex.Tank_Hud.2341Mag_reload'
    bHasFireImpulse=false
}

