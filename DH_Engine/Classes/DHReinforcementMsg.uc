//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2017
//==============================================================================

class DHReinforcementMsg extends LocalMessage
    abstract;

var localized string ReinforcementsRemaining;
var localized string ReinforcementsDepleted;

static function string GetString(
    optional int Switch,
    optional PlayerReplicationInfo RelatedPRI_1,
    optional PlayerReplicationInfo RelatedPRI_2,
    optional Object OptionalObject)
{
    switch (Switch)
    {
        case 0:
            return default.ReinforcementsDepleted;
        default:
            return Repl(default.ReinforcementsRemaining, "{0}", Switch);
    }
}

defaultproperties
{
    ReinforcementsRemaining="{0}% reinforcements remaining!"
    ReinforcementsDepleted="Reinforcements depleted!"

}
