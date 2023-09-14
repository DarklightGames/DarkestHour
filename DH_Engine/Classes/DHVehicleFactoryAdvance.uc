//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DHVehicleFactoryAdvance extends DHVehicleFactory;

var()       int                         NumPlayersRequired;             // Required players in proximity to spawn
var()       int                         ProximityRadius;                // Proxy radius used to determine spawning or not

function Reset()
{
    TotalSpawnedVehicles = 0;
    Activate(TeamNum);
}

function Timer()
{
    local DHPawn    DHP;
    local int       NumPlayersInRadius;

    foreach RadiusActors(class'DHPawn', DHP, ProximityRadius)
    {
        ++NumPlayersInRadius;
    }

    if (NumPlayersInRadius < NumPlayersRequired)
    {
        return;
    }

    if (bFactoryActive && VehicleCount < MaxVehicleCount && TotalSpawnedVehicles < VehicleRespawnLimit)
    {
        SpawnVehicle();
    }
}

function Activate(ROSideIndex T)
{
    if (!bFactoryActive || TeamNum != T)
    {
        TeamNum = T;
        bFactoryActive = true;
        SpawningBuildEffects = true;
        SetTimer(1.0, true);
    }
}

defaultproperties
{
    bDestroyVehicleWhenInactive=true
    NumPlayersRequired=4
    ProximityRadius=1024
    RespawnTime=30.0
}
