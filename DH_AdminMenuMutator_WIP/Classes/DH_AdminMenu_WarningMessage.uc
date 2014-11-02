//=======================================================================================================
// DH_AdminMenu_WarningMessage - by Matt UK
//=======================================================================================================
//
// A warning message sent by an admin, displayed on a parchment-style banner in the centre of the screen
//
//=======================================================================================================
class DH_AdminMenu_WarningMessage extends ROCriticalMessage;


// Localised so different language versions could be produced:
var  localized  string  WarningHeader;
var  localized  string  WarningChatPrefix;


static function string GetString(optional int Switch, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2, optional Object OptionalObject)
{
    local  string  Message;

    if (DH_AdminMenu_Replicator(OptionalObject) != none)
    {
        Message = Caps(default.WarningHeader @ "'" $ RelatedPRI_1.PlayerName $ "'|");
        Message @= "|" $ DH_AdminMenu_Replicator(OptionalObject).PrivateMessage;

        return Message;
    }

    return ""; // just in case something goes wrong we'll return a blank string
}

defaultproperties
{
    WarningHeader="You have received a warning message from admin"
    WarningChatPrefix="ADMIN WARNING from"

    LifeTime=9
    DrawPivot=DP_MiddleMiddle
    StackMode=SM_Up
    PosX=0.43
    PosY=0.4
    bIsConsoleMessage=false
    FontSize=-3
    maxMessageWidth=0.6
    maxMessagesOnScreen=1
}
