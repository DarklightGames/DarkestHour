//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2018
//==============================================================================

class DHSpawnPoint_VehiclePool extends DHSpawnPoint;

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

