//=========================================================================================================
// DH_AdminMenu_NotifyMessages - by Matt UK
//=========================================================================================================
//
// Messages to notify a player that an admin has done something to them (e.g. killed, switched or dropped)
// Displayed as large red text in the centre of the screen
//
//=========================================================================================================
class DH_AdminMenu_NotifyMessages extends LocalMessage;


// Localised so different language versions could be produced:
var  localized  string  NotifyKill;
var  localized  string  NotifySwitch;
var  localized  string  NotifyParaDrop;
var  localized  string  BroadcastMinesDisabled;
var  localized  string  BroadcastMinesEnabled;
var  localized  string  BroadcastCapProgressDisabled;
var  localized  string  BroadcastCapProgressEnabled;
var  localized  string  BroadcastPlayerIconDisabled;
var  localized  string  BroadcastPlayerIconEnabled;
var  localized  string  BroadcastKilledAllPlayers;
var  localized  string  BroadcastChangedGameSpeed;


static function string GetString(optional int Switch, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2, optional Object OptionalObject)
{
    local  string  MessageString;

    if (Switch >= 100) // a trick of passing changed game speed, as a percentage with 100 added so we know it isn't one of the normal numbered messages
    {
        MessageString = Repl(default.BroadcastChangedGameSpeed, "#insert_number#", Switch - 100);
    }
    else
    {
        switch (Switch)
        {
            case 1:
                MessageString = default.NotifyKill;
                break;
            case 2:
                MessageString = default.NotifySwitch;
                break;
            case 3:
                MessageString = default.NotifyParaDrop;
                break;
            case 4:
                MessageString = default.BroadcastMinesDisabled;
                break;
            case 5:
                MessageString = default.BroadcastMinesEnabled;
                break;
            case 6:
                MessageString = default.BroadcastCapProgressDisabled;
                break;
            case 7:
                MessageString = default.BroadcastCapProgressEnabled;
                break;
            case 8:
                MessageString = default.BroadcastPlayerIconDisabled;
                break;
            case 9:
                MessageString = default.BroadcastPlayerIconEnabled;
                break;
            case 10:
                MessageString = default.BroadcastKilledAllPlayers;
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
    Lifetime=8
    DrawColor=(R=214,G=28,B=36,A=255)
    PosY=0.2

    NotifyKill="You have been re-spawned by admin"
    NotifySwitch="You have been switched to a new role or team by admin"
    NotifyParaDrop="You have been para dropped somewhere by admin"
    BroadcastMinesDisabled="All minefields have been DISABLED by admin"
    BroadcastMinesEnabled="All minefields have been RE-ENABLED by admin"
    BroadcastCapProgressDisabled="Capture progress indicators have been DISABLED by admin"
    BroadcastCapProgressEnabled="Capture progress indicators have been RE-ENABLED by admin"
    BroadcastPlayerIconDisabled="Player icons on the map have been DISABLED by admin"
    BroadcastPlayerIconEnabled="Player icons on the map have been RE-ENABLED by admin"
    BroadcastKilledAllPlayers="All players have been killed by admin"
    BroadcastChangedGameSpeed="Game speed has been changed to #insert_number#% by admin"
}
