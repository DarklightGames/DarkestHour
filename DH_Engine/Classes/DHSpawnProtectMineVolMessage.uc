//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DHSpawnProtectMineVolMessage extends ROMineFieldMsg;

// Modified to be used by a spawn protection minefield for a variety of messages during its initial safe period
// Standard periodic warning message during safe period includes number of safe seconds remaining until minefield goes live (passed as optional Switch function argument)
// Other messages to notify if player leaves minefield during safe period & special warning if pawn in safe period is in 'live' vehicle that will be blown up
static function string GetString(optional int Switch, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2, optional Object OptionalObject)
{
    local DHSpawnProtectMineVolume MineVolume;

    MineVolume = DHSpawnProtectMineVolume(OptionalObject);

    if (MineVolume == none)
    {
        Warn("DHSpawnProtectMineVolMessage message received with no associated DHSpawnProtectMineVolume !");

        return "";
    }

    if (Switch > 0) // if we have a valid number of seconds remaining until MV goes live, give warning message for initial safe period
    {
        return Repl(MineVolume.SafePeriodWarningMessage, "%remaining%", Switch);
    }

    Switch (Switch)
    {
        case 0: // null value means just the standard 'live' minefield warning message
            return MineVolume.WarningMessage;

        case -1: // special Switch value of -1 signifies notification that MV is activated but player will remain safe (applies if leveller has disabled time limit on safe period)
            return MineVolume.SpawnMFActivatedMessage;

        case -2: // special Switch value of -2 signifies notification to player in safe period that they exited MV & it will be live if they go back in
            return MineVolume.ExitedMinefieldMessage;

        case -3: // special Switch value of -3 signifies warning to player in safe period that vehicle they are in is 'live' & will get blown up
            return MineVolume.UnprotectedVehicleWarning;

        default:
            return "";
    }
}

defaultproperties
{
    bIsConsoleMessage=false
}
