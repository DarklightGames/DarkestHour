//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DHSquadMessage extends LocalMessage
    abstract;

var localized string JoinedMessage;
var localized string LeftMessage;
var localized string KickedMessage;
var localized string NoLongerLeaderMessage;
var localized string YouAreNowLeaderMessage;
var localized string NewLeaderMessage;
var localized string InviteAlreadyInSquadMessage;
var localized string FullMessage;
var localized string InvitePendingMessage;
var localized string InviteSentMessage;
var localized string NoLeaderMessage;
var localized string LockedMessage;
var localized string UnlockedMessage;
var localized string CreatedMessage;
var localized string RallyPointActiveMessage;
var localized string RallyPointTooCloseMessage;
var localized string RallyPointExhaustedMessage;
var localized string RallyPointNeedSquadmateNearby;
var localized string RallyPointCreatedMessage;
var localized string RallyPointOverrunMessage;
var localized string RallyPointGroundTooSteep;
var localized string RallyPointInMinefield;
var localized string RallyPointInWater;
var localized string RallyPointNotOnFoot;
var localized string RallyPointTooSoon;
var localized string RallyPointAbandoned;
var localized string RallyPointBadLocation;
var localized string RallyPointRemoved;
var localized string RallyPointAbandonmentWarning;
var localized string RallyPointSwapped;
var localized string RallyPointTooCloseToConstruction;
var localized string RallyPointDestroyed;
var localized string RallyPointInUncontrolledObjective;
var localized string RallyPointExposed;
var localized string RallyPointBehindEnemyLines;
var localized string BannedPlayer;
var localized string BannedCannotJoin;
var localized string AutoJoinFailed;
var localized string YouLeft;
var localized string YouVolunteeredToBeSquadLeader;
var localized string NoVolunteers;
var localized string NoVolunteersDisbanded;
var localized string AlreadyInSquad;
var localized string YouAreNowAssistantMessage;
var localized string YouAreNoLongerAssistantMessage;
var localized string NewAssistantMessage;
var localized string NotInSquadMessage;
var localized string SquadMergedSourceMessage;
var localized string SquadMergedSourceGenericMessage;
var localized string SquadMergedDestinationMessage;
var localized string SquadMergeRequestDeniedMessage;
var localized string SquadMergeRequestDeniedGenericMessage;
var localized string SquadMergeFailedMessage;
var localized string SquadTargetSelectionRefused;

static function string GetString(optional int S, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2, optional Object OptionalObject)
{
    local int ExtraValue;
    local DHConstruction C;
    local DHSquadReplicationInfo SRI;
    local string SquadName;

    class'UInteger'.static.ToShorts(S, S, ExtraValue);

    switch (S)
    {
        case 30:
            return Repl(default.JoinedMessage, "{0}", RelatedPRI_1.PlayerName);
        case 31:
            return Repl(default.LeftMessage, "{0}", RelatedPRI_1.PlayerName);
        case 32:
            return default.KickedMessage;
        case 33:
            return default.NoLongerLeaderMessage;
        case 34:
            return default.YouAreNowLeaderMessage;
        case 35:
            return Repl(default.NewLeaderMessage, "{0}", RelatedPRI_1.PlayerName);
        case 36:
            return Repl(default.InviteAlreadyInSquadMessage, "{0}", RelatedPRI_1.PlayerName);
        case 37:
            return default.FullMessage;
        case 38:
            return Repl(default.InvitePendingMessage, "{0}", RelatedPRI_1.PlayerName);
        case 39:
            return Repl(default.InviteSentMessage, "{0}", RelatedPRI_1.PlayerName);
        case 40:
            return default.NoLeaderMessage;
        case 41:
            return default.LockedMessage;
        case 42:
            return default.UnlockedMessage;
        case 43:
            return default.CreatedMessage;
        case 44:
            return default.RallyPointActiveMessage;
        case 45:
            return Repl(default.RallyPointTooCloseMessage, "{0}", ExtraValue);
        case 46:
            return default.RallyPointExhaustedMessage;
        case 47:
            return default.RallyPointNeedSquadmateNearby;
        case 48:
            return Repl(default.RallyPointCreatedMessage, "{0}", ExtraValue);
        case 49:
            return default.RallyPointGroundTooSteep;
        case 50:
            return default.RallyPointInMinefield;
        case 51:
            return default.RallyPointInWater;
        case 52:
            return default.RallyPointNotOnFoot;
        case 53:
            return Repl(default.RallyPointTooSoon, "{0}", ExtraValue);
        case 54:
            return default.RallyPointOverrunMessage;
        case 55:
            return default.RallyPointAbandoned;
        case 56:
            return default.RallyPointBadLocation;
        case 57:
            return default.RallyPointRemoved;
        case 58:
            return default.RallyPointAbandonmentWarning;
        case 59:
            return default.RallyPointSwapped;
        case 60:
            C = DHConstruction(OptionalObject);
            if (C != none)
            {
                return Repl(default.RallyPointTooCloseToConstruction, "{0}", C.MenuName);
            }
            else
            {
                return default.RallyPointBadLocation;
            }
        case 61:
            return Repl(default.BannedPlayer, "{0}", RelatedPRI_1.PlayerName);
        case 62:
            return default.BannedCannotJoin;
        case 63:
            return default.AutoJoinFailed;
        case 64:
            return default.YouLeft;
        case 65:
            return default.YouVolunteeredToBeSquadLeader;
        case 66:
            return default.NoVolunteers;
        case 67:
            return default.NoVolunteersDisbanded;
        case 68:
            return default.RallyPointDestroyed;
        case 69:
            return default.AlreadyInSquad;
        case 70:
            return default.YouAreNowAssistantMessage;
        case 71:
            return default.YouAreNoLongerAssistantMessage;
        case 72:
            return Repl(default.NewAssistantMessage, "{0}", RelatedPRI_1.PlayerName);
        case 73:
            return class'ROTeamGame'.static.ParseLoadingHintNoColor(default.NotInSquadMessage, PlayerController(OptionalObject));
        case 74:
            SRI = DHSquadReplicationInfo(OptionalObject);
            if (SRI != none || RelatedPRI_1 != none || RelatedPRI_1.Team != none)
            {
                SquadName = SRI.GetSquadName(RelatedPRI_1.Team.TeamIndex, ExtraValue);
                return Repl(Repl(default.SquadMergedSourceMessage, "{0}", SquadName), "{1}", RelatedPRI_1.PlayerName);
            }
            else
            {
                return default.SquadMergedSourceGenericMessage;
            }
        case 75:
            return default.SquadMergedDestinationMessage;
        case 76:
            SRI = DHSquadReplicationInfo(OptionalObject);
            if (SRI != none)
            {
                SquadName = SRI.GetSquadName(RelatedPRI_1.Team.TeamIndex, ExtraValue);
                return Repl(default.SquadMergeRequestDeniedMessage, "{0}", SquadName);
            }
            return default.SquadMergeRequestDeniedGenericMessage;
        case 77:
            return default.SquadMergeFailedMessage;
        case 78:
            return default.RallyPointInUncontrolledObjective;
        case 79:
            return default.RallyPointExposed;
        case 80:
            return default.RallyPointBehindEnemyLines;
        case 81:
            return default.SquadTargetSelectionRefused;
        default:
            break;
    }

    return "";
}

defaultproperties
{
    DrawColor=(R=0,G=252,B=126,A=255)
    JoinedMessage="{0} has joined the squad."
    LeftMessage="{0} has left the squad."
    KickedMessage="You have been kicked from the squad."
    NoLongerLeaderMessage="You are no longer the squad leader."
    YouAreNowLeaderMessage="You are now the squad leader."
    NewLeaderMessage="{0} has become the squad leader."
    InviteAlreadyInSquadMessage="{0} is already in a squad."
    FullMessage="You cannot be send invitations because the squad is full."
    InvitePendingMessage="{0} has already been invited to join a squad. Please try again later."
    InviteSentMessage="{0} has been invited to join the squad."
    NoLeaderMessage="The squad leader has left the squad."
    LockedMessage="The squad has been locked."
    UnlockedMessage="The squad has been unlocked."
    CreatedMessage="You have created a squad."
    RallyPointActiveMessage="Your squad has established a new rally point."
    RallyPointTooCloseMessage="You cannot create a rally point so close to an existing one, you must be {0} meters further away."
    RallyPointExhaustedMessage="A squad rally point has been exhausted."
    RallyPointNeedSquadmateNearby="You must have at least one other squadmate nearby to create a squad rally point."
    RallyPointCreatedMessage="You have created a squad rally point. Secure the area with your squad to establish this rally point."
    RallyPointOverrunMessage="A squad rally point has been overrun by enemies."
    RallyPointGroundTooSteep="The ground is too steep to establish a rally point here."
    RallyPointInMinefield="You cannot create a squad rally point in a minefield."
    RallyPointInWater="You cannot create a squad rally point in water."
    RallyPointNotOnFoot="You must be on foot to create a rally point."
    RallyPointTooSoon="You must wait {0} seconds until your squad can create a rally point."
    RallyPointAbandoned="A squad rally point failed to be established because it was abandoned."
    RallyPointBadLocation="A squad rally point cannot be created at this location."
    RallyPointRemoved="The squad leader has forcibly removed a rally point."
    RallyPointAbandonmentWarning="A newly created squad rally point is being abandoned!"
    RallyPointSwapped="The squad leader has forcibly changed the currently active rally point."
    RallyPointTooCloseToConstruction="You cannot create a squad rally point so close to a {0}."
    RallyPointDestroyed="A squad rally point has been destroyed."
    RallyPointInUncontrolledObjective="You cannot create a squad rally point inside an uncontrolled objective."
    RallyPointExposed="A squad rally point has been spotted by the enemy!"
    RallyPointBehindEnemyLines="A squad rally point cannot be created in enemy-controlled territory."
    BannedPlayer="{0} has been banned from the squad."
    BannedCannotJoin="You are unable to join this squad as you have been banned."
    AutoJoinFailed="There are no squads that you are eligible to join."
    YouLeft="You have left the squad."
    YouVolunteeredToBeSquadLeader="You have volunteered to be the squad leader. The new squad leader will be selected shortly."
    NoVolunteers="No members volunteered to be squad leader."
    NoVolunteersDisbanded="Your squad has been disbanded because the squad is too small and no members volunteered to be squad leader."
    AlreadyInSquad="You are already in a squad."
    YouAreNowAssistantMessage="You are now the squad leader's assistant."
    YouAreNoLongerAssistantMessage="You are no longer the squad leader's assistant."
    NewAssistantMessage="{0} has been promoted to squad leader's assistant."
    NotInSquadMessage="You are not in a squad. Press [%SQUADMENU%] to enter the squad menu or press [%SQUADJOINAUTO%] to automatically join a squad."
    SquadMergedSourceMessage="Your squad has been merged into {0} squad. Your new squad leader is {1}."
    SquadMergedDestinationMessage="Another squad has been merged into your squad."
    SquadMergedSourceGenericMessage="Your squad has been merged into another squad."
    SquadMergeRequestDeniedMessage="Your squad merge request was denied by {0} squad."
    SquadMergeRequestDeniedGenericMessage="Your squad merge was denied."
    SquadMergeFailedMessage="The squad merge failed,"
    SquadTargetSelectionRefused="You are an artillery spotter. You cannot switch the active artillery target to your own marker."

    bIsSpecial=false
    bIsConsoleMessage=true
    LifeTime=8.0
}
