//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================
class DHSpawnPoint_Objective extends DHSpawnPoint;

var DHObjective Objective;

var bool bHasVehicleLocationHints;

replication
{
    reliable if (bNetDirty && Role == ROLE_Authority)
        bHasVehicleLocationHints;
}

function BuildLocationHintsArrays()
{
    super.BuildLocationHintsArrays();

    bHasVehicleLocationHints = VehicleLocationHints.Length > 0;
}

function Timer()
{
    if (GRI != none && GRI.bIsInSetupPhase)
    {
        BlockReason = SPBR_Waiting;
        return;
    }

    BlockReason = SPBR_None;
}

simulated function bool CanSpawnVehicles()
{
    return bHasVehicleLocationHints;
}

simulated function int GetDesirability()
{
    return 2;
}

defaultproperties
{
    SpawnPointStyle="DHObjectiveSpawnButtonStyle"
    Type=ESPT_All
    bStatic=false
    bCollideWhenPlacing=false
    bHidden=true
}
