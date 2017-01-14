//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DHSquadRallyPoint extends Actor;

var DHSquadReplicationInfo SRI;
var int TeamIndex;
var int SquadIndex;
var int RallyIndex;
var int SpawnsRemaining;
var int SpawnKillCount;
var int ActivationTime;

replication
{
    reliable if (Role == ROLE_Authority)
        TeamIndex, SquadIndex, RallyIndex, SpawnsRemaining;
}

function PostBeginPlay()
{
    super.PostBeginPlay();

    if (Role == ROLE_Authority)
    {
        SRI = DarkestHourGame(Level.Game).SquadReplicationInfo;

        if (SRI == none)
        {
            Destroy();
        }

        SetTimer(1.0, true);
    }
}

function Timer()
{
    // TODO: find out if there are enemies nearby; if enemies are nearby for
    // long enough (consistently within ~25m for 15 seconds straight, kill the
    // rally point).
    // TODO: destroy immediately if enemies are within a ~10m radius and are
    // within eyeshot
    // TODO: 3-strike rule for spawn kills on the rally point
    if (HasEnemiesNearby())
    {
    }

    // TODO: find SRI?

    Destroy();
}

function bool HasEnemiesNearby()
{
    local Pawn P;
    local PlayerController PC;

    foreach RadiusActors(class'Pawn', P, class'DHUnits'.static.MetersToUnreal(25))
    {
        if (P == none)
        {
            continue;
        }

        if (P.GetTeamNum() != TeamIndex)
        {
            return true;
        }
    }

    return false;
}

defaultproperties
{
    TeamIndex=-1
    SquadIndex=-1
    RallyIndex=-1
    SpawnsRemaining=15
    SpawnKillCount=0
}

