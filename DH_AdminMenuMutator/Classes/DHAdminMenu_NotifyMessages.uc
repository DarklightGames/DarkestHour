//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

// Messages to notify a player that an admin has done something to them (e.g. killed, switched or dropped) - displayed as large red text in the centre of the screen
class DHAdminMenu_NotifyMessages extends LocalMessage
    abstract;

var     localized string    NotifyRename;
var     localized string    NotifyKill;
var     localized string    NotifyGag;
var     localized string    NotifySwitch;
var     localized string    NotifyParaDrop;
var     localized string    BroadcastMinesDisabled;
var     localized string    BroadcastMinesEnabled;
var     localized string    BroadcastCapProgressDisabled;
var     localized string    BroadcastCapProgressEnabled;
var     localized string    BroadcastPlayerIconDisabled;
var     localized string    BroadcastPlayerIconEnabled;
var     localized string    BroadcastKilledAllPlayers;
var     localized string    BroadcastChangedGameSpeed;
var     localized string    BroadcastSetTimeRemaining;
var     localized string    NotifyToggleAdminCanPause;
var     localized string    BroadcastAlliesSquadSizeChanged;
var     localized string    BroadcastAxisSquadSizeChanged;
var     localized string    BroadcastRallyPointsDisabled;
var     localized string    BroadcastRallyPointsEnabled;

static function string GetString(optional int Switch, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2, optional Object OptionalObject)
{
    local string MessageString, GameSpeedRounded;
    local float  GameSpeed;

    if (Switch >= 100) // a trick of passing changed game speed, as a percentage with 100 added so we know it isn't one of the normal numbered messages
    {
        GameSpeed = float(Switch - 100) / 100.0; // convert to percentage (as float)
        GameSpeedRounded = Left(string(GameSpeed), InStr(string(GameSpeed), ".") + 2); // convert to string, rounded to one decimal place

        if (Right(GameSpeedRounded, 2) == ".0") // if game speed ends in a ".0", trim that off
        {
            GameSpeedRounded = Left(GameSpeedRounded, Len(GameSpeedRounded) - 2);
        }

        class'DH_AdminMenuMutator.DHAdminMenu_Replicator'.static.SetMessageClassLifeTimes(GameSpeed); // adjust LifeTime in all message classes to account for new game speed

        MessageString = Repl(default.BroadcastChangedGameSpeed, "#insert_number#", GameSpeedRounded);
    }
    else
    {
        switch (Switch)
        {
            case 1:
                MessageString = default.NotifyRename;
                break;
            case 2:
                MessageString = default.NotifyKill;
                break;
            case 3:
                MessageString = default.NotifySwitch;
                break;
            case 4:
                MessageString = default.NotifyParaDrop;
                break;
            case 5:
                MessageString = default.BroadcastMinesDisabled;
                break;
            case 6:
                MessageString = default.BroadcastMinesEnabled;
                break;
            case 7:
                MessageString = default.BroadcastCapProgressDisabled;
                break;
            case 8:
                MessageString = default.BroadcastCapProgressEnabled;
                break;
            case 9:
                MessageString = default.BroadcastPlayerIconDisabled;
                break;
            case 10:
                MessageString = default.BroadcastPlayerIconEnabled;
                break;
            case 11:
                MessageString = default.BroadcastKilledAllPlayers;
                break;
            case 12:
                MessageString = default.BroadcastSetTimeRemaining;
                break;
            case 13:
                MessageString = Repl(default.NotifyToggleAdminCanPause, "#bAdminCanPause#", "true");
                break;
            case 14:
                MessageString = Repl(default.NotifyToggleAdminCanPause, "#bAdminCanPause#", "false");
                break;
            case 15:
                MessageString = default.BroadcastAlliesSquadSizeChanged;
                break;
            case 16:
                MessageString = default.BroadcastAxisSquadSizeChanged;
                break;
            case 17:
                MessageString = default.NotifyGag;
                break;
            case 18:
                MessageString = default.BroadcastRallyPointsDisabled;
                break;
            case 19:
                MessageString = default.BroadcastRallyPointsEnabled;
                break;

            default: // just in case something goes wrong we'll return a blank string
                return "";
        }
    }

    if (RelatedPRI_1 != none)
    {
        MessageString @= "'" $ RelatedPRI_1.PlayerName $ "'"; // adds admin's name in single quotes
    }

    return MessageString;
}

defaultproperties
{
    bFadeMessage=true
    LifeTime=8
    DrawColor=(R=214,G=28,B=36,A=255)
    PosY=0.2

    NotifyRename="Your game name has been changed by admin"
    NotifyKill="You've been re-spawned by admin"
    NotifyGag="You've been gagged by admin"
    NotifySwitch="You've been switched to new role or team by admin"
    NotifyParaDrop="You've been para dropped somewhere by admin"
    BroadcastMinesDisabled="All minefields DISABLED by admin"
    BroadcastMinesEnabled="All minefields RE-ENABLED by admin"
    BroadcastCapProgressDisabled="Capture progress bars DISABLED by admin"
    BroadcastCapProgressEnabled="Capture progress bars RE-ENABLED by admin"
    BroadcastPlayerIconDisabled="Player icons on the map DISABLED by admin"
    BroadcastPlayerIconEnabled="Player icons on the map RE-ENABLED by admin"
    BroadcastKilledAllPlayers="All players have been killed by admin"
    BroadcastChangedGameSpeed="Game speed changed to x #insert_number# by admin"
    BroadcastSetTimeRemaining="Remaining round time changed by admin"
    NotifyToggleAdminCanPause="You toggled 'admin can pause' setting to #bAdminCanPause#"
    BroadcastAlliesSquadSizeChanged="Allies squad size has been changed by admin"
    BroadcastAxisSquadSizeChanged="Axis squad size has been changed by admin"
    BroadcastRallyPointsDisabled="Rally point placement is DISABLED by admin"
    BroadcastRallyPointsEnabled="Rally point placement is ENABLED by admin"
}
