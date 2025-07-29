//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================
// States:
// MSAT_Blurry,            // Component has no focus at all
// MSAT_Watched,           // Component is being watched (ie: Mouse is hovering over, etc)
// MSAT_Focused,           // Component is Focused (ie: selected)
// MSAT_Pressed,           // Component is being pressed
// MSAT_Disabled,          // Component is disabled.
//==============================================================================

class DHStyle_MenuTextButton extends GUIStyles;

defaultproperties
{
    KeyName="DHMenuTextButtonStyle"
    
    // Small
    FontNames(0)="DHButtonFont"   // Blurry
    FontNames(1)="DHButtonFont"   // Watched
    FontNames(2)="DHButtonFont"   // Focused
    FontNames(3)="DHButtonFont"   // Pressed
    FontNames(4)="DHButtonFont"   // Disabled

    // Medium
    FontNames(5)="DHButtonFont"   // Blurry
    FontNames(6)="DHButtonFont"   // Watched
    FontNames(7)="DHButtonFont"   // Focused
    FontNames(8)="DHButtonFont"   // Pressed
    FontNames(9)="DHButtonFont"   // Disabled

    // Large
    FontNames(10)="DHButtonFont"  // Blurry
    FontNames(11)="DHButtonFont"  // Watched
    FontNames(12)="DHButtonFont"  // Focused
    FontNames(13)="DHButtonFont"  // Pressed
    FontNames(14)="DHButtonFont"  // Disabled

    FontColors(0)=(B=0,G=0,R=0)             // Blurry
    FontColors(2)=(B=255,G=255,R=255)       // Focused
    FontColors(3)=(B=20,G=20,R=20,A=200)    // Pressed
    FontColors(4)=(B=20,G=20,R=20,A=100)    // Disabled

    BorderOffsets(0)=0
    BorderOffsets(1)=0
    BorderOffsets(2)=0
    BorderOffsets(3)=0
}
