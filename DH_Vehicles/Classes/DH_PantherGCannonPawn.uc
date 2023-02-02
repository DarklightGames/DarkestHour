//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_PantherGCannonPawn extends DH_PantherDCannonPawn;

defaultproperties
{
    GunClass=class'DH_Vehicles.DH_PantherGCannon'
    // All positions shift down 1 due to dual magnification optics (note need for overridden zero ViewFOV, which just makes it use player's default view FOV):
    DriverPositions(0)=(ViewLocation=(X=34.0,Y=-27.0,Z=7.0),ViewFOV=17.0,ViewPitchUpLimit=3276,ViewPitchDownLimit=64080,ViewPositiveYawLimit=19000,ViewNegativeYawLimit=-20000,bDrawOverlays=true)
    DriverPositions(1)=(ViewLocation=(X=34.0,Y=-27.0,Z=7.0),ViewFOV=34.0,TransitionUpAnim="",DriverTransitionAnim="",ViewPitchUpLimit=3276,ViewPitchDownLimit=64080,ViewPositiveYawLimit=19000,ViewNegativeYawLimit=-20000,bDrawOverlays=true)
    DriverPositions(2)=(TransitionUpAnim="com_open",TransitionDownAnim="",DriverTransitionAnim="VPanther_com_close",ViewPitchUpLimit=5000,ViewPitchDownLimit=64000,ViewPositiveYawLimit=6000,ViewNegativeYawLimit=-10000,bExposed=false)
    DriverPositions(3)=(ViewFOV=0.0,TransitionDownAnim="com_close",DriverTransitionAnim="VPanther_com_open",ViewPitchUpLimit=10000,ViewPitchDownLimit=64000,ViewPositiveYawLimit=6000,ViewNegativeYawLimit=-10000,bDrawOverlays=false,bExposed=true)
    DriverPositions(4)=(ViewFOV=12.0,PositionMesh=SkeletalMesh'DH_Panther_anm.Panther_turret_int',DriverTransitionAnim="stand_idleiron_binoc",ViewPitchUpLimit=10000,ViewPitchDownLimit=64000,ViewPositiveYawLimit=6000,ViewNegativeYawLimit=-10000,bDrawOverlays=true,bExposed=true)
    GunsightPositions=2 // ZF12a sight with dual magnification (5x or 2.5x) with 28/14 degrees visible FOV
    UnbuttonedPositionIndex=3
    BinocPositionIndex=4
}
