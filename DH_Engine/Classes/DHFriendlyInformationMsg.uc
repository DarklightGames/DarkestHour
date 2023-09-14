//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DHFriendlyInformationMsg extends LocalMessage
    abstract;

var localized string TeamSurrendered;

static function string GetString(
    optional int Switch,
    optional PlayerReplicationInfo RelatedPRI_1,
    optional PlayerReplicationInfo RelatedPRI_2,
    optional Object OptionalObject)
{
    switch (Switch)
    {
        case 0:
            return default.TeamSurrendered;
        default:
            return "Fatal error!";
    }
}

defaultproperties
{
    TeamSurrendered="Your team has decided to retreat, the battle will be over shortly!"

    bFadeMessage=true
    bIsUnique=true
    bIsConsoleMessage=true
    DrawColor=(R=255,G=255,B=255,A=255)
    FontSize=1
    LifeTime=12
    PosX=0.5
    PosY=0.1
}
