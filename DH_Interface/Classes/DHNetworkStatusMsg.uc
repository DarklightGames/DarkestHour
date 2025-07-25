//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DHNetworkStatusMsg extends UT2K4NetworkStatusMsg;

defaultproperties
{
    StatusCodes(12)="AC_SessionBan"
    StatusTitle(12)="Session Kicked"
    StatusMessages(12)="You have been kicked for the remainder of the current level.||If an admin did not punish you, this is the default punishment for team killing, so don't do it."
}
