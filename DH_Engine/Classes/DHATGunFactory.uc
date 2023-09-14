//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DHATGunFactory extends DHVehicleFactory
    abstract;

// Option to randomize where AT guns spawn, so it can be different each round:
// Gun factories are grouped together by specifying a matching GroupTag, then only a specified no. of those factories get activated each round, randomly selected each time
// On the initial Reset() at the start of a new map, the 1st group factory to get reset is designated the master factory & acts as a master controller for the group
// The master factory sets up the group & randomly selects which factories are to be activated, recording the information about the group
// When the master is activated it activates the randomly selected factories (note there is one master for each designated gun group)
// If the round is re-started the master makes a new random selection

var()   bool        bUseRandomizer;           // makes this factory part of a randomized AT gun group
var()   string      GroupTag;                 // each factory in a group must have a matching GroupTag
var()   int         MaxRandomFactoriesActive; // the number of gun factories to be activated based on random selection from their group
var()   bool        bOverrideTeamLock;        // use factory value for `bTeamLocked`
var()   bool        bTeamLocked;              // gun can only be used by owning team
var     int         NumToActivate;            // the no. of factories out of the group that are to be randomly selected to be activated
var     bool        bHaveSetupATGunGroup;     // flags that we've already set up our allocated AT gun group
var     bool        bIsMasterFactory;         // flags that this factory is acting as the master gun factory & will control randomization
var     array<int>  SelectedFactoryIndexes;   // array of index numbers of the randomly selected active factories
var     array<DHATGunFactory> GunFactories;   // saved actor references to all gun factories in our group

var()   name        ExitPositionHintTag;      // allow the leveler to define a specific exit position (for guns with tight positioning)

// Modified to handle the randomizer option
// If enabled, we don't activate any factories directly, but just make one factory act as master controller for the group & that handles randomized activation
function Reset()
{
    if (bUseRandomizer)
    {
        if (GroupTag != "")
        {
            // If we haven't already set up the group this must be initial round start Reset() & this is 1st randomized gun factory to get reset
            // So this factory becomes the master & it sets up & controls the group
            if (!bHaveSetupATGunGroup)
            {
                bIsMasterFactory = true;
                SetupATGunGroup();
            }

            // Only the master factory does anything in a randomized group - making the random selection & activating those factories (unless activated by a spawn)
            if (bIsMasterFactory)
            {
                ResetAndRandomizeATGunGroup();

                if (!bUsesSpawnAreas && !bControlledBySpawnPoint)
                {
                    ActivateGroupsSelectedFactories();
                }
            }

            return;
        }
        // Invalid set up by the leveller, so log a fix warning, disable randomization & revert to the Super for a normal factory reset
        else
        {
            Log(Name @ " has bUseRandomizer set to true, but GroupTag is empty!");
            bUseRandomizer = false;
        }
    }

    super.Reset();
}

// New function for the master factory to find & record the randomized AT gun factory group
function SetupATGunGroup()
{
    local DHATGunFactory GunFactory;
    local int            i;

    // Find & build array of all AT Gun factories in this group, & determine how many factories we should randomly select to be activated
    foreach DynamicActors(class'DHATGunFactory', GunFactory)
    {
        if (GunFactory.GroupTag == GroupTag)
        {
            if (GunFactory.bUseRandomizer)
            {
                GunFactories[GunFactories.Length] = GunFactory;
                GunFactory.bHaveSetupATGunGroup = true;

                // Group should all have same specified no. to activate, but just in case we use the highest value found (log fix warning if values differ)
                if (GunFactory.MaxRandomFactoriesActive > NumToActivate)
                {
                    if (NumToActivate > 0)
                    {
                        Log("Randomized AT gun group with GroupTag" @ GroupTag @ "has differing numbers of how many factories are to be randomly activated - needs fixing!");
                    }

                    NumToActivate = GunFactory.MaxRandomFactoriesActive;
                }
            }
            // Invalid set up by the leveller, so log a fix warning & don't include factory in the group
            else
            {
                Log(GunFactory @ "has GroupTag matching randomized AT gun group" @ GroupTag @ "but does not have bUseRandomizer set to true - needs fixing!");
            }
        }
    }

    // Invalid set up by the leveller, so log a fix warning & disable randomization for this group's factories
    if (NumToActivate == 0 || NumToActivate >= GunFactories.Length)
    {
        if (NumToActivate == 0)
        {
            Log("Randomized AT gun group with GroupTag" @ GroupTag @ "does not specify how many are to be randomly activated, so all will activate - needs fixing!");
        }
        else
        {
            Log("Randomized AT gun group with GroupTag" @ GroupTag @ "specifies to activate" @ NumToActivate
                @ "factories but there are only" @ GunFactories.Length @ "factories in the group, so all will activate - needs fixing!");
        }

        for (i = 0; i < GunFactories.Length; ++i)
        {
            GunFactories[i].bUseRandomizer = false;
        }

        bIsMasterFactory = false;
        Reset(); // now that randomization has been removed, do a normal reset on this 1st factory (the others will reset normally afterwards)
    }
}

// New function for the master factory to initially reset all AT gun factories in the group & then randomly select the required no. to be activated
function ResetAndRandomizeATGunGroup()
{
    local array<DHATGunFactory> TempGunFactories;
    local int                   RandomArrayPosition, i;

    // Initially reset all the group factories
    for (i = 0; i < GunFactories.Length; ++i)
    {
        GunFactories[i].TotalSpawnedVehicles = 0;
        GunFactories[i].Deactivate();
    }

    SelectedFactoryIndexes.Length = 0; // clear any previous array
    TempGunFactories = GunFactories;   // make temp copy of GunFactories array so we can alter it without messing up the original

    // Make the specified no. of random selections from temp array, each time removing the selected factory so it can't be chosen again
    for (i = 0; i < NumToActivate; ++i)
    {
        RandomArrayPosition = Rand(TempGunFactories.Length);
        SelectedFactoryIndexes[SelectedFactoryIndexes.Length] = RandomArrayPosition; // add to list of selected factory index positions
        TempGunFactories.Remove(RandomArrayPosition, 1);
    }
}

// New function for the master factory to activate the randomly selected AT gun factories from the group
function ActivateGroupsSelectedFactories()
{
    local DHVehicleFactory GunFactory;
    local ROSideIndex      Side;
    local int              i;

    for (i = 0; i < SelectedFactoryIndexes.Length; ++i)
    {
        GunFactory = GunFactories[SelectedFactoryIndexes[i]];

        if (GunFactory != none && class<ROVehicle>(GunFactory.VehicleClass) != none)
        {
            Side = ROSideIndex(class<ROVehicle>(GunFactory.VehicleClass).default.VehicleTeam);

            if (Side != AXIS && Side != ALLIES)
            {
                Side = NEUTRAL;
            }

            GunFactory.Activate(Side);
        }
    }
}

// Modified to handle the randomizing option
// If randomization enabled we only do anything if we are the master factory for our group, which activates the group's randomly selected factories
function ActivatedBySpawn(int Team)
{
    if (bUseRandomizer)
    {
        if (bIsMasterFactory)
        {
            ActivateGroupsSelectedFactories();
        }
    }
    else
    {
        super.ActivatedBySpawn(Team);
    }
}

function VehicleSpawned(Vehicle V)
{
    local DHATGun Gun;

    super.VehicleSpawned(V);

    Gun = DHATGun(V);

    if (Gun != none)
    {
        Gun.PrependFactoryExitPositions();

        if (bOverrideTeamLock)
        {
            Gun.bTeamLocked = bTeamLocked;
        }
    }
}

defaultproperties
{
    bAllowVehicleRespawn=false
    VehicleRespawnLimit=1
}
