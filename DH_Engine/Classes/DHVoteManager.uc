//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DHVoteManager extends Actor
    notplaceable;

struct NominationBase
{
    var class<DHVoteInfo> VoteClass;
    var byte              TeamIndex;
    var PlayerController  Player;
};

struct CooldownTimesBase
{
    var class<DHVoteInfo> VoteClass;
    var float             Timestamps[2];
};

var private array<DHVoteInfo>        Votes;
var private array<NominationBase>    Nominations;
var private array<CooldownTimesBase> CooldownTimes;

// NOMINATIONS

function AddNomination(PlayerController Player, class<DHVoteInfo> VoteClass)
{
    local DarkestHourGame G;
    local byte TeamIndex;
    local int i;
    local array<PlayerController> PlayerNominators;
    local int NominationsThresholdCount;

    G = DarkestHourGame(Level.Game);

    if (Player == none || G == none || VoteClass == none || !VoteClass.static.CanNominate(Player, G))
    {
        return;
    }

    if (VoteClass.default.bIsGlobalVote)
    {
        TeamIndex = -1;
    }
    else
    {
        TeamIndex = Player.GetTeamNum();

        if (TeamIndex > 1)
        {
            Warn("Failed to nominate the vote. Invalid team index.");
            return;
        }
    }

    // Disallow multiple nominations from the same player
    for (i = 0; i < Nominations.Length; ++i)
    {
        if (Nominations[i].Player == Player && Nominations[i].VoteClass == VoteClass)
        {
            return;
        }
    }

    NominationsThresholdCount = VoteClass.static.GetNominationsThresholdCount(G, TeamIndex);

    if (NominationsThresholdCount < 2)
    {
        // Start the vote right away!
        PlayerNominators[PlayerNominators.Length] = Player;
        VoteClass.static.OnNominated(Player, Level);
        StartVote(VoteClass, TeamIndex, PlayerNominators);
    }
    else
    {
        // Add the nomination
        Nominations.Insert(0, 1);
        Nominations[0].Player = Player;
        Nominations[0].TeamIndex = TeamIndex;
        Nominations[0].VoteClass = VoteClass;

        // Count the nominations and clean up the invalid ones while we at it
        for (i = Nominations.Length - 1; i >= 0; --i)
        {
            if (Nominations[i].VoteClass == VoteClass && Nominations[i].TeamIndex == TeamIndex)
            {
                if (Nominations[i].Player != none &&
                    (Nominations[i].VoteClass.default.bIsGlobalVote ||
                     Nominations[i].Player.GetTeamNum() == Nominations[i].TeamIndex))
                {
                    PlayerNominators[PlayerNominators.Length] = Nominations[i].Player;
                }
                else
                {
                    Nominations.Remove(i, 1);
                }
            }
        }

        if (PlayerNominators.Length >= NominationsThresholdCount)
        {
            // Start the vote!
            VoteClass.static.OnNominated(Player, Level);
            StartVote(VoteClass, TeamIndex, PlayerNominators);
            ClearNominations(VoteClass, TeamIndex);
        }
        else
        {
            // The nomination was successfuly added
            VoteClass.static.OnNominated(Player, Level, NominationsThresholdCount - PlayerNominators.Length);
        }
    }
}

function RemoveNomination(PlayerController Player, class<DHVoteInfo> VoteClass)
{
   local int i;
   local bool bNotified;

   if (Player == none || VoteClass == none)
   {
       return;
   }

    for (i = Nominations.Length - 1; i >= 0; --i)
    {
       if (Nominations[i].VoteClass == VoteClass && Nominations[i].Player == Player)
       {
           // Avoid sending multiple notifications in case we have stale
           // nominations listed
           if (!bNotified)
           {
               VoteClass.static.OnNominationRemoved(Player);
               bNotified = true;
           }

           Nominations.Remove(i, 1);
       }
   }
}

function ClearNominations(class<DHVoteInfo> VoteClass, byte TeamIndex)
{
    local int i;

    if (VoteClass == none)
    {
        return;
    }

    for (i = Nominations.Length - 1; i >= 0; --i)
    {
        if (Nominations[i].VoteClass == VoteClass && Nominations[i].TeamIndex == TeamIndex)
        {
            VoteClass.static.OnNominationRemoved(Nominations[i].Player);
            Nominations.Remove(i, 1);
        }
    }
}

function bool HasPlayerNominatedVote(PlayerController Player)
{
    local int i;

    if (Player == none)
    {
        return false;
    }

    for (i = 0; i < Nominations.Length; ++i)
    {
        if (Nominations[i].Player == Player && (Nominations[i].VoteClass.default.bIsGlobalVote || Nominations[i].TeamIndex == Player.GetTeamNum()))
        {
            return true;
        }
    }
}

// VOTES

function PlayerVoted(PlayerController Voter, int VoteId, int OptionIndex)
{
    local int VoteIndex;

    VoteIndex = GetVoteIndexById(VoteId);

    if (Voter == none || VoteIndex == -1)
    {
        return;
    }

    Votes[VoteIndex].RecieveVote(Voter, OptionIndex);
}

function StartVote(class<DHVoteInfo> VoteClass, byte TeamIndex, optional array<PlayerController> Nominators)
{
    local int i, FreeIndex;
    local DHVoteInfo Vote;

    if (VoteClass == none)
    {
        return;
    }

    Vote = Spawn(VoteClass);

    if (Vote != none)
    {
        FreeIndex = Votes.Length;

        for (i = 0; i < FreeIndex; ++i)
        {
            // TODO: Allow multiple votes of the same type
            if (Votes[i] == Vote && (Vote.bIsGlobalVote || Votes[i].TeamIndex == TeamIndex))
            {
                Warn("Attempted to start a vote that was already in progress");
                return;
            }

            if (Votes[i] == none || Votes[i].bDeleteMe)
            {
                FreeIndex = i;
            }
        }

        Vote.VoteId = FreeIndex;
        Vote.TeamIndex = TeamIndex;
        Vote.Nominators = Nominators;

        Votes[FreeIndex] = Vote;
        AddVoteTime(Vote);
        Vote.StartVote();
    }
    else
    {
        Warn("Failed to spawn the vote");
    }
}

function int GetVoteIndexById(int VoteId)
{
    local int i;

    for (i = 0; i < Votes.Length; ++i)
    {
        if (Votes[i] != none && Votes[i].VoteId == VoteId && !Votes[i].bDeleteMe)
        {
            return i;
        }
    }

    return -1;
}

function int GetVoteIndex(class<DHVoteInfo> VoteClass, optional byte TeamIndex)
{
    local int i;

    for (i = 0; i < Votes.Length; ++i)
    {
        if (Votes[i] != none &&
            Votes[i].Class == VoteClass &&
            !Votes[i].bDeleteMe &&
            (Votes[i].default.bIsGlobalVote || Votes[i].TeamIndex == TeamIndex))
        {
            return i;
        }
    }

    return -1;
}

// VOTE COOLDOWN TIMES

protected function AddVoteTime(DHVoteInfo Vote)
{
    local DHGameReplicationInfo GRI;
    local int i, AddToIndex, TeamIndex, CooldownSeconds;
    local bool bVoteFound;

    GRI = DHGameReplicationInfo(Level.Game.GameReplicationInfo);

    if (GRI == none || Vote == none)
    {
        return;
    }

    CooldownSeconds = Vote.GetCooldownSeconds();

    if (CooldownSeconds <= 0)
    {
        return;
    }

    if (Vote.default.bIsGlobalVote)
    {
        TeamIndex = 0;
    }
    else
    {
        TeamIndex = int(bool(Vote.TeamIndex));
    }

    for (i = 0; i < CooldownTimes.Length; ++i)
    {
        if (CooldownTimes[i].VoteClass == Vote.Class)
        {
            bVoteFound = true;
            AddToIndex = i;
            break;
        }
    }

    if (!bVoteFound)
    {
        CooldownTimes.Insert(0, 1);
        CooldownTimes[0].VoteClass = Vote.Class;
        AddToIndex = 0;
    }

    if (TeamIndex < arraycount(CooldownTimes[AddToIndex].Timestamps))
    {
        CooldownTimes[AddToIndex].Timestamps[TeamIndex] = GRI.ElapsedTime + CooldownSeconds;
    }
    else
    {
        Warn("Failed to add the timestamp");
    }
}

function int GetVoteTime(class<DHVoteInfo> VoteClass, byte TeamIndex)
{
    local int i;

    for (i = 0; i < CooldownTimes.Length; ++i)
    {
        if (CooldownTimes[i].VoteClass != VoteClass)
        {
            continue;
        }

        if (VoteClass.default.bIsGlobalVote || TeamIndex > 1)
        {
            TeamIndex = 0;
        }

        if (TeamIndex < arraycount(CooldownTimes[i].Timestamps))
        {
            return CooldownTimes[i].Timestamps[TeamIndex];
        }
    }
}

defaultproperties
{
    RemoteRole=ROLE_None
    bHidden=true
}
