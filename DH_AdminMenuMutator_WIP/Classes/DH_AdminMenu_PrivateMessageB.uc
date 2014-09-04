//==================================================================================================
// DH_AdminMenu_PrivateMessageB - by Matt UK
//==================================================================================================
//
// Optional 2nd part of a private message sent by an admin (for really long messages)
// Displayed as smaller text on a banner in the centre of the screen, underneath the header message
// Longer messages should wrap but the RO code seems a bit hit & miss with really long messages
//
//==================================================================================================
class DH_AdminMenu_PrivateMessageB extends ROCriticalMessage;


static function string GetString(optional int Switch, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2, optional Object OptionalObject)
{
	local  DH_AdminMenu_Replicator  Replicator;
	
	Replicator = DH_AdminMenu_Replicator(OptionalObject);

	// start this 2nd part of the message at the point the whole message was cropped, then continue for up to a further MaxCharactersInMessage (anything beyond that is lost)
	if (Replicator != none)
		return Mid(Replicator.PrivateMessage, Replicator.MaxCharactersInMessage, Replicator.MaxCharactersInMessage);
			
	return ""; // just in case something goes wrong we'll return a blank string
}

defaultproperties
{
     maxMessageWidth=0.600000
     maxMessagesOnScreen=1
     bIsConsoleMessage=False
     Lifetime=13
     DrawPivot=DP_MiddleMiddle
     StackMode=SM_Up
     PosX=0.430000
     PosY=0.600000
     FontSize=-3
}
