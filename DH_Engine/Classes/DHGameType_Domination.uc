//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================
// Domination round type intended for use on armored maps. The map chooses a
// winner based on the number of objectives held at the end.
//==============================================================================

class DHGameType_Domination extends DHGameType
    abstract;

defaultproperties
{
    GameTypeName="Domination"
    bAreObjectiveSpawnsEnabled=true
    bAreRallyPointsEnabled=true
    bAreConstructionsEnabled=true
    bUseInfiniteReinforcements=true
}
