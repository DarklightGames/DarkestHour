//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DHSpawnPoint_Parachute extends DHSpawnPointBase;

function OnPawnSpawned(Pawn P)
{
    local DHPawn DHP;

    DHP = DHPawn(P);

    if (DHP != none)
    {
        DHP.GiveChute();
    }

    super.OnPawnSpawned(P);
}

simulated function int GetDesirability()
{
    return 5;
}

defaultproperties
{
    bAirborneSpawn=true
    SpawnLocationOffset=(Z=10000)
    SpawnRadius=1024.0
}
