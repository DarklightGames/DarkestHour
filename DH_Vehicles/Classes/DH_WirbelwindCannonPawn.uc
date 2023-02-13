//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_WirbelwindCannonPawn extends DH_Flakvierling38CannonPawn;

defaultproperties
{
    bMustBeTankCrew=true
    GunClass=class'DH_Vehicles.DH_WirbelwindCannon'
    DrivePos=(X=-60.0,Y=5,Z=70.0)
    DriveAnim="crouch_idle_binoc"
    DriverPositions(0)=(ViewFOV=28.33,PositionMesh=SkeletalMesh'DH_Flak38_anm.Wirbelwind_turret',ViewLocation=(X=25.0,Y=0.0,Z=0.0),TransitionUpAnim="optic_out",bDrawOverlays=true,bExposed=true,DriverTransitionAnim="crouch_idle_binoc")
    DriverPositions(1)=(ViewFOV=72.0,PositionMesh=SkeletalMesh'DH_Flak38_anm.Wirbelwind_turret',TransitionUpAnim="lookover_up",TransitionDownAnim="optic_in",bExposed=true,DriverTransitionAnim="crouch_idle_binoc")
    DriverPositions(2)=(PositionMesh=SkeletalMesh'DH_Flak38_anm.Wirbelwind_turret',TransitionDownAnim="lookover_down",ViewPitchUpLimit=6000,ViewPitchDownLimit=63500,ViewPositiveYawLimit=20000,ViewNegativeYawLimit=-20000,bExposed=true,DriverTransitionAnim="stand_idlehip_binoc")
    DriverPositions(3)=(ViewFOV=12.0,PositionMesh=SkeletalMesh'DH_Flak38_anm.Wirbelwind_turret',ViewPitchUpLimit=6000,ViewPitchDownLimit=63500,ViewPositiveYawLimit=20000,ViewNegativeYawLimit=-20000,bDrawOverlays=true,bExposed=true,DriverTransitionAnim="stand_idleiron_binoc")
}

