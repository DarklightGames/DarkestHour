//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DHColor extends Object
    abstract;

var Color TeamColors[2];
var Color TeamDarkColors[2];

var Color SquadColor;
var Color SquadDarkColor;

var Color FriendlyColor;
var Color SelfColor;

defaultproperties
{
    TeamColors(0)=(R=200,G=72,B=72,A=255)           // Crimson
    TeamColors(1)=(R=70,G=118,B=200,A=255)          // Light Blue
    TeamDarkColors(0)=(R=133,G=47,B=47,A=255)       // Dimmed Crimson
    TeamDarkColors(1)=(R=46,G=78,B=133,A=255)       // Dimmed Light Blue

    SquadColor=(R=124,G=252,B=0,A=255)              // Greenish
    SquadDarkColor=(R=81,G=166,B=0,A=255)           // Dimmed Greenish

    FriendlyColor=(R=0,G=124,B=252,A=255)           // Blueish
    SelfColor=(R=255,G=215,B=0,A=255)               // Yellow
}
