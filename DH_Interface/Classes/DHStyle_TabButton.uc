//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DHStyle_TabButton extends GUIStyles;

defaultproperties
{
    KeyName="DHTabButton"
    FontNames(0)="DHLargeFont"
    FontNames(1)="DHLargeFont"
    FontNames(2)="DHLargeFont"
    FontNames(3)="DHLargeFont"
    FontNames(4)="DHLargeFont"
    FontNames(5)="DHLargeFont"
    FontNames(6)="DHLargeFont"
    FontNames(7)="DHLargeFont"
    FontNames(8)="DHLargeFont"
    FontNames(9)="DHLargeFont"
    FontNames(10)="DHLargeFont"
    FontNames(11)="DHLargeFont"
    FontNames(12)="DHLargeFont"
    FontNames(13)="DHLargeFont"
    FontNames(14)="DHLargeFont"

    Images(0)=Texture'InterfaceArt_tex.Menu.tabssolid'
    Images(1)=Texture'InterfaceArt_tex.Menu.tabssolid_watched'
    Images(2)=Texture'InterfaceArt_tex.Menu.tabssolid'
    Images(3)=Texture'InterfaceArt_tex.Menu.tabssolid_watched'
    Images(4)=Texture'InterfaceArt_tex.Menu.tabssolid'

    FontColors(0)=(R=200,G=200,B=200,A=220) // Normal (unselected)
    FontColors(1)=(R=255,G=255,B=255,A=255) // Mouse over
    FontColors(2)=(R=250,G=250,B=150,A=255) // Selected
    FontColors(3)=(R=0,G=0,B=0,A=220)       // Mouse down (click)
    FontColors(4)=(R=150,G=150,B=150,A=200) // Disabled

    FontBKColors(0)=(R=0,G=0,B=0,A=255)
    FontBKColors(1)=(R=0,G=0,B=0,A=255)
    FontBKColors(2)=(R=0,G=0,B=0,A=255)
    FontBKColors(3)=(R=0,G=0,B=0,A=255)
    FontBKColors(4)=(R=0,G=0,B=0,A=255)

    BorderOffsets(0)=20 // Add some padding (makes the button longer)
    BorderOffsets(1)=0
    BorderOffsets(2)=20 // Add some padding (makes the button longer)
    BorderOffsets(3)=0
}
