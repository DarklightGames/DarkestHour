//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DHSpawnPoint_SquadRallyPoint extends DHSpawnPointComponent;

var DHSquadReplicationInfo SRI;
var int SquadIndex;
var int RallyPointIndex;
var int SpawnsRemaining;
var int SpawnKillCount;
var int ActivationTime;

replication
{
    reliable if (Role == ROLE_Authority)
        SquadIndex, RallyPointIndex, SpawnsRemaining;
}

auto state Constructing
{
Begin:
    Sleep(15);
    GotoState('Active');
}

simulated state Active
{
    event BeginState()
    {
    }
Begin:
}

simulated function bool IsActive()
{
    return super.IsActive() && IsInState('Active');
}

simulated function bool IsBlocked()
{
    return IsInState('Constructing');
}

function bool CanSpawn(DHGameReplicationInfo GRI, int TeamIndex, int RoleIndex, int SquadIndex, int VehiclePoolIndex)
{
    if (!super.CanSpawn(GRI, TeamIndex, RoleIndex, SquadIndex, VehiclePoolIndex))
    {
        return false;
    }

    if (self.SquadIndex != SquadIndex)
    {
        return false;
    }

    return true;
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
//    Destroy();
    }

    // TODO: find SRI?

}

function bool HasEnemiesNearby()
{
    local Pawn P;

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
    StaticMesh=StaticMesh'DH_Military_stc.Parachute.Chute_pack'
    DrawType=DT_StaticMesh
    TeamIndex=-1
    SquadIndex=-1
    RallyPointIndex=-1
    SpawnsRemaining=15
    SpawnKillCount=0
    AmbientSound=Sound'Inf_Player.Gibimpact.Gibimpact'
}

