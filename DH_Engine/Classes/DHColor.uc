//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2017
//==============================================================================

class DHColor extends Object
    abstract;

var color TeamColors[2];
var color SquadColor;
var color SquadSignalFireColor;
var color SquadSignalMoveColor;

defaultproperties
{
    TeamColors(0)=(R=200,G=72,B=72,A=255)           // Crimson
    TeamColors(1)=(R=151,G=154,B=223,A=255)         // Light Blue
    SquadColor=(R=124,G=252,B=0,A=255)              // Green

    SquadSignalFireColor=(R=178,G=34,B=34,A=255)    // Firebrick
    SquadSignalMoveColor=(R=186,G=85,B=211,A=255)   // Medium Orchid
}

