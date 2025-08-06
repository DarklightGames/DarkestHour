//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
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

            // "A Command Post has been established."
            Class'DarkestHourGame'.static.BroadcastTeamLocalizedMessage(Level, GetTeamIndex(), Class'DHCommandPostMessage', 0,,, Construction.Class);
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
    if (GRI.IsInDangerZone(Location.X, Location.Y, GetTeamIndex()) && Construction != none)
    {
        Class'DarkestHourGame'.static.BroadcastTeamLocalizedMessage(Level, GetTeamIndex(), Class'DHCommandPostMessage', 5,,, Class);
        Construction.BreakMe();
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
    MapIconAttachmentClass=Class'DHMapIconAttachment_SpawnPoint_PlatoonHQ'

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
