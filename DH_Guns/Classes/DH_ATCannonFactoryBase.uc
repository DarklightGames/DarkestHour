//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_ATCannonFactoryBase extends DH_VehicleFactory
    abstract;

//==============================================================================
// Variables
//==============================================================================
var()   bool    bUseRandomizer;             // Whether or not to use the randomization system
var     int     GunIndex;                   // The index of this gun in the GRI ATCannon array which allows it to appear on the situation map.
var()   string  GroupTag;                   // A tag used by the randomizer to spawn at guns by groups
var     bool    bRandomEvaluated;           // Whether or not this AT Gun Factory has been evaluated by the randomizer yet
var     bool    bMasterFactory;             // This factory is the master gun factory
var()   int     MaxRandomFactoriesActive;   // The maximum number of AT Gun Factories to have active at one time for a particular Group (based on the grouptag)
var     array<int> ActivatedIndexes;

//==============================================================================
// Functions
//==============================================================================
simulated event PostBeginPlay()
{
    super.PostBeginPlay();

    // Add this AT Gun to the GRI
    if (Role == ROLE_Authority)
    {
        GunIndex = ROGameReplicationInfo(Level.Game.GameReplicationInfo).AddATCannon(Location, class<ROVehicle>(VehicleClass).default.VehicleTeam);
    }
}

//=============================================================================
// EvaluateRandom
//
// This function is called on the very first AT Cannon factory that the game
// finds during the very first Reset() at the beginning of gameplay if
// bUseRandomizer is set to true. Whichever factory is found first becomes a
// sort of "Master" factory for all randomization functions. The master will
// then handle activating any other AT Gun factories. At the end of each
// round, the master will reset all the other AT Gun factories, and then
// select a new set of randomly activated AT Gun factories. Each Grouptag
// will have its own master factory.
//=============================================================================
function EvaluateRandom()
{
    local array<DH_ATCannonFactoryBase> GunFactories;
    local int i;
    local DH_ATCannonFactoryBase GunFactory;
    local int MaxToSpawn;
    local int TotalActive;
    local float RandFactor;

    //log(self$" Evaluate Random");

    if (bRandomEvaluated || !bUseRandomizer)
        return;

    bMasterFactory = true;

    ActivatedIndexes.Length = 0;

    if (MaxRandomFactoriesActive > 0)
    {
         MaxToSpawn = MaxRandomFactoriesActive;
    }

    // Build an Array of all of the AT Gun factories with matching group tags
    foreach DynamicActors(class'DH_ATCannonFactoryBase', GunFactory)
    {
        // Must have a group tag set
        if (GunFactory.GroupTag == "" && GunFactory.bUseRandomizer)
        {
          log("Error - GroupTag not set");
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

    // Calculate the random activation percentage based on how many cannons the mapper
    // wants to spawn and how many total cannons there are in the array.
    if (MaxToSpawn > 0)
    {
       RandFactor = Min(MaxToSpawn,GunFactories.Length)/Float(GunFactories.Length);
    }

    //log(self$" MaxToSpawn = "$MaxToSpawn$" RandFactor = "$RandFactor);

    // Loop through all the the factories found for this group tag and calculate
    // whether or not they should be activated.
    for (i = 0; i < GunFactories.Length; i++)
    {
        //log(self$" total active = "$TotalActive$" i = "$i);

        if (TotalActive >= MaxToSpawn && MaxToSpawn > 0)
        {
            //log(self$" Hit the MaxToSpawn");
            break;
        }

        if (TotalActive < MaxToSpawn && ((GunFactories.Length - i) - 1) < MaxToSpawn)
        {
           ActivatedIndexes[ActivatedIndexes.Length] = GunFactories[i].GunIndex;
           TotalActive++;
           //log(self$" Adding an AT Gun because we're down to the last ones");
           continue;
        }

        if (MaxToSpawn > 0)
        {
            if (FRand() <= RandFactor)
            {
               ActivatedIndexes[ActivatedIndexes.Length] = GunFactories[i].GunIndex;
               TotalActive++;
               //log(self$" Randomly adding ATGun "$i);
               continue;
            }
        }
        else
        {
           ActivatedIndexes[ActivatedIndexes.Length] = GunFactories[i].GunIndex;
           TotalActive++;
           //log(self$" Spawning every ATGun since the limit was set to zero");
           continue;
        }
    }

    //log(self$" Final total active = "$TotalActive);

    bRandomEvaluated = true;

    if (!bUsesSpawnAreas)
        ProcessRandomActivation();
}

// Activates the stored randomly chosen AT Guns. Had to separate this out due to
// needed to delay activation if bUsesSpawnAreas was true.
function ProcessRandomActivation()
{
    local int i,j;
    local array<DH_ATCannonFactoryBase> GunFactories;
    local DH_ATCannonFactoryBase GunFactory;
    local int TempTeam;

    if (!bMasterFactory)
        return;

    // Build an Array of all of the AT Gun factories with matching group tags
    foreach DynamicActors(class'DH_ATCannonFactoryBase', GunFactory)
    {
        // Must have a group tag set
        if (GunFactory.GroupTag == "")
        {
          log("Error - GroupTag not set");
          continue;
        }

        if (GunFactory.GroupTag != "" && GunFactory.GroupTag == GroupTag)
        {
            GunFactories[GunFactories.Length] = GunFactory;
        }
    }

    // Loop through the gun factories activating the ones stored in the ActivatedIndexes array
    for (i = 0; i < ActivatedIndexes.Length; i++)
    {
        for (j = 0; j < GunFactories.Length; j++)
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
        ROGameReplicationInfo(Level.Game.GameReplicationInfo).SetATCannonTeamStatus(GunIndex,T);
        ROGameReplicationInfo(Level.Game.GameReplicationInfo).SetATCannonActiveStatus(GunIndex, true);
        Timer();
    }
}

function Deactivate()
{
    super.Deactivate();

    if (Role == ROLE_Authority && LastSpawnedVehicle != none && LastSpawnedVehicle.Health <= 0)
    {
       ROGameReplicationInfo(Level.Game.GameReplicationInfo).SetATCannonActiveStatus(GunIndex, false);
    }
}

// Need to handle Reset differently for this actor. If we are using the randomizer,
// only the MasterFactory is reset here, and all other factories are reset by
// the master factory.
simulated function Reset()
{
    if (Role == ROLE_Authority)
    {
        ROGameReplicationInfo(Level.Game.GameReplicationInfo).SetATCannonActiveStatus(GunIndex, false);
    }

    //log("Reset got called for "$self);
    if (!bUsesSpawnAreas && !bUseRandomizer)
    {
         //log(self$" spawning vehicle because of reset");
         SpawnVehicle();
         TotalSpawnedVehicles=0;
         Activate(TeamNum);
    }
    else if (bUseRandomizer)
    {
         if (bMasterFactory )
         {
             //log(self$" Resetting mastergun on round end");
             TotalSpawnedVehicles=0;
             Deactivate();
             bRandomEvaluated=false;
             EvaluateRandom();
         }
         else if (!bRandomEvaluated)
         {
             //log(self$" Resetting regular gun");
             TotalSpawnedVehicles=0;
             Deactivate();
             EvaluateRandom();
         }
    }
    else
    {
         TotalSpawnedVehicles=0;
         Deactivate();//bFactoryActive=false;
    }
}

// Used by the randomizer to reset non-Master factories
simulated function SpecialReset()
{
     TotalSpawnedVehicles=0;
     Deactivate();
}

event VehicleDestroyed(Vehicle V)
{
    if (TotalSpawnedVehicles >= VehicleRespawnLimit || !bFactoryActive)
    {
        ROGameReplicationInfo(Level.Game.GameReplicationInfo).SetATCannonActiveStatus(GunIndex, false);
    }

    super.VehicleDestroyed(V);
}

defaultproperties
{
}
