//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2017
//==============================================================================

class DHAdvanceObjective extends DHObjective;

// The purpose of this class is to make setup of Advance much easier and faster.  By doing this it also makes it less error prone

defaultproperties
{
    PreventCaptureTime=150
    BaseCaptureRate=0.006666 // 150 seconds (1 / # of seconds)
    MaxCaptureRate=0.006666
    bRecaptureable=true
    bSetInactiveOnClear=true
    bUseHardBaseRate=true
    AlliedAwardedReinforcements=30
    AxisAwardedReinforcements=30
    bUsePostCaptureOperations=true
}
