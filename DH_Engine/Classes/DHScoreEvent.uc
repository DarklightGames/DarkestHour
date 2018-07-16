//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2018
//==============================================================================

class DHScoreEvent extends Object
    abstract;

var localized string            HumanReadableName;
var int                         Value;
var class<DHScoreCategory>      CategoryClass;

defaultproperties
{
    HumanReadableName="Infantry Kill"
    Value=100
    CategoryClass=class'DHScoreCategory_Combat'
}

