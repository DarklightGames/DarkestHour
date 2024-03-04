//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_ModifyRole extends DH_ModifyActors;

var() enum ERoleAction
{
    ACTION_Unlock,
    ACTION_Lock,
} RoleAction;

var() bool bSendMessage;    // Sends a message to the team that the role has been modified.
var() name RoleTag;         // The tag of the role to modify.

event Trigger(Actor Other, Pawn EventInstigator)
{
    local int MessageId;
    local DHRoleInfo RoleInfo;

    foreach AllActors(class'DHRoleInfo', RoleInfo, RoleTag)
    {
        switch (RoleAction)
        {
            case ACTION_Lock:
                RoleInfo.bIsLocked = true;
                MessageId = 25;
                break;
            case ACTION_Unlock:
                RoleInfo.bIsLocked = false;
                MessageId = 26;
                break;
        }
    
        if (bSendMessage)
        {
            class'DarkestHourGame'.static.BroadcastTeamLocalizedMessage(Level, int(RoleInfo.Side), class'DHGameMessage', MessageID,,, RoleInfo);
        }
    }
}

defaultproperties
{
    bSendMessage=true
}