//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DHColor extends Object
    abstract;

var color TeamColors[2];
var color SquadColor;
var color SquadLeaderColor;
var color InputPromptColor;
var color SquadSignalFireColor;
var color SquadSignalMoveColor;
var color SquadOrderAttackColor;
var color SquadOrderDefendColor;

defaultproperties
{
    TeamColors(0)=(R=200,G=72,B=72,A=255)       // Crimson
    TeamColors(1)=(R=151,G=154,B=223,A=255)     // Light Blue
    SquadColor=(R=124,G=252,B=0,A=255)          // Green
    SquadLeaderColor=(R=250,G=250,B=210,A=255)  // Light Goldenrod Yellow
    InputPromptColor=(R=255,G=255,B=0,A=255)    // Yellow

    SquadSignalFireColor=(R=178,G=34,B=34,A=255)    // Firebrick
    SquadSignalMoveColor=(R=186,G=85,B=211,A=255)   // Medium Orchid
    SquadOrderAttackColor=(R=238,G=232,B=170,A=255) // Pale Goldenrod
    SquadOrderDefendColor=(R=173,G=216,B=230,A=255) // Light Blue
}

