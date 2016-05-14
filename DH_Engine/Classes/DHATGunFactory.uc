//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DHATGunFactory extends DHVehicleFactory
    abstract;

// Matt: commented out all calls to SetATCannonTeamStatus() or SetATCannonActiveStatus() in the GRI, as as in 6.0 we no longer show AT guns on the map
// So those functions do nothing, except sometimes write "array out of bounds" log errors, as RO's ATCannons array is static & can't cope with more than 14 guns
// Add back if the map feature is re-enabled in a later release

var()   bool        bUseRandomizer;            // whether or not to use the randomization system
var     int         GunIndex;                  // the index of this gun in the GRI ATCannon array which allows it to appear on the situation map.
var()   string      GroupTag;                  // a tag used by the randomizer to spawn at guns by groups
var     bool        bRandomEvaluated;          // whether or not this AT Gun Factory has been evaluated by the randomizer yet
var     bool        bMasterFactory;            // this factory is the master gun factory
var()   int         MaxRandomFactoriesActive;  // the maximum number of AT Gun Factories to have active at one time for a particular Group (based on the grouptag)
var     array<int>  ActivatedIndexes;

// Add this AT gun to the GRI
simulated event PostBeginPlay()
{
    super.PostBeginPlay();

    if (Role == ROLE_Authority)
    {
        GunIndex = ROGameReplicationInfo(Level.Game.GameReplicationInfo).AddATCannon(Location, class<ROVehicle>(VehicleClass).default.VehicleTeam);
    }
}

//===========================================================================================================================================================
// EvaluateRandom
//
// If bUseRandomizer is set to true, this is called on the 1st AT Cannon factory that the game finds during very 1st Reset() at beginning of gameplay.
// Whichever factory is found 1st becomes a "master" factory for all randomization functions. The master then handles activating any other AT Gun factories.
// At the end of each round, the master will reset all the other AT Gun factories & then select a new set of randomly activated AT Gun factories.
// Each GroupTag will have its own master factory.
//===========================================================================================================================================================
function EvaluateRandom()
{
    local DHATGunFactory        GunFactory;
    local array<DHATGunFactory> GunFactories;
    local float                 RandFactor;
    local int                   MaxToSpawn, TotalActive, i;

    if (bRandomEvaluated || !bUseRandomizer)
    {
        return;
    }

    bMasterFactory = true;
    ActivatedIndexes.Length = 0;

    if (MaxRandomFactoriesActive > 0)
    {
        MaxToSpawn = MaxRandomFactoriesActive;
    }

    // Build an array of all of the AT Gun factories with matching group tags
    foreach DynamicActors(class'DHATGunFactory', GunFactory)
    {
        // Must have a group tag set
        if (GunFactory.GroupTag == "" && GunFactory.bUseRandomizer)
        {
            Warn(GunFactory @ " has bUseRandomizer set to true, but GroupTag is empty");
            continue;
        }

        if (GunFactory.GroupTag != "" && GunFactory.GroupTag == GroupTag)
        {
            if (GunFactory != self)
            {
                  GunFactory.SpecialReset();
            }

            GunFactories[GunFactories.Length] = GunFactory;

            if (GunFactory.MaxRandomFactoriesActive > MaxToSpawn)
            {
                 MaxToSpawn = GunFactory.MaxRandomFactoriesActive;
            }

            GunFactory.bRandomEvaluated = true;
        }
    }

    // Calculate the random activation percentage based on how many cannons the mapper wants to spawn & how many total cannons there are in the array
    if (MaxToSpawn > 0)
    {
       RandFactor = Min(MaxToSpawn, GunFactories.Length) / float(GunFactories.Length);
    }

    // Loop through all the the factories found for this group tag & calculate whether or not they should be activated
    for (i = 0; i < GunFactories.Length; ++i)
    {
        if (TotalActive >= MaxToSpawn && MaxToSpawn > 0)
        {
            break;
        }

        if (TotalActive < MaxToSpawn && ((GunFactories.Length - i) - 1) < MaxToSpawn)
        {
           ActivatedIndexes[ActivatedIndexes.Length] = GunFactories[i].GunIndex;
           TotalActive++;
           continue;
        }

        if (MaxToSpawn > 0)
        {
            if (FRand() <= RandFactor)
            {
               ActivatedIndexes[ActivatedIndexes.Length] = GunFactories[i].GunIndex;
               TotalActive++;
               continue;
            }
        }
        else
        {
           ActivatedIndexes[ActivatedIndexes.Length] = GunFactories[i].GunIndex;
           TotalActive++;
           continue;
        }
    }

    bRandomEvaluated = true;

    if (!bUsesSpawnAreas)
    {
        ProcessRandomActivation();
    }
}

// Activates the stored randomly chosen AT Guns - had to separate this out due to needed to delay activation if bUsesSpawnAreas was true
function ProcessRandomActivation()
{
    local DHATGunFactory        GunFactory;
    local array<DHATGunFactory> GunFactories;
    local int                   TempTeam, i, j;

    if (!bMasterFactory)
    {
        return;
    }

    // Build an array of all of the AT Gun factories with matching group tags
    foreach DynamicActors(class'DHATGunFactory', GunFactory)
    {
        if (GunFactory.GroupTag != "" && GunFactory.GroupTag == GroupTag)
        {
            GunFactories[GunFactories.Length] = GunFactory;
        }
    }

    // Loop through the gun factories activating the ones stored in the ActivatedIndexes array
    for (i = 0; i < ActivatedIndexes.Length; ++i)
    {
        for (j = 0; j < GunFactories.Length; ++j)
        {
            if (GunFactories[j].GunIndex == ActivatedIndexes[i])
            {
                TempTeam = class<ROVehicle>(GunFactories[j].VehicleClass).default.VehicleTeam;

                if (TempTeam == AXIS_TEAM_INDEX)
                {
                    GunFactories[j].Activate(AXIS);
                }
                else if (TempTeam == ALLIES_TEAM_INDEX)
                {
                    GunFactories[j].Activate(ALLIES);
                }
                else
                {
                    GunFactories[j].Activate(NEUTRAL);
                }
            }
       }
    }
}

function ActivatedBySpawn(int Team)
{
    if (!bUseRandomizer)
    {
        super.ActivatedBySpawn(Team);
    }
    else if (bUsesSpawnAreas && bUseRandomizer && bMasterFactory)
    {
        ProcessRandomActivation();
    }
}

function Activate(ROSideIndex T)
{
    if (!bFactoryActive || TeamNum != T)
    {
        TeamNum = T;
        bFactoryActive = true;
        SpawningBuildEffects = true;
//      ROGameReplicationInfo(Level.Game.GameReplicationInfo).SetATCannonTeamStatus(GunIndex,T);
//      ROGameReplicationInfo(Level.Game.GameReplicationInfo).SetATCannonActiveStatus(GunIndex, true);
        Timer();
    }
}

/*
function Deactivate()
{
    super.Deactivate();

    if (Role == ROLE_Authority && LastSpawnedVehicle != none && LastSpawnedVehicle.Health <= 0)
    {
        ROGameReplicationInfo(Level.Game.GameReplicationInfo).SetATCannonActiveStatus(GunIndex, false);
    }
}
*/

// Need to handle Reset differently for this actor - if we are using the randomizer, only MasterFactory is reset here & and all other factories are reset by master factory
simulated function Reset()
{
    if (Role == ROLE_Authority)
    {
//      ROGameReplicationInfo(Level.Game.GameReplicationInfo).SetATCannonActiveStatus(GunIndex, false);
    }

    if (!bUsesSpawnAreas && !bUseRandomizer)
    {
        SpawnVehicle();
        TotalSpawnedVehicles = 0;
        Activate(TeamNum);
    }
    else if (bUseRandomizer)
    {
        if (bMasterFactory)
        {
            TotalSpawnedVehicles = 0;
            Deactivate();
            bRandomEvaluated = false;
            EvaluateRandom();
        }
        else if (!bRandomEvaluated)
        {
            TotalSpawnedVehicles = 0;
            Deactivate();
            EvaluateRandom();
        }
    }
    else
    {
        TotalSpawnedVehicles = 0;
        Deactivate();
    }
}

// Used by the randomizer to reset non-master factories
simulated function SpecialReset()
{
    TotalSpawnedVehicles = 0;
    Deactivate();
}

/*
event VehicleDestroyed(Vehicle V) // Matt: deleted as in 6.0 we no longer show AT guns on the map, so this does nothing except maybe write "array out of bounds" log errors
{
    if (TotalSpawnedVehicles >= VehicleRespawnLimit || !bFactoryActive)
    {
        ROGameReplicationInfo(Level.Game.GameReplicationInfo).SetATCannonActiveStatus(GunIndex, false);
    }

    super.VehicleDestroyed(V);
}
*/

defaultproperties
{
    bAllowVehicleRespawn=false
    VehicleRespawnLimit=1
}
