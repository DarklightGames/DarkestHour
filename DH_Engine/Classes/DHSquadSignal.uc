//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2022
//==============================================================================

class DHSquadSignal extends Object
    abstract;

var localized string    SignalName;
var Material            MenuIconMaterial;
var Material            WorldIconMaterial;
var float               DurationSeconds;
var color               MyColor;
var bool                bIsUnique;
var bool                bShouldShowLabel;
var bool                bShouldShowDistance;
var float               WorldIconScale;

static function Material GetWorldIconMaterial(optional Object OptionalObject)
{
    return default.WorldIconMaterial;
}

static function Color GetColor(optional Object OptionalObject)
{
    return default.MyColor;
}

// Called when this signal is sent.
static function OnSent(DHPlayer PC, vector Location, optional Object OptionalObject);

defaultproperties
{
    bShouldShowLabel=true
    DurationSeconds=15.0
    WorldIconScale=1.0
}
