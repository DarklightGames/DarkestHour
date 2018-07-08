//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2018
//==============================================================================

class DHSpawnPoint_VehiclePool extends DHSpawnPoint;

var DHSpawnPoint_PlatoonHQ HQSpawnPoint;

function Timer()
{
    local DHSpawnPoint_PlatoonHQ SP;
    local bool bDidFindActiveUnblockedHQ;

    super.Timer();

    if (HQSpawnPoint == none || !HQSpawnPoint.IsActive() || HQSpawnPoint.IsBlocked())
    {
        HQSpawnPoint = none;

        foreach RadiusActors(class'DHSpawnPoint_PlatoonHQ', SP, class'DHUnits'.static.MetersToUnreal(100.0))    // TODO: Magic number!
        {
            if (SP.GetTeamIndex() == GetTeamIndex() && SP.IsActive() && !SP.IsBlocked())
            {
                HQSpawnPoint = SP;
                break;
            }
        }
    }

    if (HQSpawnPoint == none)
    {
        BlockReason = SPBR_MissingRequirement;
    }
}

function OnSpawnKill(Pawn VictimPawn, Controller KillerController)
{
    local DHConstruction Construction;

    Construction = DHConstruction(Base);

    if (Construction != none)
    {
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
}

