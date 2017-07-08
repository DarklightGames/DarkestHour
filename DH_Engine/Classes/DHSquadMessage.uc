//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2017
//==============================================================================

class DHSquadMessage extends ROGameMessage
    abstract;

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
var localized string SquadRallyPointActiveMessage;
var localized string SquadRallyPointTooCloseMessage;
var localized string SquadRallyPointExhaustedMessage;
var localized string SquadRallyPointNeedSquadmateNearby;
var localized string SquadRallyPointCreatedMessage;
var localized string SquadRallyPointOverrunMessage;
var localized string SquadRallyPointGroundTooSteep;
var localized string SquadRallyPointInMinefield;
var localized string SquadRallyPointInWater;
var localized string SquadRallyPointNotOnFoot;
var localized string SquadRallyPointTooSoon;
var localized string SquadRallyPointAbandoned;
var localized string SquadRallyPointBadLocation;
var localized string SquadRallyPointDestroyed;
var localized string SquadRallyPointAbandonmentWarning;
var localized string SquadRallyPointSwapped;

static function string GetString(optional int S, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2, optional Object OptionalObject)
{
    local int ExtraValue;

    class'UInteger'.static.ToShorts(S, S, ExtraValue);

    switch (S)
    {
        case 30:
            return Repl(default.SquadJoinedMessage, "{0}", RelatedPRI_1.PlayerName);
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
        case 44:
            return default.SquadRallyPointActiveMessage;
        case 45:
            return Repl(default.SquadRallyPointTooCloseMessage, "{0}", ExtraValue);
        case 46:
            return default.SquadRallyPointExhaustedMessage;
        case 47:
            return default.SquadRallyPointNeedSquadmateNearby;
        case 48:
            return Repl(default.SquadRallyPointCreatedMessage, "{0}", ExtraValue);
        case 49:
            return default.SquadRallyPointGroundTooSteep;
        case 50:
            return default.SquadRallyPointInMinefield;
        case 51:
            return default.SquadRallyPointInWater;
        case 52:
            return default.SquadRallyPointNotOnFoot;
        case 53:
            return Repl(default.SquadRallyPointTooSoon, "{0}", ExtraValue);
        case 54:
            return default.SquadRallyPointOverrunMessage;
        case 55:
            return default.SquadRallyPointAbandoned;
        case 56:
            return default.SquadRallyPointBadLocation;
        case 57:
            return default.SquadRallyPointDestroyed;
        case 58:
            return default.SquadRallyPointAbandonmentWarning;
        case 59:
            return default.SquadRallyPointSwapped;
        default:
            break;
    }

    return "";
}

defaultproperties
{
    DrawColor=(R=0,G=252,B=126,A=255)
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
    SquadRallyPointActiveMessage="Your squad has established a new rally point."
    SquadRallyPointTooCloseMessage="You cannot create a rally point so close to an existing one, you must be {0} meters further away."
    SquadRallyPointExhaustedMessage="A squad rally point has been exhausted."
    SquadRallyPointNeedSquadmateNearby="You must have at least one other squadmate nearby to create a squad rally point."
    SquadRallyPointCreatedMessage="You have created a squad rally point. Secure the area with your squad to establish this rally point."
    SquadRallyPointOverrunMessage="A squad rally point has been overrun by enemies."
    SquadRallyPointGroundTooSteep="The ground is too steep to establish a rally point here."
    SquadRallyPointInMinefield="You cannot create a squad rally point in a minefield."
    SquadRallyPointInWater="You cannot create a squad rally point in water."
    SquadRallyPointNotOnFoot="You must be on foot to create a rally point."
    SquadRallyPointTooSoon="You must wait {0} seconds until your squad can create a rally point."
    SquadRallyPointAbandoned="A squad rally point failed to be established because it was abandoned."
    SquadRallyPointBadLocation="A squad rally point cannot be created at this location."
    SquadRallyPointDestroyed="The squad leader has forcibly destroyed a rally point."
    SquadRallyPointAbandonmentWarning="A newly created squad rally point is being abandoned!"
    SquadRallyPointSwapped="The squad leader has forcibly changed the currently active rally point."
}

