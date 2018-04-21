//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2018
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
    ReinforcementsRemaining="Your team has {0}% reinforcements remaining!"
    ReinforcementsDepleted="Your team has ran out of reinforcements!"

    bBeep=true
    bFadeMessage=true
    bIsUnique=true
    bIsConsoleMessage=true
    DrawColor=(R=255,G=255,B=255,A=255)
    FontSize=1
    LifeTime=12
    PosX=0.5
    PosY=0.1  // used to be 0.5, moved to get it out of the middle
}
