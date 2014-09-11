//=============================================================================
// DHRoundOverMsg
//=============================================================================
// End of round message
//=============================================================================

class DHRoundOverMsg extends RORoundOverMsg;

//-----------------------------------------------------------------------------
// ClientReceive
//-----------------------------------------------------------------------------
// Overridden to support varying victory music
static simulated function ClientReceive(
    PlayerController P,
    optional int Switch,
    optional PlayerReplicationInfo RelatedPRI_1,
    optional PlayerReplicationInfo RelatedPRI_2,
    optional Object OptionalObject
    )
{
    //Do not call the super because the RO code is bad and calls the default values of sound and we don't want that

    //This code is taken from LocalMessage as the RO code calls the super and we don't want to break anything
    if (P.myHud != none)
    {
        P.myHUD.LocalizedMessage(default.Class, Switch, RelatedPRI_1, RelatedPRI_2, OptionalObject);
    }

    if (P.DemoViewer != none)
    {
        P.DemoViewer.myHUD.LocalizedMessage(default.Class, Switch, RelatedPRI_1, RelatedPRI_2, OptionalObject);
    }

    if (IsConsoleMessage(Switch) && P.Player != none && P.Player.Console != none)
    {
        P.Player.InteractionMaster.Process_Message(Static.GetString(Switch, RelatedPRI_1, RelatedPRI_2, OptionalObject), 6.0, P.Player.LocalInteractions);
    }
    //End super code

    //Modified function code from RO super
    if (P.PlayerReplicationInfo.Team != none && OptionalObject != none)
    {
        //Allies Win
        if (Switch == 1)
        {
            P.PlayAnnouncement(DH_LevelInfo(OptionalObject).AlliesWinsMusic, 1, true);
        }
        //Axis Win
        else if (Switch == 0)
        {
            P.PlayAnnouncement(DH_LevelInfo(OptionalObject).AxisWinsMusic, 1, true);
        }
        //Neutral Outcome
        else
        {
            //nothing for now
        }
    }
    //No DH_LevelInfo was passed in, so lets operate normally (in case level uses ROLevelInfo)
    else
    {
        if (Switch == 1)
        {
            P.PlayAnnouncement(default.AlliesWinsSound, 1, true);
        }
        else
        {
            P.PlayAnnouncement(default.AxisWinsSound, 1, true);
        }
    }
}


defaultproperties
{
     //WinMusic variables are now defined in DH_LevelInfo with new default that uses groups
     //These are still defined as a backup in case some idiot uses ROLevelInfo
     AxisWinsSound=Sound'DH_win.German.DH_German_Win_Theme'
     AlliesWinsSound=Sound'DH_win.Allies.DH_Allies_Win_Theme'
}
