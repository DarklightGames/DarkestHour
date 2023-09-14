//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
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
    bTimeCanChangeAtZeroReinf=true
    bKeepSpawningWithoutReinf=false
    OutOfReinfRoundTime=200
    OutOfReinfLimitForTimeChange=500

    ObjSpawnMinimumDepth=1
}

