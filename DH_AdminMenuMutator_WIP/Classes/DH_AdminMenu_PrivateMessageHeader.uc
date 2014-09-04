//=====================================================================================
// DH_AdminMenu_PrivateMessageHeader - by Matt UK
//=====================================================================================
//
// A header to a private message sent by an admin, including the admin's name
// Displayed as medium sized text on a banner just above the centre of the screen
//
//=====================================================================================
class DH_AdminMenu_PrivateMessageHeader extends ROCriticalMessage;


// Localised so different language versions could be produced
var  localized  string  MessageNotify;
var  localized  string  WarningNotify;


static function string GetString(optional int Switch, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2, optional Object OptionalObject)
{
	if (Switch == 1)
		return Caps(default.WarningNotify @ "'" $ RelatedPRI_1.PlayerName $ "'");

	return Caps(default.MessageNotify @ "'" $ RelatedPRI_1.PlayerName $ "'");
}

defaultproperties
{
     MessageNotify="You have received a private message from admin"
     WarningNotify="You have received a warning message from admin"
     maxMessageWidth=0.600000
     maxMessagesOnScreen=1
     bIsConsoleMessage=False
     Lifetime=5
     DrawPivot=DP_MiddleMiddle
     StackMode=SM_Up
     PosX=0.430000
     PosY=0.400000
}
