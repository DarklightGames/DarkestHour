//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2017
//==============================================================================

class DHGameType extends Info
    abstract;

var localized string    GameTypeName;
var bool                bUseInfiniteReinforcements;
var bool                bUseReinforcementWarning;
var bool                bRoundEndsAtZeroReinf;
var bool                bTimeChangesAtZeroReinf;

defaultproperties
{
    GameTypeName="Unknown Game Type"
}
