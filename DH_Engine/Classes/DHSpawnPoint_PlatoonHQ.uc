//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DHSpawnPoint_PlatoonHQ extends DHSpawnPointBase
    notplaceable;

var DHConstruction Construction;

var bool    bIsEstablished;
var int     EstablishmentCounter;
var int     EstablishmentCounterThreshold;

var int     CapturingEnemiesCount;
var float   CaptureRadiusInMeters;
var int     EnemiesNeededToDeconstruct;

function PostBeginPlay()
{
    super.PostBeginPlay();

    SetTimer(1.0, true);
}

function ResetEstablishmentTimer()
{
    bIsEstablished = false;
    EstablishmentCounter = 0;
}

function OnTeamIndexChanged()
{
    // Reset establishment state and timer
    ResetEstablishmentTimer();

    // Reset spawn kill penalty counter
    SpawnKillPenaltyCounter = 0;

    if (Construction != none)
    {
        Construction.SetTeamIndex(GetTeamIndex());
    }
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

    // Establishment
    if (Construction != none && Construction.IsConstructed() && !bIsEstablished)
    {
        EstablishmentCounter = Clamp(EstablishmentCounter + 1, 0, EstablishmentCounterThreshold);

        if (EstablishmentCounter < EstablishmentCounterThreshold)
        {
            BlockReason = SPBR_Constructing;
        }
        else
        {
            bIsEstablished = true;

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

    // Danger Zone
    if (GRI.IsInDangerZone(Location.X, Location.Y, GetTeamIndex()))
    {
        BlockReason = SPBR_EnemiesNearby;
    }
}

simulated function int GetDesirability()
{
    return 3;
}

defaultproperties
{
    SpawnPointStyle="DHPlatoonHQButtonStyle"

    SpawnRadius=60.0
    bCombatSpawn=true
    EstablishmentCounterThreshold=60
    MapIconAttachmentClass=class'DH_Engine.DHMapIconAttachment_SpawnPoint_PlatoonHQ'

    bCanBeEncroachedUpon=true
    EncroachmentRadiusInMeters=50
    EncroachmentPenaltyMax=30
    EncroachmentPenaltyBlockThreshold=30
    EncroachmentSpawnTimePenalty=10
    EncroachmentEnemyCountMin=3
    EncroachmentPenaltyForgivenessPerSecond=10

    BaseSpawnTimePenalty=15

    CaptureRadiusInMeters=5
    EnemiesNeededToDeconstruct=2

    SpawnKillPenalty=30
    SpawnKillPenaltyForgivenessPerSecond=1
}
