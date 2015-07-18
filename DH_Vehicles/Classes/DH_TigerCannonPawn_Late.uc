//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DH_TigerCannonPawn_Late extends DH_TigerCannonPawn;

defaultproperties
{
    GunsightPositions=2 // late tiger has dual magnification optics (so all positions above shift up one)
    UnbuttonedPositionIndex=3
    BinocPositionIndex=4
    DriverPositions(0)=(ViewLocation=(X=35.0,Y=-31.0,Z=3.0),ViewFOV=14.4),ViewPitchUpLimit=3095,ViewPitchDownLimit=64353,ViewPositiveYawLimit=19000,ViewNegativeYawLimit=-20000,bDrawOverlays=true)
    DriverPositions(1)=(ViewLocation=(X=35.0,Y=-31.0,Z=3.0),ViewFOV=28.8,TransitionUpAnim="",DriverTransitionAnim="",ViewPitchUpLimit=3095,ViewPitchDownLimit=64353,ViewPositiveYawLimit=19000,ViewNegativeYawLimit=-20000,bDrawOverlays=true)
    DriverPositions(2)=(ViewFOV=90.0,TransitionUpAnim="com_open",TransitionDownAnim="",DriverTransitionAnim="VTiger_com_close",ViewPitchUpLimit=5000,ViewPitchDownLimit=64000,ViewPositiveYawLimit=6000,ViewNegativeYawLimit=-10000)
    DriverPositions(3)=(ViewFOV=90.0,TransitionDownAnim="com_close",DriverTransitionAnim="VTiger_com_open",ViewPitchUpLimit=10000,ViewPitchDownLimit=64000,ViewPositiveYawLimit=6000,ViewNegativeYawLimit=-10000,bExposed=true)
    DriverPositions(4)=(ViewFOV=12.0,PositionMesh=SkeletalMesh'DH_Tiger_anm.Tiger_turret_int',ViewPitchUpLimit=10000,ViewPitchDownLimit=64000,ViewPositiveYawLimit=6000,ViewNegativeYawLimit=-10000,bDrawOverlays=true,bExposed=true)
}
