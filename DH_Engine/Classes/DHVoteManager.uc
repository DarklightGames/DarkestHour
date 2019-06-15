//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2018
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

function NominateVote(PlayerController Player, class<DHVoteInfo> VoteClass)
{
    local DarkestHourGame G;
    local byte TeamIndex;
    local int i, NominationCount;

    G = DarkestHourGame(Level.Game);

    if (Player == none || G == none || VoteClass == none || !VoteClass.static.CanNominate(Player, G))
    {
        return;
    }

    if (VoteClass.default.bIsGlobal)
    {
        TeamIndex = -1;
    }
    else
    {
        TeamIndex = Player.GetTeamNum();
    }

    if (VoteClass.default.NominationCountThreshold < 2)
    {
        // Skip the nomination process
        StartVote(VoteClass, TeamIndex);
    }
    else
    {
        Nominations.Insert(0, 1);
        Nominations[0].Player = Player;
        Nominations[0].VoteClass = VoteClass;

        VoteClass.static.OnNominated(Player);

        // Count the nominations and clean up invalid ones while we at it
        for (i = 0; i < Nominations.Length; ++i)
        {
            if (Nominations[i].VoteClass == VoteClass && Nominations[i].TeamIndex == TeamIndex)
            {
                if (Nominations[i].VoteClass.default.bIsGlobal || Nominations[i].Player.GetTeamNum() == Nominations[i].TeamIndex)
                {
                    ++NominationCount;
                }
                else
                {
                    Nominations.Remove(i, 1);
                }
            }
        }

        // Start the vote!
        // TODO: Should nominators vote automaticallY?
        if (NominationCount >= VoteClass.default.NominationCountThreshold)
        {
            StartVote(VoteClass, TeamIndex);
            ClearNominations(VoteClass, TeamIndex);
        }
    }
}

function bool HasPlayerNominatedVote(PlayerController Player)
{
    local int i;
    local bool bResult;

    if (Player == none)
    {
        return false;
    }

    for (i = 0; i < Nominations.Length; ++i)
    {
        if (Nominations[i].Player == Player)
        {
            if (Nominations[i].VoteClass.default.bIsGlobal || Nominations[i].TeamIndex == Player.GetTeamNum())
            {
                bResult = true;
            }
            else
            {
                // Player already nominated this vote but must've switched
                // teams. Clean it up.
                RemoveNomination(Player, Nominations[i].VoteClass);
            }
        }
    }

    return bResult;
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

// The consumer of this function is expected to initialize the DHVoteInfo
// actor prior to this being called.
function StartVote(class<DHVoteInfo> VoteClass, byte TeamIndex)
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
            if (Votes[i] == Vote)
            {
                Warn("Attempted to start a vote that was already in progress");
                return;
            }

            if (Votes[i] == none)
            {
                FreeIndex = i;
            }
        }

        Vote.VoteId = FreeIndex;
        Vote.TeamIndex = TeamIndex;
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
        if (Votes[i] != none && Votes[i].VoteId == VoteId)
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
            (Votes[i].default.bIsGlobal || Votes[i].TeamIndex == TeamIndex))
        {
            return i;
        }
    }

    return -1;
}

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

protected function AddVoteTime(DHVoteInfo Vote)
{
    local DHGameReplicationInfo GRI;
    local int i, AddToIndex, TeamIndex;
    local bool bVoteFound;

    GRI = DHGameReplicationInfo(Level.Game.GameReplicationInfo);

    if (GRI == none || Vote.default.CooldownSeconds == 0)
    {
        return;
    }

    // Timestamps for global votes are saved at index 0
    if (Vote.default.bIsGlobal)
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
        // CooldownTimes[AddToIndex].Timestamps[TeamIndex] = 1;
        CooldownTimes[AddToIndex].Timestamps[TeamIndex] = GRI.ElapsedTime + Vote.default.CooldownSeconds;
    }
    else
    {
        Warn("Failed to add vote timestamp");
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

        if (VoteClass.default.bIsGlobal || TeamIndex > 1)
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
