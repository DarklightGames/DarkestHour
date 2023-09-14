//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DHAdvanceObjective extends DHObjective;

// The purpose of this class is to make setup of Advance much easier and faster.  By doing this it also makes it less error prone

defaultproperties
{
    bNeutralizeBeforeCapture=true
    bLockDownOnCapture=true
    PreventCaptureTime=120
    LockDownOnCaptureTime=240
    BaseCaptureRate=0.01666 // 60 seconds (1 / # of seconds)
    MaxCaptureRate=0.01666
    bRecaptureable=true
    bUseHardBaseRate=true
    AlliedAwardedReinforcements=-1
    AxisAwardedReinforcements=-1
    bUsePostCaptureOperations=false
}
