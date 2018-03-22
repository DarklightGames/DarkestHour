//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2018
//==============================================================================

class DHSpawnPoint_VehiclePool extends DHSpawnPoint;

// TODO: we have to BLOCK this if there are vehicles nearby

defaultproperties
{
    Type=ESPT_Vehicles
    bStatic=false
    bCombatSpawn=true
    bCollideWhenPlacing=false
    bHidden=false
    bIsActive=true
    BaseSpawnTimePenalty=15
}

