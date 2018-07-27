//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2018
//==============================================================================

class DHGameType_Advance extends DHGameType
    abstract;

defaultproperties
{
    GameTypeName="Advance"

    bUseReinforcementWarning=true
    bSquadSpecialRolesOnly=true
    bHasTemporarySpawnVehicles=true

    bMunitionsDrainOverTime=true
    bTimeChangesAtZeroReinf=true
    bKeepSpawningWithoutReinf=true
    OutOfReinforcementsRoundTime=120
}

