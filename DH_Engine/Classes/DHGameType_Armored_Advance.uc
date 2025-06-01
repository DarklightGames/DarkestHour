//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
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

