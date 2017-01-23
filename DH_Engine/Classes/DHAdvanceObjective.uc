//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DHAdvanceObjective extends DHObjective;

// The purpose of this class is to make setup of Advance much easier and faster.  By doing this it also makes it less error prone

// Modified because in Advance game mode whenever an objective is activated, it becomes neutral
function SetActive( bool bActiveStatus )
{
    // This should to be called before the super
    if (bActiveStatus)
    {
        ObjState = OBJ_Neutral;

        if (DarkestHourGame(Level.Game) != none)
        {
            DarkestHourGame(Level.Game).NotifyObjStateChanged();
        }
    }

    super.SetActive(bActiveStatus);
}

defaultproperties
{
    PreventCaptureTime=60
    BaseCaptureRate=0.0055 // 3 minutes (1 / # of seconds)
    MaxCaptureRate=0.0055
    bRecaptureable=true
    bSetInactiveOnClear=true
    bUseHardBaseRate=true
    AlliedAwardedReinforcements=20
    AxisAwardedReinforcements=20
    bUsePostCaptureOperations=true
    bActivateObjByNumOrder=true
    bHideCaptureBarRatio=true
}
