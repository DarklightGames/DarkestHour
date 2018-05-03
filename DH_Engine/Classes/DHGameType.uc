//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2018
//==============================================================================

class DHGameType extends Info
    abstract;

var localized string    GameTypeName;
var bool                bUseInfiniteReinforcements;
var bool                bUseReinforcementWarning;
var bool                bRoundEndsAtZeroReinf;
var bool                bTimeChangesAtZeroReinf;
var bool                bSquadSpecialRolesOnly;
var bool                bKeepSpawningWithoutReinf;

var int                 OutOfReinforcementsRoundTime;

defaultproperties
{
    GameTypeName="Unknown Game Type"
}
