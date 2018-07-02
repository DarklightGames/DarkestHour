
//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2018
//==============================================================================

class DHSpawnPoint_PlatoonHQ extends DHSpawnPointBase
    notplaceable;

var DHConstruction Construction;

var bool    bIsActivated;
var int     ActivationCounter;
var int     ActivationCounterThreshold;

var int     CapturingEnemiesCount;
var float   CaptureRadiusInMeters;
var int     EnemiesNeededToDeconstruct;

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

function Timer()
{
    super.Timer();

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

    // If the construction is being deconstructed, block spawning.
    if (Construction != none && !Construction.IsConstructed())
    {
        BlockReason = SPBR_Constructing;
    }

    // Capturing
    GetPlayerCountsWithinRadius(CaptureRadiusInMeters,,, CapturingEnemiesCount);

    if (CapturingEnemiesCount >= 1)
    {
        // If any enemies are capturing, spawning must be disabled.
        BlockReason = SPBR_EnemiesNearby;
    }
}

defaultproperties
{
    SpawnRadius=60.0
    bCombatSpawn=true
    ActivationCounterThreshold=60

    bCanBeEncroachedUpon=true
    EncroachmentRadiusInMeters=50
    EncroachmentPenaltyMax=30
    EncroachmentPenaltyBlockThreshold=30
    EncroachmentSpawnTimePenalty=10
    EncroachmentEnemyCountMin=3
    EncroachmentPenaltyForgivenessPerSecond=10

    BaseSpawnTimePenalty=10

    CaptureRadiusInMeters=5
    EnemiesNeededToDeconstruct=2

    SpawnKillPenalty=15
    SpawnKillPenaltyForgivenessPerSecond=1
}
