//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DHEnemyInformationMsg extends LocalMessage
    abstract;

var localized string EnemyIsWeak;
var localized string EnemyIsSurrendering;

static function string GetString(
    optional int Switch,
    optional PlayerReplicationInfo RelatedPRI_1,
    optional PlayerReplicationInfo RelatedPRI_2,
    optional Object OptionalObject)
{
    switch (Switch)
    {
        case 0:
            return default.EnemyIsWeak;
        case 1:
            return default.EnemyIsSurrendering;
        default:
            return default.EnemyIsWeak;
    }
}

defaultproperties
{
    EnemyIsWeak="The enemy is nearly out of reinforcements, victory is near!"
    EnemyIsSurrendering="The enemy is retreating, the battle will be over shortly!"

    bFadeMessage=true
    bIsUnique=true
    bIsConsoleMessage=true
    DrawColor=(R=255,G=0,B=0,A=255)
    FontSize=1
    LifeTime=10
    PosX=0.5
    PosY=0.1
}
