//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_ShermanCannonPawn_M4A3E8 extends DH_ShermanCannonPawnA_76mm;

defaultproperties
{
    GunClass=class'DH_ShermanCannon_M4A3E8'

    // Gun
    DriverPositions(0)=(ViewFOV=17.0,ViewLocation=(X=18.0,Y=20.0,Z=7.0),ViewPitchUpLimit=5461,ViewPitchDownLimit=63715,ViewPositiveYawLimit=19000,ViewNegativeYawLimit=-20000,bDrawOverlays=true)
    // Periscope
    DriverPositions(1)=(ViewFOV=0,TransitionUpAnim="com_open",DriverTransitionAnim="VTiger_com_close",ViewLocation=(X=10.0,Y=0.0,Z=15.0),ViewPitchUpLimit=1,ViewPitchDownLimit=65535,ViewPositiveYawLimit=65536,ViewNegativeYawLimit=-65536,bDrawOverlays=true)
    // Open-top
    DriverPositions(2)=(ViewFOV=0,TransitionDownAnim="com_close",DriverTransitionAnim="VTiger_com_open",ViewPitchUpLimit=10000,ViewPitchDownLimit=63500,ViewPositiveYawLimit=10000,ViewNegativeYawLimit=-10000,bExposed=true)
    // Binoculars
    DriverPositions(3)=(ViewFOV=17.0,DriverTransitionAnim="stand_idleiron_binoc",ViewPitchUpLimit=10000,ViewPitchDownLimit=63500,ViewPositiveYawLimit=10000,ViewNegativeYawLimit=-10000,bDrawOverlays=true,bExposed=true)

    PeriscopePositionIndex=1
    BinocPositionIndex=3

    DrivePos=(X=0,Y=0,Z=0)
    DriveAnim="VTiger_com_idle_close"
}

