//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2017
//==============================================================================

class DHAdvanceObjective extends DHObjective;

// The purpose of this class is to make setup of Advance much easier and faster.  By doing this it also makes it less error prone

defaultproperties
{
    PreventCaptureTime=90
    BaseCaptureRate=0.0055 // 3 minutes (1 / # of seconds)
    MaxCaptureRate=0.0055
    bRecaptureable=true
    bSetInactiveOnClear=true
    bUseHardBaseRate=true
    AlliedAwardedReinforcements=20
    AxisAwardedReinforcements=20
    bUsePostCaptureOperations=true
    bHideCaptureBarRatio=true
}
