//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2018
//==============================================================================

class DHGameType_Clash extends DHGameType
    abstract;

defaultproperties
{
    GameTypeName="Clash"

    bAreReserveSpawnsEnabled=true
    bAreRallyPointsEnabled=true
    bAreConstructionsEnabled=true

    bUseReinforcementWarning=true
    bSquadSpecialRolesOnly=true
    bHasTemporarySpawnVehicles=true

    bTimeCanChangeAtZeroReinf=true
    bKeepSpawningWithoutReinf=true
    OutOfReinfRoundTime=120
    OutOfReinfLimitForTimeChange=50
}
