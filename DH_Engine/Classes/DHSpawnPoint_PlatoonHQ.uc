//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DHSpawnPoint_PlatoonHQ extends DHSpawnPointBase
    notplaceable;

var float SpawnRadius;
var DHConstruction Construction;

var bool    bIsActivated;
var int     ActivationCounter;
var int     ActivationCounterThreshold;

var float   EncroachmentRadiusInMeters;
var int     EncroachmentPenaltyBlockThreshold;
var int     EncroachmentPenaltyCounter;

var float   CaptureRadiusInMeters;
var int     CaptureCounter;
var int     CaptureCounterThreshold;

var int     SpawnKillPenalty;
var int     SpawnKillPenaltyCounter;

function PostBeginPlay()
{
    super.PostBeginPlay();

    SetTimer(1.0, true);
}

function Timer()
{
    local int EncroachingEnemiesCount;
    local int CapturingEnemiesCount;

    BlockReason = SPBR_None;

    // Spawn kill penalty
    SpawnKillPenaltyCounter = Max(0, SpawnKillPenaltyCounter - 1);

    if (SpawnKillPenaltyCounter > 0)
    {
        BlockReason = SPBR_EnemiesNearby;
    }

    // Activation
    if (!bIsActivated)
    {
        ActivationCounter = Clamp(ActivationCounter + 1, 0, ActivationCounterThreshold);

        if (ActivationCounter < ActivationCounterThreshold)
        {
            BlockReason = SPBR_Constructing;
        }
        else
        {
            bIsActivated = true;

            // "A Platoon HQ has been established."
            BroadcastTeamLocalizedMessage(GetTeamIndex(), class'DHPlatoonHQMessage', 0);
        }
    }

    // Encroachment
    GetPlayerCountsWithinRadius(EncroachmentRadiusInMeters,,, EncroachingEnemiesCount);

    if (EncroachingEnemiesCount > 0)
    {
        EncroachmentPenaltyCounter = Clamp(EncroachmentPenaltyCounter + EncroachingEnemiesCount, 0, EncroachmentPenaltyBlockThreshold);
    }
    else
    {
        EncroachmentPenaltyCounter = 0;
    }

    if (EncroachmentPenaltyCounter >= EncroachmentPenaltyBlockThreshold)
    {
        BlockReason = SPBR_EnemiesNearby;
    }

    // Capturing
    GetPlayerCountsWithinRadius(CaptureRadiusInMeters,,, CapturingEnemiesCount);

    if (CapturingEnemiesCount >= 1)
    {
        // Increment capture counter
        CaptureCounter += CapturingEnemiesCount;

        // If any enemies are capturing, spawning must be disabled.
        BlockReason = SPBR_EnemiesNearby;
    }
    else
    {
        // No enemies capturing, decrement the counter
        CaptureCounter -= 1;
    }

    CaptureCounter = Max(0, CaptureCounter);

    if (CaptureCounter >= CaptureCounterThreshold)
    {
        // "A Platoon HQ has been captured by the enemy."
        BroadcastTeamLocalizedMessage(GetTeamIndex(), class'DHPlatoonHQMessage', 2);

        if (GetTeamIndex() == AXIS_TEAM_INDEX)
        {
            SetTeamIndex(ALLIES_TEAM_INDEX);
        }
        else if (GetTeamIndex() == ALLIES_TEAM_INDEX)
        {
            SetTeamIndex(AXIS_TEAM_INDEX);
        }

        // "An enemy Platoon HQ has been captured."
        BroadcastTeamLocalizedMessage(GetTeamIndex(), class'DHPlatoonHQMessage', 1);
    }
}

function OnTeamIndexChanged()
{
    // Reset activation state and timer
    bIsActivated = false;
    ActivationCounter = 0;

    // Reset spawn kill penalty counter
    SpawnKillPenaltyCounter = 0;

    if (Construction != none)
    {
        Construction.SetTeamIndex(GetTeamIndex());
    }
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

    if (CanSpawnWithParameters(PC.GetTeamNum(), PC.GetRoleIndex(), PC.GetSquadIndex(), PC.VehiclePoolIndex) &&
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

    // TODO: move this radial functionality into a parent class
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

function BroadcastTeamLocalizedMessage(byte Team, class<LocalMessage> MessageClass, int Switch, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2, optional Object OptionalObject)
{
    local PlayerController PC;
    local Controller       C;

    for (C = Level.ControllerList; C != none; C = C.NextController)
    {
        if (C.GetTeamNum() == Team)
        {
            PC = PlayerController(C);

            if (PC != none)
            {
                PC.ReceiveLocalizedMessage(MessageClass, Switch, RelatedPRI_1, RelatedPRI_2, OptionalObject);
            }
        }
    }
}

function OnSpawnKill(Pawn VictimPawn, Controller KillerController)
{
    SpawnKillPenaltyCounter += SpawnKillPenalty;  // TODO: magic number
}

defaultproperties
{
    SpawnRadius=60.0
    bCombatSpawn=true

    ActivationCounterThreshold=60
    EncroachmentRadiusInMeters=50
    EncroachmentPenaltyBlockThreshold=30

    CaptureRadiusInMeters=5
    CaptureCounterThreshold=30

    SpawnKillPenalty=15
}
