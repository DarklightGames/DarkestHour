//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2020
//==============================================================================

class DHGameType_Defence extends DHGameType
    abstract;

defaultproperties
{
    GameTypeName="Defence"
    bUseInfiniteReinforcements=false
    bAreObjectiveSpawnsEnabled=true
    bAreRallyPointsEnabled=false
    bAreConstructionsEnabled=true

    bUseReinforcementWarning=true
    bSquadSpecialRolesOnly=true
    bHasTemporarySpawnVehicles=true
    bOmitTimeAttritionForDefender=true
    bTimeCanChangeAtZeroReinf=false
    bKeepSpawningWithoutReinf=false
    OutOfReinfRoundTime=0
    OutOfReinfLimitForTimeChange=10

    ObjSpawnMinimumDepth=1
}

