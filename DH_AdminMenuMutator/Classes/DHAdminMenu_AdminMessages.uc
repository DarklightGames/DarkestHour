//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

// Confirmation prompts or instructions to an admin using various menu options
// Displayed as medium sized red text just below the centre of the screen (a bit less obtrusive)
class DHAdminMenu_AdminMessages extends LocalMessage
    abstract;

var     localized string    EnterNewPlayerName;
var     localized string    EnterPrivateMessage;
var     localized string    EnterWarningMessage;
var     localized string    EnterKickReason;
var     localized string    ConfirmKillPlayer;
var     localized string    ConfirmGagPlayer;
var     localized string    ConfirmSwitchToAlliesRole;
var     localized string    ConfirmSwitchToAxisRole;
var     localized string    ConfirmDropAtObjective;
var     localized string    EnterGridLocation;
var     localized string    ConfirmDropAtCurrentLocation;
var     localized string    ConfirmEnableRealism;
var     localized string    ConfirmDisableRealism;
var     localized string    ConfirmMatchLive;
var     localized string    ConfirmDropAlliesAtObjective;
var     localized string    ConfirmDropAxisAtObjective;
var     localized string    ConfirmDropAllAtObjective;
var     localized string    ConfirmDisableMines;
var     localized string    ConfirmEnableMines;
var     localized string    ConfirmDisableCapProgress;
var     localized string    ConfirmEnableCapProgress;
var     localized string    ConfirmDisablePlayerIcon;
var     localized string    ConfirmEnablePlayerIcon;
var     localized string    ConfirmKillAll;
var     localized string    EnterGameSpeed;
var     localized string    EnterTimeRemaining;
var     localized string    ConfirmToggleAdminCanPause;
var     localized string    DestroyActorInSights;
var     localized string    ChangeAlliesSquadSize;
var     localized string    ChangeAxisSquadSize;
var     localized string    SetGamePasswordText;
var     localized string    ToggleWeaponLockText;
var     localized string    ConfirmDisableRallyPoints;
var     localized string    ConfirmEnableRallyPoints;

static function string GetString(optional int Switch, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2, optional Object OptionalObject)
{
    switch (Switch)
    {
        case 1:
            return default.EnterNewPlayerName;
        case 2:
            return default.EnterPrivateMessage;
        case 3:
            return default.EnterWarningMessage;
        case 4:
            return default.EnterKickReason;
        case 5:
            return default.ConfirmKillPlayer;
        case 6:
            return default.ConfirmSwitchToAlliesRole;
        case 7:
            return default.ConfirmSwitchToAxisRole;
        case 8:
            return default.ConfirmDropAtObjective;
        case 9:
            return default.EnterGridLocation;
        case 10:
            return default.ConfirmDropAtCurrentLocation;
        case 11:
            return default.ConfirmEnableRealism;
        case 12:
            return default.ConfirmDisableRealism;
        case 13:
            return default.ConfirmMatchLive;
        case 14:
            return default.ConfirmDropAlliesAtObjective;
        case 15:
            return default.ConfirmDropAxisAtObjective;
        case 16:
            return default.ConfirmDropAllAtObjective;
        case 17:
            return default.ConfirmDisableMines;
        case 18:
            return default.ConfirmEnableMines;
        case 19:
            return default.ConfirmDisableCapProgress;
        case 20:
            return default.ConfirmEnableCapProgress;
        case 21:
            return default.ConfirmDisablePlayerIcon;
        case 22:
            return default.ConfirmEnablePlayerIcon;
        case 23:
            return default.ConfirmKillAll;
        case 24:
            return default.EnterGameSpeed;
        case 25:
            return default.EnterTimeRemaining;
        case 26:
            return default.ConfirmToggleAdminCanPause;
        case 27:
            return default.DestroyActorInSights;
        case 28:
            return default.ChangeAlliesSquadSize;
        case 29:
            return default.ChangeAxisSquadSize;
        case 30:
            return default.SetGamePasswordText;
        case 31:
            return default.ToggleWeaponLockText;
        case 32:
            return default.ConfirmGagPlayer;
        case 33:
            return default.ConfirmDisableRallyPoints;
        case 34:
            return default.ConfirmEnableRallyPoints;

        default:
            return "";
    }
}

defaultproperties
{
    bFadeMessage=true
    FontSize=-1
    LifeTime=5
    DrawColor=(R=214,G=28,B=36,A=255)
    PosY=0.85

    EnterNewPlayerName="Please enter a new name for the player - then press enter"
    EnterPrivateMessage="Type your private message to the player - then press enter"
    EnterWarningMessage="Type your warning message to the player - then press enter"
    EnterKickReason="Type your kick message to the player - then press enter to KICK them"
    ConfirmKillPlayer="Press enter to confirm you want to KILL this player"
    ConfirmGagPlayer="Press enter to confirm you want to GAG this player"
    ConfirmSwitchToAlliesRole="Press enter to confirm you want to SWITCH this player to a new ALLIES role"
    ConfirmSwitchToAxisRole="Press enter to confirm you want to SWITCH this player to a new AXIS role"
    ConfirmDropAtObjective="Press enter to confirm you want to PARADROP this player at the chosen objective"
    EnterGridLocation="Please specify a grid location (example: for grid E2 keypad 5, enter \"e25\")"
    ConfirmDropAtCurrentLocation="Press enter to confirm you want to PARADROP this player at their CURRENT location"
    ConfirmEnableRealism="Press enter to confirm you want to ENABLE realism mode"
    ConfirmDisableRealism="Press enter to confirm you want to DISABLE realism mode"
    ConfirmMatchLive="Press enter to confirm you want to force realism match LIVE"
    ConfirmDropAlliesAtObjective="Press enter to confirm you want to drop ALL ALLIES at the chosen objective"
    ConfirmDropAxisAtObjective="Press enter to confirm you want to drop ALL AXIS at the chosen objective"
    ConfirmDropAllAtObjective="Press enter to confirm you want to drop ALL PLAYERS at the chosen objective"
    ConfirmDisableMines="Press enter to confirm you want to DISABLE all minefields"
    ConfirmEnableMines="Press enter to confirm you want to RE-ENABLE all minefields"
    ConfirmDisableCapProgress="Press enter to confirm you want to DISABLE the cap progress bar on the map"
    ConfirmEnableCapProgress="Press enter to confirm you want to RE-ENABLE the cap progress bar on the map"
    ConfirmDisablePlayerIcon="Press enter to confirm you want to DISABLE the player location icon on the map"
    ConfirmEnablePlayerIcon="Press enter to confirm you want to RE-ENABLE the player location icon on the map"
    ConfirmKillAll="Press enter to confirm you want to KILL ALL players"
    EnterGameSpeed="Please specify the new game speed multiplier (1 is normal)"
    EnterTimeRemaining="Please specify the new round time remaining (in minutes)"
    ConfirmToggleAdminCanPause="Press enter to confirm you want to toggle 'admin can pause' option"
    DestroyActorInSights="Press enter to confirm you want to DESTROY the actor in your sights"
    ChangeAlliesSquadSize="Please specify the new allied squad size (between 8 and 12, or 0 to reset)"
    ChangeAxisSquadSize="Please specify the new axis squad size (8 and 12, or 0 to reset)"
    SetGamePasswordText="Please specify the new game password"
    ToggleWeaponLockText="Press enter to confirm you want to toggle weapon locking on/off"
    ConfirmDisableRallyPoints="Press enter to confirm you want to DISABLE rally point placement"
    ConfirmEnableRallyPoints="Press enter to confirm you want to RE-ENABLE rally poiint placement"
}
