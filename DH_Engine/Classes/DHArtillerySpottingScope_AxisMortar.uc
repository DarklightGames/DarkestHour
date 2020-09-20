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
    PitchScaleStep=0.5

    // to do: confirm those values are correct!
    RangeTable(0)=(Pitch=88,Range=25)
    RangeTable(1)=(Pitch=86,Range=55)
    RangeTable(2)=(Pitch=84,Range=90)
    RangeTable(3)=(Pitch=82,Range=120)
    RangeTable(4)=(Pitch=80,Range=150)
    RangeTable(5)=(Pitch=78,Range=175)
    RangeTable(6)=(Pitch=76,Range=205)
    RangeTable(7)=(Pitch=74,Range=230)
    RangeTable(8)=(Pitch=72,Range=255)
    RangeTable(9)=(Pitch=70,Range=280)
    RangeTable(10)=(Pitch=68,Range=300)
    RangeTable(11)=(Pitch=66,Range=320)
    RangeTable(12)=(Pitch=64,Range=340)
    RangeTable(13)=(Pitch=62,Range=360)
    RangeTable(14)=(Pitch=60,Range=375)
    RangeTable(15)=(Pitch=58,Range=390)
    RangeTable(16)=(Pitch=56,Range=400)
    RangeTable(17)=(Pitch=54,Range=410)
    RangeTable(18)=(Pitch=52,Range=420)
    RangeTable(19)=(Pitch=50,Range=425)
    RangeTable(20)=(Pitch=48,Range=430)
    RangeTable(21)=(Pitch=46,Range=435)
    RangeTable(22)=(Pitch=44,Range=440)
}
