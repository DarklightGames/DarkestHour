//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================
// This is a generic spawn point. When squads were added, there was a di
//==============================================================================

class DHSpawnPoint_PlatoonHQ extends DHSpawnPointBase
    notplaceable;

var float SpawnRadius;

auto state Establishing
{
    function Timer()
    {
        GotoState('Established');
    }

Begin:
    BlockReason = SPBR_Constructing;
    SetTimer(60.0, true);   // TODO: magic number
}

state Established
{
    function Timer()
    {
        // TODO: check if we are being captured?
    }
Begin:
    BlockReason = SPBR_None;
}

// TODO: Override with different style
simulated function string GetMapStyleName()
{
    if (IsBlocked())
    {
        return "DHSpawnPointBlockedButtonStyle";
    }
    else
    {
        return "DHSpawnButtonStyle";
    }
}

function bool PerformSpawn(DHPlayer PC)
{
    local DarkestHourGame G;
    local vector SpawnLocation;
    local rotator SpawnRotation;

    G = DarkestHourGame(Level.Game);

    if (PC == none || PC.Pawn != none || G == none)
    {
        return false;
    }

    if (CanSpawnWithParameters(GRI, PC.GetTeamNum(), PC.GetRoleIndex(), PC.GetSquadIndex(), PC.VehiclePoolIndex) &&
        GetSpawnPosition(SpawnLocation, SpawnRotation, PC.VehiclePoolIndex))
    {
        if (G.SpawnPawn(PC, SpawnLocation, SpawnRotation, self) == none)
        {
            return false;
        }

        return true;
    }

    return false;
}

function bool GetSpawnPosition(out vector SpawnLocation, out rotator SpawnRotation, int VehiclePoolIndex)
{
    local int i, j;
    local DHPawnCollisionTest CT;
    local vector L;
    local float ArcLength;

    const SEGMENT_COUNT = 8;

    ArcLength = (Pi * 2) / SEGMENT_COUNT;

    j = Rand(SEGMENT_COUNT);

    for (i = 0; i < SEGMENT_COUNT; ++i)
    {
        L = Location;
        L.X += Cos(ArcLength * (i + j) % SEGMENT_COUNT) * SpawnRadius;
        L.Y += Sin(ArcLength * (i + j) % SEGMENT_COUNT) * SpawnRadius;
        L.Z += 10.0 + class'DHPawn'.default.CollisionHeight / 2;

        CT = Spawn(class'DHPawnCollisionTest',,, L);

        if (CT != none)
        {
            break;
        }
    }

    if (CT != none)
    {
        SpawnLocation = L;
        SpawnRotation = Rotation;
        CT.Destroy();
        return true;
    }

    return false;
}

defaultproperties
{
    SpawnRadius=60.0
    bCombatSpawn=true
}
