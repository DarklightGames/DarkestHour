//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
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
    FontNames(0)="DHButtonFontDS"   // Blurry
    FontNames(1)="DHButtonFontDS"   // Watched
    FontNames(2)="DHButtonFontDS"   // Focused
    FontNames(3)="DHButtonFontDS"   // Pressed
    FontNames(4)="DHButtonFontDS"   // Disabled

    // Medium
    FontNames(5)="DHButtonFontDS"   // Blurry
    FontNames(6)="DHButtonFontDS"   // Watched
    FontNames(7)="DHButtonFontDS"   // Focused
    FontNames(8)="DHButtonFontDS"   // Pressed
    FontNames(9)="DHButtonFontDS"   // Disabled

    // Large
    FontNames(10)="DHButtonFontDS"  // Blurry
    FontNames(11)="DHButtonFontDS"  // Watched
    FontNames(12)="DHButtonFontDS"  // Focused
    FontNames(13)="DHButtonFontDS"  // Pressed
    FontNames(14)="DHButtonFontDS"  // Disabled

    FontColors(0)=(B=0,G=0,R=0)             // Blurry
    FontColors(2)=(B=255,G=255,R=255)       // Focused
    FontColors(3)=(B=20,G=20,R=20,A=200)    // Pressed
    FontColors(4)=(B=20,G=20,R=20,A=100)    // Disabled

    BorderOffsets(0)=0
    BorderOffsets(1)=0
    BorderOffsets(2)=0
    BorderOffsets(3)=0
}
