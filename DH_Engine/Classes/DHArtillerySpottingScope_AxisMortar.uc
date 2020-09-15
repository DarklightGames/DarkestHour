//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2019
//==============================================================================

class DHArtillerySpottingScope_AxisMortar extends DHArtillerySpottingScope
    abstract;

defaultproperties 
{
    SpottingScopeOverlay=Texture'DH_VehicleOptics_tex.German.RblF16_artillery_sight'   // TODO: REPLACE
    
    YawScaleStep=5.0
    PitchScaleStep=1.0

    // to do: confirm those values are correct!
    RangeTable(0)=(Degrees=88,Range=25)
    RangeTable(1)=(Degrees=87,Range=40)
    RangeTable(2)=(Degrees=86,Range=55)
    RangeTable(3)=(Degrees=85,Range=75)
    RangeTable(4)=(Degrees=84,Range=90)
    RangeTable(5)=(Degrees=83,Range=105)
    RangeTable(6)=(Degrees=82,Range=120)
    RangeTable(7)=(Degrees=81,Range=135)
    RangeTable(8)=(Degrees=80,Range=150)
    RangeTable(9)=(Degrees=79,Range=160)
    RangeTable(10)=(Degrees=78,Range=175)
    RangeTable(11)=(Degrees=77,Range=190)
    RangeTable(12)=(Degrees=76,Range=205)
    RangeTable(13)=(Degrees=75,Range=215)
    RangeTable(14)=(Degrees=74,Range=230)
    RangeTable(15)=(Degrees=73,Range=240)
    RangeTable(16)=(Degrees=72,Range=255)
    RangeTable(17)=(Degrees=71,Range=265)
    RangeTable(18)=(Degrees=70,Range=280)
    RangeTable(19)=(Degrees=69,Range=290)
    RangeTable(20)=(Degrees=68,Range=300)
    RangeTable(21)=(Degrees=67,Range=310)
    RangeTable(22)=(Degrees=66,Range=320)
    RangeTable(23)=(Degrees=65,Range=330)
    RangeTable(24)=(Degrees=64,Range=340)
    RangeTable(25)=(Degrees=63,Range=350)
    RangeTable(26)=(Degrees=62,Range=360)
    RangeTable(27)=(Degrees=61,Range=365)
    RangeTable(28)=(Degrees=60,Range=375)
    RangeTable(29)=(Degrees=59,Range=385)
    RangeTable(30)=(Degrees=58,Range=390)
    RangeTable(31)=(Degrees=57,Range=395)
    RangeTable(32)=(Degrees=56,Range=400)
    RangeTable(33)=(Degrees=55,Range=405)
    RangeTable(34)=(Degrees=54,Range=410)
    RangeTable(35)=(Degrees=53,Range=415)
    RangeTable(36)=(Degrees=52,Range=420)
    RangeTable(37)=(Degrees=51,Range=425)
    RangeTable(38)=(Degrees=50,Range=425)
    RangeTable(39)=(Degrees=49,Range=430)
    RangeTable(40)=(Degrees=48,Range=430)
    RangeTable(41)=(Degrees=47,Range=430)
    RangeTable(42)=(Degrees=46,Range=435)
    RangeTable(43)=(Degrees=45,Range=435)
}