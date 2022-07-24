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
var color               Color;
var bool                bIsUnique;
var bool                bShouldShowLabel;
var bool                bShouldShowDistance;

defaultproperties
{
    bShouldShowLabel=true
    DurationSeconds=15.0
}
