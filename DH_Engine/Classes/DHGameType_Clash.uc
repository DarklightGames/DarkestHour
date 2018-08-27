//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2018
//==============================================================================

class DHGameType_Clash extends DHGameType
    abstract;

defaultproperties
{
    GameTypeName="Clash"

    bUseReinforcementWarning=true
    bSquadSpecialRolesOnly=true
    bHasTemporarySpawnVehicles=true

    bTimeCanChangeAtZeroReinf=true
    bKeepSpawningWithoutReinf=true
    OutOfReinfRoundTime=120
    OutOfReinfLimitForTimeChange=50
}
