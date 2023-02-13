//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DHGameType_Advance extends DHGameType
    abstract;

defaultproperties
{
    GameTypeName="Advance"

    bAreObjectiveSpawnsEnabled=true
    bAreRallyPointsEnabled=true
    bAreConstructionsEnabled=true

    bUseReinforcementWarning=true
    bSquadSpecialRolesOnly=true
    bHasTemporarySpawnVehicles=true
    bOmitTimeAttritionForDefender=true
    bTimeCanChangeAtZeroReinf=true
    bKeepSpawningWithoutReinf=false
    OutOfReinfRoundTime=30
    OutOfReinfLimitForTimeChange=50

    ObjSpawnMinimumDepth=1
}

