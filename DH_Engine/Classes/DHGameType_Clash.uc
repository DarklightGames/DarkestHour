//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2019
//==============================================================================

class DHGameType_Clash extends DHGameType
    abstract;

defaultproperties
{
    GameTypeName="Clash"

    bAreObjectiveSpawnsEnabled=true
    bAreRallyPointsEnabled=true
    bAreConstructionsEnabled=true

    bUseReinforcementWarning=true
    bSquadSpecialRolesOnly=true
    bHasTemporarySpawnVehicles=true

    bTimeCanChangeAtZeroReinf=false
    bKeepSpawningWithoutReinf=false
    OutOfReinfRoundTime=120
    OutOfReinfLimitForTimeChange=50

    ObjSpawnMinimumDepth=1
}
