//=================================================================================================
// DH_AdminMenu_PrivateMessage - by Matt UK
//=================================================================================================
//
// A private message sent by an admin (either an admin warning or other personal message)
// Displayed as smaller text on a banner in the centre of the screen, underneath the header message
// Longer messages should wrap but the RO code seems a bit hit & miss with really long messages
//
//==================================================================================================
class DH_AdminMenu_PrivateMessage extends ROCriticalMessage;


static function string GetString(optional int Switch, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2, optional Object OptionalObject)
{
	local  DH_AdminMenu_Replicator  Replicator;
	
	Replicator = DH_AdminMenu_Replicator(OptionalObject);

	if (Replicator != none)
		return Left(Replicator.PrivateMessage, Replicator.MaxCharactersInMessage); // if the message is very long, crop it to MaxCharactersInMessage set in the mutator
			
	return ""; // just in case something goes wrong we'll return a blank string
}

/* // TEMP - for checking length of message
         10        20         30         40        50         60         70        80         90         100       110        120        130       140        150        160       170        180       190       200       210
Please move well back from the allies spawn, you are way too close. You cannot shoot at targets until they are 150m away from spawn. Th
Please move well back from the allies spawn, you are way too close. You cannot shoot at targets
*/

defaultproperties
{
     maxMessageWidth=0.600000
     maxMessagesOnScreen=1
     bIsConsoleMessage=False
     Lifetime=9
     DrawPivot=DP_MiddleMiddle
     StackMode=SM_Up
     PosX=0.430000
     PosY=0.500000
     FontSize=-3
}
