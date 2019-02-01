//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2018
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
    bKeepSpawningWithoutReinf=true
    OutOfReinfRoundTime=120
    OutOfReinfLimitForTimeChange=50
}

