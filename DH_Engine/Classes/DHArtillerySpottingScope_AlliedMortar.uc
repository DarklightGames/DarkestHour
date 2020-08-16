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
    RangeTable(0)=(Mils=85,Range=110)
    RangeTable(1)=(Mils=84,Range=135)
    RangeTable(2)=(Mils=83,Range=155)
    RangeTable(3)=(Mils=82,Range=180)
    RangeTable(4)=(Mils=81,Range=200)
    RangeTable(5)=(Mils=80,Range=220)
    RangeTable(6)=(Mils=79,Range=240)
    RangeTable(7)=(Mils=78,Range=260)
    RangeTable(8)=(Mils=77,Range=280)
    RangeTable(9)=(Mils=76,Range=305)
    RangeTable(10)=(Mils=75,Range=320)
    RangeTable(11)=(Mils=74,Range=340)
    RangeTable(12)=(Mils=73,Range=360)
    RangeTable(13)=(Mils=72,Range=380)
    RangeTable(14)=(Mils=71,Range=395)
    RangeTable(15)=(Mils=70,Range=415)
    RangeTable(16)=(Mils=69,Range=430)
    RangeTable(17)=(Mils=68,Range=450)
    RangeTable(18)=(Mils=67,Range=465)
    RangeTable(19)=(Mils=66,Range=480)
    RangeTable(20)=(Mils=65,Range=495)
    RangeTable(21)=(Mils=64,Range=510)
    RangeTable(22)=(Mils=63,Range=520)
    RangeTable(23)=(Mils=62,Range=535)
    RangeTable(24)=(Mils=61,Range=545)
    RangeTable(25)=(Mils=60,Range=560)
    RangeTable(26)=(Mils=59,Range=570)
    RangeTable(27)=(Mils=58,Range=580)
    RangeTable(28)=(Mils=57,Range=590)
    RangeTable(29)=(Mils=56,Range=600)
    RangeTable(30)=(Mils=55,Range=605)
    RangeTable(31)=(Mils=54,Range=615)
    RangeTable(32)=(Mils=53,Range=620)
    RangeTable(33)=(Mils=52,Range=625)
    RangeTable(34)=(Mils=51,Range=630)
    RangeTable(35)=(Mils=50,Range=635)
    RangeTable(36)=(Mils=49,Range=640)
    RangeTable(37)=(Mils=48,Range=640)
    RangeTable(38)=(Mils=47,Range=645)
    RangeTable(39)=(Mils=46,Range=645)
    RangeTable(40)=(Mils=45,Range=645)
    RangeTable(41)=(Mils=44,Range=645)
    RangeTable(42)=(Mils=43,Range=650)
    RangeTable(43)=(Mils=42,Range=650)
    RangeTable(44)=(Mils=41,Range=650)
    RangeTable(45)=(Mils=40,Range=655)
}