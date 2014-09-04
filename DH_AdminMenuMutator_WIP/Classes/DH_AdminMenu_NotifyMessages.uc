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
var(Messages)  localized  string  NotifyKill;
var(Messages)  localized  string  NotifySwitch;
var(Messages)  localized  string  NotifyParaDrop;
var(Messages)  localized  string  BroadcastMinesDisabled;
var(Messages)  localized  string  BroadcastMinesEnabled;
var(Messages)  localized  string  BroadcastTeamSwapover;
var(Messages)  localized  string  BroadcastAllToSameTeam;
var(Messages)  localized  string  BroadcastKilledAllPlayers;
var(Messages)  localized  string  BroadcastCapProgressDisabled;
var(Messages)  localized  string  BroadcastCapProgressEnabled;
var(Messages)  localized  string  BroadcastPlayerIconDisabled;
var(Messages)  localized  string  BroadcastPlayerIconEnabled;

var(Messages)  localized  string  AdminWarningChat; // this one is used for a white chat message, not the large, red, centre-screen notification (just included here for convenience)


static function string GetString(optional int Switch, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2, optional Object OptionalObject)
{
	local  string  MessageString;

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
			MessageString = default.BroadcastTeamSwapover;
			break;
		case 7:
			MessageString = default.BroadcastAllToSameTeam;
			break;
		case 8:
			MessageString = default.BroadcastKilledAllPlayers;
			break;
		case 9:
			MessageString = default.BroadcastCapProgressDisabled;
			break;
		case 10:
			MessageString = default.BroadcastCapProgressEnabled;
			break;
		case 11:
			MessageString = default.BroadcastPlayerIconDisabled;
			break;
		case 12:
			MessageString = default.BroadcastPlayerIconEnabled;
			break;
			
		default: // just in case something goes wrong we'll return a blank string
			return "";
	}

	MessageString @= "'" $ RelatedPRI_1.PlayerName $ "'"; // adds admin's name in single quotes

	return MessageString;
}

defaultproperties
{
     NotifyKill="You have been re-spawned by admin"
     NotifySwitch="You have been switched to a new role or team by admin"
     NotifyParaDrop="You have been para dropped somewhere by admin"
     BroadcastMinesDisabled="All minefields have been DISABLED by admin"
     BroadcastMinesEnabled="All minefields have been RE-ENABLED by admin"
     BroadcastTeamSwapover="Both teams have been swapped over by admin"
     BroadcastAllToSameTeam="All players have been forced to the same team by admin"
     BroadcastKilledAllPlayers="All players have been killed by admin"
     BroadcastCapProgressDisabled="Capture progress indicators have been DISABLED by admin"
     BroadcastCapProgressEnabled="Capture progress indicators have been RE-ENABLED by admin"
     BroadcastPlayerIconDisabled="Player icons on the map have been DISABLED by admin"
     BroadcastPlayerIconEnabled="Player icons on the map have been RE-ENABLED by admin"
     AdminWarningChat="ADMIN MESSAGE from"
     bFadeMessage=True
     Lifetime=8
     DrawColor=(B=36,G=28,R=214)
     PosY=0.200000
}
