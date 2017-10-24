//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2017
//==============================================================================

class DHSpawnPoint_PlatoonHQ extends DHSpawnPointBase
    notplaceable;

var DHConstruction Construction;

var bool    bIsActivated;
var int     ActivationCounter;
var int     ActivationCounterThreshold;

var float   EncroachmentRadiusInMeters;
var int     EncroachmentPenaltyBlockThreshold;
var int     EncroachmentPenaltyCounter;
var int     EnemiesNeededToBlock;
var int     EncroachmentSpawnTimePenalty;
var bool    bIsEncroachedUpon;

var float   CaptureRadiusInMeters;
var int     CaptureCounter;
var int     CaptureCounterThreshold;
var int     EnemiesNeededToCapture;

var int     SpawnKillPenalty;
var int     SpawnKillPenaltyCounter;

replication
{
    reliable if (bNetDirty && Role == ROLE_Authority)
        bIsEncroachedUpon;
}

function PostBeginPlay()
{
    super.PostBeginPlay();

    SetTimer(1.0, true);
}

function ResetActivationTimer()
{
    bIsActivated = false;
    ActivationCounter = 0;
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
    if (Construction != none && Construction.IsConstructed() && !bIsActivated)
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
            class'DarkestHourGame'.static.BroadcastTeamLocalizedMessage(Level, GetTeamIndex(), class'DHPlatoonHQMessage', 0);
        }
    }

    // Encroachment
    GetPlayerCountsWithinRadius(EncroachmentRadiusInMeters,,, EncroachingEnemiesCount);

    if (EncroachingEnemiesCount >= EnemiesNeededToBlock)
    {
        EncroachmentPenaltyCounter = Clamp(EncroachmentPenaltyCounter + EncroachingEnemiesCount, 0, EncroachmentPenaltyBlockThreshold);
    }
    else
    {
        EncroachmentPenaltyCounter = 0;
    }

    bIsEncroachedUpon = EncroachmentPenaltyCounter != 0;

    if (EncroachmentPenaltyCounter >= EncroachmentPenaltyBlockThreshold)
    {
        BlockReason = SPBR_EnemiesNearby;
    }

    // Capturing
    GetPlayerCountsWithinRadius(CaptureRadiusInMeters,,, CapturingEnemiesCount);

    if (CapturingEnemiesCount >= 1)
    {
        // If any enemies are capturing, spawning must be disabled.
        BlockReason = SPBR_EnemiesNearby;

        if (CapturingEnemiesCount >= EnemiesNeededToCapture)
        {
            // Increment capture counter
            CaptureCounter += CapturingEnemiesCount;
        }
    }
    else
    {
        // No enemies capturing, decrement the counter
        CaptureCounter -= 1;
    }

    CaptureCounter = Max(0, CaptureCounter);

    if (CaptureCounter >= CaptureCounterThreshold)
    {
        // "A Platoon HQ has been overrun by the enemy."
        class'DarkestHourGame'.static.BroadcastTeamLocalizedMessage(Level, GetTeamIndex(), class'DHPlatoonHQMessage', 2);

        if (Construction != none)
        {
            Construction.GotoState('Broken');
        }
    }

    // If the construction is being deconstructed, block spawning.
    if (Construction != none && !Construction.IsConstructed())
    {
        BlockReason = SPBR_Constructing;
    }
}

function OnTeamIndexChanged()
{
    // Reset activation state and timer
    ResetActivationTimer();

    // Reset spawn kill penalty counter
    SpawnKillPenaltyCounter = 0;

    if (Construction != none)
    {
        Construction.SetTeamIndex(GetTeamIndex());
    }
}

simulated function string GetMapStyleName()
{
    return "DHPlatoonHQButtonStyle";
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

function OnSpawnKill(Pawn VictimPawn, Controller KillerController)
{
    SpawnKillPenaltyCounter += SpawnKillPenalty;
}

simulated function int GetSpawnTimePenalty()
{
    local int Penalty;

    Penalty = BaseSpawnTimePenalty;

    if (bIsEncroachedUpon)
    {
        // If we are being encroached upon, add the spawn timer penalty.
        Penalty += EncroachmentSpawnTimePenalty;
    }

    return Penalty;
}

defaultproperties
{
    SpawnRadius=60.0
    bCombatSpawn=true

    ActivationCounterThreshold=60
    EncroachmentRadiusInMeters=50
    EncroachmentPenaltyBlockThreshold=30
    EncroachmentSpawnTimePenalty=10
    BaseSpawnTimePenalty=5
    EnemiesNeededToBlock=3

    CaptureRadiusInMeters=5
    CaptureCounterThreshold=30
    EnemiesNeededToCapture=2

    SpawnKillPenalty=15
}
