//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DHRoundOverMsg extends RORoundOverMsg
    abstract;

// Overridden to support varying victory music
static simulated function ClientReceive(PlayerController P, optional int Switch, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2, optional Object OptionalObject)
{
    local DH_LevelInfo          DHLI;
    local DHGameReplicationInfo DHGRI;
    local SoundGroup            SoundG;

    // Do not call the super because the RO code is bad and calls the default values of sound and we don't want that

    // This code is taken from LocalMessage as the RO code calls the super and we don't want to break anything
    if (P.myHud != none)
    {
        P.myHUD.LocalizedMessage(default.class, Switch, RelatedPRI_1, RelatedPRI_2, OptionalObject);
    }

    if (P.DemoViewer != none)
    {
        P.DemoViewer.myHUD.LocalizedMessage(default.Class, Switch, RelatedPRI_1, RelatedPRI_2, OptionalObject);
    }

    if (IsConsoleMessage(Switch) && P.Player != none && P.Player.Console != none)
    {
        P.Player.InteractionMaster.Process_Message(Static.GetString(Switch, RelatedPRI_1, RelatedPRI_2, OptionalObject), 6.0, P.Player.LocalInteractions);
    }
    // End super code

    // Modified function code from RO super, check to make sure we were passed the DH_LevelInfo as OptionalObject
    if (P.PlayerReplicationInfo.Team != none && OptionalObject != none)
    {
        DHLI = DH_LevelInfo(OptionalObject);
        DHGRI = DHGameReplicationInfo(P.GameReplicationInfo);

        // Make sure the levelinfo and GRI exist
        if (DHLI == none || DHGRI == none)
        {
            return;
        }

        // Allies Win
        if (Switch == 1)
        {
            // Lets find out if we are dealing with a sound group
            SoundG = SoundGroup(DHLI.AlliesWinsMusic);

            // Check to make sure the sound exists and the index is valid
            if (SoundG != none && DHGRI.AlliesVictoryMusicIndex >= 0 && DHGRI.AlliesVictoryMusicIndex < SoundG.Sounds.Length)
            {
                // A sound group
                P.PlayAnnouncement(SoundG.Sounds[DHGRI.AlliesVictoryMusicIndex], 1, true);
            }
            else
            {
                // A single sound
                P.PlayAnnouncement(DHLI.AlliesWinsMusic, 1, true);
            }
        }
        // Axis Win
        else if (Switch == 0)
        {
            // Lets find out if we are dealing with a sound group
            SoundG = SoundGroup(DHLI.AxisWinsMusic);

            // Check to make sure the sound exists and the index is valid
            if (SoundG != none && DHGRI.AxisVictoryMusicIndex >= 0 && DHGRI.AxisVictoryMusicIndex < SoundG.Sounds.Length)
            {
                // A sound group
                P.PlayAnnouncement(SoundG.Sounds[DHGRI.AxisVictoryMusicIndex], 1, true);
            }
            else
            {
                // A single sound
                P.PlayAnnouncement(DHLI.AxisWinsMusic, 1, true);
            }
        }
        // Neutral Outcome
        else
        {
            // nothing for now
        }
    }
    // No DH_LevelInfo was passed in, so lets operate normally (in case level uses ROLevelInfo)
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
    // WinMusic variables are now defined in DH_LevelInfo with new default that uses groups
    // These are still defined as a backup in case some idiot uses ROLevelInfo
    AxisWinsSound=sound'DH_win.German.DH_German_Win_Theme'
    AlliesWinsSound=sound'DH_win.Allies.DH_Allies_Win_Theme'
}
