//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DHColor extends Object
    abstract;

var Color TeamColors[2];
var Color TeamDimmedColors[2];

var Color SquadColor;
var Color SquadDimmedColor;

var Color FriendlyColor;
var Color SelfColor;

var Color AdminColor;
var Color AdminDimmedColor;

defaultproperties
{
    TeamColors(0)=(R=200,G=72,B=72,A=255)       // Crimson
    TeamColors(1)=(R=70,G=118,B=200,A=255)      // Light Blue
    TeamDimmedColors(0)=(R=133,G=46,B=46,A=255) // Crimson (66% Value)
    TeamDimmedColors(1)=(R=47,G=78,B=133,A=255) // Light Blue (66% Value)

    SquadColor=(R=124,G=252,B=0,A=255)          // Greenish
    SquadDimmedColor=(R=62,G=126,B=0,A=255)     // Greenish (50% Value)

    FriendlyColor=(R=0,G=124,B=252,A=255)       // Blueish
    SelfColor=(R=255,G=215,B=0,A=255)           // Yellow

    AdminColor=(R=255,G=165,B=0,A=255)          // Orange
    AdminDimmedColor=(R=128,G=83,B=0,A=255)     // Orange (50% Value)
}
