//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DHGameType_Armored_Advance extends DHGameType
    abstract;

defaultproperties
{
    GameTypeName="Armored Advance"

    bAreObjectiveSpawnsEnabled=true
    bAreRallyPointsEnabled=true
    bAreConstructionsEnabled=true

	bUseInfiniteReinforcements=true
    bSquadSpecialRolesOnly=true
    bHasTemporarySpawnVehicles=true

    ObjSpawnMinimumDepth=1
}

