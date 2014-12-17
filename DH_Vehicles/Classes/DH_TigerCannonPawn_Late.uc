//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_TigerCannonPawn_Late extends DH_TigerCannonPawn; // Matt: originally extended DH_GermanTankCannonPawn but better to extend DH_TigerCannonPawn & make minor changes

defaultproperties
{
    GunsightPositions=2
    UnbuttonedPositionIndex=3
    BinocPositionIndex=4
    DriverPositions(0)=(ViewLocation=(X=35.000000,Y=-31.000000,Z=3.000000),ViewFOV=14.400000,ViewPitchUpLimit=3095,ViewPitchDownLimit=64353,ViewPositiveYawLimit=19000,ViewNegativeYawLimit=-20000,bDrawOverlays=true)
    DriverPositions(1)=(ViewLocation=(X=35.000000,Y=-31.000000,Z=3.000000),TransitionUpAnim="",DriverTransitionAnim="",ViewFOV=28.799999,ViewPitchUpLimit=3095,ViewPitchDownLimit=64353,ViewPositiveYawLimit=19000,ViewNegativeYawLimit=-20000,bDrawOverlays=true)
    DriverPositions(2)=(ViewFOV=90.000000,TransitionUpAnim="com_open",TransitionDownAnim="",DriverTransitionAnim="VTiger_com_close",ViewPitchUpLimit=5000,ViewPitchDownLimit=64000,ViewPositiveYawLimit=6000,ViewNegativeYawLimit=-10000,bExposed=false)
    DriverPositions(3)=(ViewFOV=90.000000,TransitionDownAnim="com_close",DriverTransitionAnim="VTiger_com_open",ViewPitchUpLimit=10000,ViewPitchDownLimit=64000,ViewPositiveYawLimit=6000,ViewNegativeYawLimit=-10000,bDrawOverlays=false,bExposed=true)
    DriverPositions(4)=(ViewFOV=12.000000,PositionMesh=SkeletalMesh/*'axis_tiger1_anm.Tiger1_turret_int*/'DH_Tiger_anm_WIP.Tiger1_turret_int_new',ViewPitchUpLimit=10000,ViewPitchDownLimit=64000,ViewPositiveYawLimit=6000,ViewNegativeYawLimit=-10000,bDrawOverlays=true,bExposed=true)
}
