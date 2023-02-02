//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

// A private message sent by an admin, displayed on a parchment-style banner toward the top of the screen
class DHAdminMenu_PrivateMessage extends ROCriticalMessage
    abstract;

var     localized string    MessageHeader;
var     localized string    MessageChatPrefix;

static function string GetString(optional int Switch, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2, optional Object OptionalObject)
{
    local string Message;

    if (DHAdminMenu_Replicator(OptionalObject) != none)
    {
        Message = Caps(default.MessageHeader @ "'" $ RelatedPRI_1.PlayerName $ "'|");
        Message @= "|" $ DHAdminMenu_Replicator(OptionalObject).PrivateMessage;

        return Message;
    }

    return ""; // just in case something goes wrong we'll return a blank string
}

defaultproperties
{
    MessageHeader="You have received a private message from admin"
    MessageChatPrefix="ADMIN MESSAGE from"

    LifeTime=9
    DrawPivot=DP_MiddleMiddle
    StackMode=SM_Up
    PosX=0.43
    PosY=0.1
    bIsConsoleMessage=false
    FontSize=-3
    maxMessageWidth=0.6
    maxMessagesOnScreen=1
}
