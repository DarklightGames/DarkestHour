//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DHSpawnPoint_VehiclePool extends DHSpawnPoint;

var DHSpawnPoint_PlatoonHQ HQSpawnPoint;
var float NextSpawnTime;
var int SpawnTimeInterval;

function Timer()
{
    local DHSpawnPoint_PlatoonHQ SP;

    super.Timer();

    if (HQSpawnPoint == none || !HQSpawnPoint.IsActive() || HQSpawnPoint.IsBlocked())
    {
        HQSpawnPoint = none;

        foreach RadiusActors(Class'DHSpawnPoint_PlatoonHQ', SP, Class'DHUnits'.static.MetersToUnreal(100.0))
        {
            if (SP.GetTeamIndex() == GetTeamIndex() && SP.IsActive() && !SP.IsBlocked())
            {
                HQSpawnPoint = SP;

                // "A Vehicle Pool has been activated."
                Class'DarkestHourGame'.static.BroadcastTeamLocalizedMessage(Level, GetTeamIndex(), Class'DHVehiclePoolMessage', 0);
                break;
            }
        }
    }

    if (HQSpawnPoint == none)
    {
        BlockReason = SPBR_MissingRequirement;
    }
    else if (Level.TimeSeconds < NextSpawnTime)
    {
        BlockReason = SPBR_Waiting;
    }
}

function OnPawnSpawned(Pawn P)
{
    super.OnPawnSpawned(P);

    NextSpawnTime = Level.TimeSeconds + SpawnTimeInterval;
}

function OnSpawnKill(Pawn VictimPawn, Controller KillerController)
{
    local DHConstruction Construction;

    Construction = DHConstruction(Base);

    if (Construction != none)
    {
        // If our tank was spawn killed, just destroy the vehicle pool as it's
        // likely being spawn-camped from afar.
        Construction.BreakMe();
    }
}

defaultproperties
{
    Type=ESPT_Vehicles
    bStatic=false
    bCombatSpawn=true
    bCollideWhenPlacing=false
    bHidden=true
    bIsActive=true
    BaseSpawnTimePenalty=15

    bCanBeEncroachedUpon=true
    EncroachmentRadiusInMeters=150
    EncroachmentPenaltyMax=15
    EncroachmentPenaltyBlockThreshold=1
    EncroachmentEnemyCountMin=1
    EncroachmentPenaltyForgivenessPerSecond=1

    SpawnTimeInterval=10
    SpawnKillProtectionTime=15
}

