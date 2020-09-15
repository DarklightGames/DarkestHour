//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2019
//==============================================================================

class DHArtillerySpottingScope_AlliedMortar extends DHArtillerySpottingScope
    abstract;

defaultproperties 
{
    // to do: replace with some cool American overlay
    SpottingScopeOverlay=Texture'DH_VehicleOptics_tex.British.BesaMG_sight'
    
    YawScaleStep=5.0
    PitchScaleStep=1.0

    // to do: confirm those values are correct!
    RangeTable(0)=(Degrees=85,Range=110)
    RangeTable(1)=(Degrees=84,Range=135)
    RangeTable(2)=(Degrees=83,Range=155)
    RangeTable(3)=(Degrees=82,Range=180)
    RangeTable(4)=(Degrees=81,Range=200)
    RangeTable(5)=(Degrees=80,Range=220)
    RangeTable(6)=(Degrees=79,Range=240)
    RangeTable(7)=(Degrees=78,Range=260)
    RangeTable(8)=(Degrees=77,Range=280)
    RangeTable(9)=(Degrees=76,Range=305)
    RangeTable(10)=(Degrees=75,Range=320)
    RangeTable(11)=(Degrees=74,Range=340)
    RangeTable(12)=(Degrees=73,Range=360)
    RangeTable(13)=(Degrees=72,Range=380)
    RangeTable(14)=(Degrees=71,Range=395)
    RangeTable(15)=(Degrees=70,Range=415)
    RangeTable(16)=(Degrees=69,Range=430)
    RangeTable(17)=(Degrees=68,Range=450)
    RangeTable(18)=(Degrees=67,Range=465)
    RangeTable(19)=(Degrees=66,Range=480)
    RangeTable(20)=(Degrees=65,Range=495)
    RangeTable(21)=(Degrees=64,Range=510)
    RangeTable(22)=(Degrees=63,Range=520)
    RangeTable(23)=(Degrees=62,Range=535)
    RangeTable(24)=(Degrees=61,Range=545)
    RangeTable(25)=(Degrees=60,Range=560)
    RangeTable(26)=(Degrees=59,Range=570)
    RangeTable(27)=(Degrees=58,Range=580)
    RangeTable(28)=(Degrees=57,Range=590)
    RangeTable(29)=(Degrees=56,Range=600)
    RangeTable(30)=(Degrees=55,Range=605)
    RangeTable(31)=(Degrees=54,Range=615)
    RangeTable(32)=(Degrees=53,Range=620)
    RangeTable(33)=(Degrees=52,Range=625)
    RangeTable(34)=(Degrees=51,Range=630)
    RangeTable(35)=(Degrees=50,Range=635)
    RangeTable(36)=(Degrees=49,Range=640)
    RangeTable(37)=(Degrees=48,Range=640)
    RangeTable(38)=(Degrees=47,Range=645)
    RangeTable(39)=(Degrees=46,Range=645)
    RangeTable(40)=(Degrees=45,Range=645)
    RangeTable(41)=(Degrees=44,Range=645)
    RangeTable(42)=(Degrees=43,Range=650)
    RangeTable(43)=(Degrees=42,Range=650)
    RangeTable(44)=(Degrees=41,Range=650)
    RangeTable(45)=(Degrees=40,Range=655)
}