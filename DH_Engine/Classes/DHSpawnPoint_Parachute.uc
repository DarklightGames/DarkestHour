//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
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
    SpawnPointStyle="DHParatroopersButtonStyle"

    SpawnLocationOffset=(Z=10000)
    SpawnRadius=1024.0
}
