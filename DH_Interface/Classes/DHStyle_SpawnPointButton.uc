//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DHStyle_SpawnPointButton extends GUIStyles
    abstract;

defaultproperties
{
    FontNames(0)="DHMenuFont"
    FontNames(1)="DHMenuFont"
    FontNames(2)="DHMenuFont"
    FontNames(3)="DHMenuFont"
    FontNames(4)="DHMenuFont"
    FontNames(5)="DHMenuFont"
    FontNames(6)="DHMenuFont"
    FontNames(7)="DHMenuFont"
    FontNames(8)="DHMenuFont"
    FontNames(9)="DHMenuFont"
    FontNames(10)="DHMenuFont"
    FontNames(11)="DHMenuFont"
    FontNames(12)="DHMenuFont"
    FontNames(13)="DHMenuFont"
    FontNames(14)="DHMenuFont"
    FontColors(0)=(B=255,G=255,R=255,A=255)     // Default look
    FontColors(1)=(B=192,G=192,R=192,A=255)     // Mouse over / hover
    FontColors(2)=(B=255,G=255,R=255,A=255)     // Selected
    FontColors(3)=(B=128,G=128,R=128,A=255)     // On mouse click
    FontColors(4)=(B=255,G=255,R=255,A=128)     // Disabled (not used)

    // Scaled needed for icon to look correct
    ImgStyle(0)=ISTY_Scaled
    ImgStyle(1)=ISTY_Scaled
    ImgStyle(2)=ISTY_Scaled
    ImgStyle(3)=ISTY_Scaled
    ImgStyle(4)=ISTY_Scaled

    ImgColors(0)=(R=255,G=255,B=255,A=255)
    ImgColors(1)=(R=255,G=255,B=255,A=255)
    ImgColors(2)=(R=255,G=255,B=255,A=255)
    ImgColors(3)=(R=255,G=255,B=255,A=255)
    ImgColors(4)=(R=128,G=128,B=128,A=128)

    BorderOffsets(0)=0
    BorderOffsets(1)=0
    BorderOffsets(2)=0
    BorderOffsets(3)=0
}
