//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
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
