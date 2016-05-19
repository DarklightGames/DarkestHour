//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DHGameMessage extends ROGameMessage;

var localized string VehicleDestroyedMessage;
var localized string VehicleDepletedMessage;
var localized string VehicleArrivedMessage;
var localized string VehicleCutOffMessage;

var localized string SquadJoinedMessage;
var localized string SquadLeftMessage;
var localized string SquadKickedMessage;
var localized string SquadNoLongerLeaderMessage;
var localized string SquadYouAreNowLeaderMessage;
var localized string SquadNewLeaderMessage;
var localized string SquadInviteAlreadyInSquadMessage;
var localized string SquadFullMessage;
var localized string SquadInvitePendingMessage;
var localized string SquadInviteSentMessage;
var localized string SquadNoLeaderMessage;
var localized string SquadLockedMessage;
var localized string SquadUnlockedMessage;
var localized string SquadCreatedMessage;

// This is overridden to change the hard link to ROPlayer that caused a bug where
static function string GetString(optional int Switch, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2, optional Object OptionalObject)
{
    local string S;
    local DHSpawnManager SM;

    switch (Switch)
    {
        case 0:
            return default.OverTimeMessage;
        case 1:
            if (RelatedPRI_1 == none)
            {
                return default.NewPlayerMessage;
            }

            return RelatedPRI_1.PlayerName $ default.EnteredMessage;
        case 2:
            if (RelatedPRI_1 == none)
            {
                return "";
            }

            return RelatedPRI_1.OldName @ default.GlobalNameChange @ RelatedPRI_1.PlayerName;
        case 3:
            if (RelatedPRI_1 == none || OptionalObject == none)
            {
                return "";
            }

            return RelatedPRI_1.PlayerName @ default.NewTeamMessageRussian;
        case 4:
            if (RelatedPRI_1 == none)
            {
                return "";
            }

            return RelatedPRI_1.PlayerName $ default.LeftMessage;
        case 5:
            return default.SwitchLevelMessage;
        case 6:
            return default.FailedTeamMessage;
        case 7:
            return default.MaxedOutMessage;
        case 8:
            return default.NoNameChange;
        case 9:
            return RelatedPRI_1.PlayerName @ default.VoteStarted;
        case 10:
            return default.VotePassed;
        case 11:
            return default.MustHaveStats;
        // German team join message HACK - butto 7/17/03
        case 12:
            if (RelatedPRI_1 == none || OptionalObject == none)
            {
                return "";
            }

            return RelatedPRI_1.PlayerName @ default.NewTeamMessageGerman;
        // FF kill message
        case 13:
            if (RelatedPRI_1 == none)
            {
                return "";
            }

            return RelatedPRI_1.PlayerName @ default.FFKillMessage;
            break;
        // FF boot message
        case 14:
            if (RelatedPRI_1 == none)
            {
                return "";
            }

            return default.FFViolationMessage @ RelatedPRI_1.PlayerName @ default.FFViolationMessageTrailer;
        // FF damage message
        case 15:
            return default.FFDamageMessage;
        // Role change message
        case 16:
            if (RORoleInfo(OptionalObject) == none)
            {
                return "";
            }

            return default.RoleChangeMsg $ RORoleInfo(OptionalObject).default.Article $ RORoleInfo(OptionalObject).default.MyName;
        // Unable to change role message
        case 17:
            if (OptionalObject == none)
            {
                return "";
            }

            return default.MaxRoleMsg $ RORoleInfo(OptionalObject).default.MyName;

        // To forgive type "np" or "forgive" message
        case 18:
            if (RelatedPRI_1 == none)
            {
                return "Someone" @ default.TypeForgiveMessage;
            }
            else
            {
                return RelatedPRI_1.PlayerName @ default.TypeForgiveMessage;
            }
        // Has forgiven message
        case 19:
            if (RelatedPRI_1 == none || RelatedPRI_2 == none)
            {
                return "";
            }

            return RelatedPRI_2.PlayerName @ default.HasForgivenMessage @ RelatedPRI_1.PlayerName;
        // You have logged in as an admin message(used for AdminLoginSilent)
        case 20:
            return default.YouHaveLoggedInAsAdminMsg;
        // You have logged out of admin message(used for AdminLoginSilent)
        case 21:
            return default.YouHaveLoggedOutOfAdminMsg;
        // {0} has joined the squad.
        case 30:
            return Repl(default.SquadJoinedMessage, "{0}", RelatedPRI_1.PlayerName);
        // {0} has left the squad.
        case 31:
            return Repl(default.SquadLeftMessage, "{0}", RelatedPRI_1.PlayerName);
        case 32:
            return default.SquadKickedMessage;
        case 33:
            return default.SquadNoLongerLeaderMessage;
        case 34:
            return default.SquadYouAreNowLeaderMessage;
        case 35:
            return Repl(default.SquadNewLeaderMessage, "{0}", RelatedPRI_1.PlayerName);
        case 36:
            return Repl(default.SquadInviteAlreadyInSquadMessage, "{0}", RelatedPRI_1.PlayerName);
        case 37:
            return default.SquadFullMessage;
        case 38:
            return Repl(default.SquadInvitePendingMessage, "{0}", RelatedPRI_1.PlayerName);
        case 39:
            return Repl(default.SquadInviteSentMessage, "{0}", RelatedPRI_1.PlayerName);
        case 40:
            return default.SquadNoLeaderMessage;
        case 41:
            return default.SquadLockedMessage;
        case 42:
            return default.SquadUnlockedMessage;
        case 43:
            return default.SquadCreatedMessage;
        default:
            break;
    }

    SM = DHSpawnManager(OptionalObject);

    // This is a fairly hacky workaround to the fact that this function can't
    // accept class references as arguments. The remainder of Switch/100
    // is the index into the DHSpawnManager.VehiclePools array.
    if (SM != none)
    {
        if (Switch >= 400)
        {
            S = default.VehicleCutOffMessage;
        }
        else if (Switch >= 300)
        {
            // Vehicle reinforcements have arrived
            S = default.VehicleArrivedMessage;
        }
        else if (Switch >= 200)
        {
            // Vehicle reinforcements have been depleted
            S = default.VehicleDepletedMessage;
        }
        else if (Switch >= 100)
        {
            // Vehicle has been destroyed
            S = default.VehicleDestroyedMessage;
        }

        return Repl(S, "{0}", SM.VehiclePools[Switch % 100].VehicleClass.default.VehicleNameString);
    }

    return "";
}

defaultproperties
{
    VehicleDestroyedMessage="{0} has been destroyed."
    VehicleDepletedMessage="{0} reinforcements have been depleted."
    VehicleArrivedMessage="{0} reinforcements have arrived."
    VehicleCutOffMessage="{0} reinforcements have been cut off."

    SquadJoinedMessage="{0} has joined the squad."
    SquadLeftMessage="{0} has left the squad."
    SquadKickedMessage="You have been kicked from the squad."
    SquadNoLongerLeaderMessage="You are no longer the squad leader."
    SquadYouAreNowLeaderMessage="You are now the squad leader."
    SquadNewLeaderMessage="{0} has become the squad leader."
    SquadInviteAlreadyInSquadMessage="{0} is already in a squad."
    SquadFullMessage="You cannot be send invitations because the squad is full."
    SquadInvitePendingMessage="{0} has already been invited to join a squad. Please try again later."
    SquadInviteSentMessage="{0} has been invited to join the squad."
    SquadNoLeaderMessage="The squad leader has left the squad."
    SquadLockedMessage="The squad has been locked."
    SquadUnlockedMessage="The squad has been unlocked."
    SquadCreatedMessage="You have created a squad."
}
