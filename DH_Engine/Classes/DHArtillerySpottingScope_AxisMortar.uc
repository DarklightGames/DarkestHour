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
    RangeTable(0)=(Pitch=88,Range=25)
    RangeTable(1)=(Pitch=87,Range=40)
    RangeTable(2)=(Pitch=86,Range=55)
    RangeTable(3)=(Pitch=85,Range=75)
    RangeTable(4)=(Pitch=84,Range=90)
    RangeTable(5)=(Pitch=83,Range=105)
    RangeTable(6)=(Pitch=82,Range=120)
    RangeTable(7)=(Pitch=81,Range=135)
    RangeTable(8)=(Pitch=80,Range=150)
    RangeTable(9)=(Pitch=79,Range=160)
    RangeTable(10)=(Pitch=78,Range=175)
    RangeTable(11)=(Pitch=77,Range=190)
    RangeTable(12)=(Pitch=76,Range=205)
    RangeTable(13)=(Pitch=75,Range=215)
    RangeTable(14)=(Pitch=74,Range=230)
    RangeTable(15)=(Pitch=73,Range=240)
    RangeTable(16)=(Pitch=72,Range=255)
    RangeTable(17)=(Pitch=71,Range=265)
    RangeTable(18)=(Pitch=70,Range=280)
    RangeTable(19)=(Pitch=69,Range=290)
    RangeTable(20)=(Pitch=68,Range=300)
    RangeTable(21)=(Pitch=67,Range=310)
    RangeTable(22)=(Pitch=66,Range=320)
    RangeTable(23)=(Pitch=65,Range=330)
    RangeTable(24)=(Pitch=64,Range=340)
    RangeTable(25)=(Pitch=63,Range=350)
    RangeTable(26)=(Pitch=62,Range=360)
    RangeTable(27)=(Pitch=61,Range=365)
    RangeTable(28)=(Pitch=60,Range=375)
    RangeTable(29)=(Pitch=59,Range=385)
    RangeTable(30)=(Pitch=58,Range=390)
    RangeTable(31)=(Pitch=57,Range=395)
    RangeTable(32)=(Pitch=56,Range=400)
    RangeTable(33)=(Pitch=55,Range=405)
    RangeTable(34)=(Pitch=54,Range=410)
    RangeTable(35)=(Pitch=53,Range=415)
    RangeTable(36)=(Pitch=52,Range=420)
    RangeTable(37)=(Pitch=51,Range=425)
    RangeTable(38)=(Pitch=50,Range=425)
    RangeTable(39)=(Pitch=49,Range=430)
    RangeTable(40)=(Pitch=48,Range=430)
    RangeTable(41)=(Pitch=47,Range=430)
    RangeTable(42)=(Pitch=46,Range=435)
    RangeTable(43)=(Pitch=45,Range=435)
}