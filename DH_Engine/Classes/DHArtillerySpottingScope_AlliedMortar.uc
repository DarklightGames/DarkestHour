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
    RangeTable(0)=(Pitch=85,Range=110)
    RangeTable(1)=(Pitch=84,Range=135)
    RangeTable(2)=(Pitch=83,Range=155)
    RangeTable(3)=(Pitch=82,Range=180)
    RangeTable(4)=(Pitch=81,Range=200)
    RangeTable(5)=(Pitch=80,Range=220)
    RangeTable(6)=(Pitch=79,Range=240)
    RangeTable(7)=(Pitch=78,Range=260)
    RangeTable(8)=(Pitch=77,Range=280)
    RangeTable(9)=(Pitch=76,Range=305)
    RangeTable(10)=(Pitch=75,Range=320)
    RangeTable(11)=(Pitch=74,Range=340)
    RangeTable(12)=(Pitch=73,Range=360)
    RangeTable(13)=(Pitch=72,Range=380)
    RangeTable(14)=(Pitch=71,Range=395)
    RangeTable(15)=(Pitch=70,Range=415)
    RangeTable(16)=(Pitch=69,Range=430)
    RangeTable(17)=(Pitch=68,Range=450)
    RangeTable(18)=(Pitch=67,Range=465)
    RangeTable(19)=(Pitch=66,Range=480)
    RangeTable(20)=(Pitch=65,Range=495)
    RangeTable(21)=(Pitch=64,Range=510)
    RangeTable(22)=(Pitch=63,Range=520)
    RangeTable(23)=(Pitch=62,Range=535)
    RangeTable(24)=(Pitch=61,Range=545)
    RangeTable(25)=(Pitch=60,Range=560)
    RangeTable(26)=(Pitch=59,Range=570)
    RangeTable(27)=(Pitch=58,Range=580)
    RangeTable(28)=(Pitch=57,Range=590)
    RangeTable(29)=(Pitch=56,Range=600)
    RangeTable(30)=(Pitch=55,Range=605)
    RangeTable(31)=(Pitch=54,Range=615)
    RangeTable(32)=(Pitch=53,Range=620)
    RangeTable(33)=(Pitch=52,Range=625)
    RangeTable(34)=(Pitch=51,Range=630)
    RangeTable(35)=(Pitch=50,Range=635)
    RangeTable(36)=(Pitch=49,Range=640)
    RangeTable(37)=(Pitch=48,Range=640)
    RangeTable(38)=(Pitch=47,Range=645)
    RangeTable(39)=(Pitch=46,Range=645)
    RangeTable(40)=(Pitch=45,Range=645)
    RangeTable(41)=(Pitch=44,Range=645)
    RangeTable(42)=(Pitch=43,Range=650)
    RangeTable(43)=(Pitch=42,Range=650)
    RangeTable(44)=(Pitch=41,Range=650)
    RangeTable(45)=(Pitch=40,Range=655)
}