//===============================================================================================
// DH_AdminMenu_AdminMessages - by Matt UK
//===============================================================================================
//
// Confirmation prompts or instructions to an admin using various menu options.
// Displayed as medium sized red text just below the centre of the screen (a bit less obtrusive).
//
//===============================================================================================
class DH_AdminMenu_AdminMessages extends LocalMessage;


// Localised so different language versions could be produced:
var(Messages)  localized  string  EnterPrivateMessage;
var(Messages)  localized  string  EnterWarningMessage;
var(Messages)  localized  string  EnterKickReason;
var(Messages)  localized  string  ConfirmKillPlayer;
var(Messages)  localized  string  ConfirmSwitchToAlliesRole;
var(Messages)  localized  string  ConfirmSwitchToAxisRole;
var(Messages)  localized  string  ConfirmDropAtObjective;
var(Messages)  localized  string  EnterGridLocation;
var(Messages)  localized  string  ConfirmDropAtCurrentLocation;
var(Messages)  localized  string  ConfirmEnableRealism;
var(Messages)  localized  string  ConfirmDisableRealism;
var(Messages)  localized  string  ConfirmMatchLive;
var(Messages)  localized  string  ConfirmDropAlliesAtObjective;
var(Messages)  localized  string  ConfirmDropAxisAtObjective;
var(Messages)  localized  string  ConfirmDropAllAtObjective;
var(Messages)  localized  string  ConfirmDisableMines;
var(Messages)  localized  string  ConfirmEnableMines;
var(Messages)  localized  string  ConfirmDisableCapProgress;
var(Messages)  localized  string  ConfirmEnableCapProgress;
var(Messages)  localized  string  ConfirmDisablePlayerIcon;
var(Messages)  localized  string  ConfirmEnablePlayerIcon;
var(Messages)  localized  string  ConfirmKillAll;
var(Messages)  localized  string  EnterGameSpeed;
var(Messages)  localized  string  DestroyActorInSights;


static function string GetString(optional int Switch, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2, optional Object OptionalObject)
{
    switch (Switch)
    {
        case 1:
            return default.EnterPrivateMessage;
        case 2:
            return default.EnterWarningMessage;
        case 3:
            return default.EnterKickReason;    
        case 4:
            return default.ConfirmKillPlayer;
        case 5:
            return default.ConfirmSwitchToAlliesRole;
        case 6:
            return default.ConfirmSwitchToAxisRole;
        case 7:
            return default.ConfirmDropAtObjective;
        case 8:
            return default.EnterGridLocation;
        case 9:
            return default.ConfirmDropAtCurrentLocation;
        case 10:
            return default.ConfirmEnableRealism;    
        case 11:
            return default.ConfirmDisableRealism;    
        case 12:
            return default.ConfirmMatchLive;
        case 13:
            return default.ConfirmDropAlliesAtObjective;
        case 14:
            return default.ConfirmDropAxisAtObjective;
        case 15:
            return default.ConfirmDropAllAtObjective;
        case 16:
            return default.ConfirmDisableMines;
        case 17:
            return default.ConfirmEnableMines;
        case 18:
            return default.ConfirmDisableCapProgress;
        case 19:
            return default.ConfirmEnableCapProgress;
        case 20:
            return default.ConfirmDisablePlayerIcon;    
        case 21:
            return default.ConfirmEnablePlayerIcon;
        case 22:
            return default.ConfirmKillAll;
        case 23:
            return default.EnterGameSpeed;
        case 24:
            return default.DestroyActorInSights;

        default: // just in case something goes wrong we'll return a blank string
            return "";
    }
}

defaultproperties
{
    bFadeMessage=true
    FontSize=-1
    Lifetime=5
    DrawColor=(R=214,G=28,B=36,A=255)
    PosY=0.85

    EnterPrivateMessage="Type your private message to the player - then press enter"
    EnterWarningMessage="Type your warning message to the player - then press enter"
    EnterKickReason="Type your kick message to the player - then press enter to KICK them"
    ConfirmKillPlayer="Press enter to confirm you want to KILL this player"
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
    DestroyActorInSights="Press enter to confirm you want to DESTROY the actor in your sights"
    
}
