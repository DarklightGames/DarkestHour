//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2018
//==============================================================================

class DHVoteInfo_TeamSurrender extends Info
    abstract;

var int TeamIndex;

function array<PlayerController> GetVoters()
{
    local array<PlayerController> Voters;
    local Controller C;
    local PlayerController PC;

    for (C = Level.ControllerList; C != none; C = C.nextController)
    {
        if (PC.GetTeamNum() == TeamIndex)
        {
            Voters[Voters.Length] = PC;
        }
    }

    return Voters;
}

