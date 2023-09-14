//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DHColor extends Object
    abstract;

var color TeamColors[2];
var color SquadColor;
var color FriendlyColor;

defaultproperties
{
    TeamColors(0)=(R=200,G=72,B=72,A=255)           // Crimson
    TeamColors(1)=(R=70,G=118,B=200,A=255)          // Light Blue
    SquadColor=(R=124,G=252,B=0,A=255)              // Greenish
    FriendlyColor=(R=0,G=124,B=252,A=255)           // Blueish
}

