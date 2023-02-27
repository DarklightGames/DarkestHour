//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DHArtillerySpottingScope_M1927 extends DHArtillerySpottingScope;

defaultproperties
{
    SpottingScopeOverlay=Texture'DH_VehicleOptics_tex.German.RblF16_artillery_sight'

    YawScaleStep=5.0
    PitchScaleStep=5.0

    RangeTable(0)=(Pitch=30,Range=100)
    RangeTable(1)=(Pitch=55,Range=150)
    RangeTable(2)=(Pitch=75,Range=200)
    RangeTable(3)=(Pitch=95,Range=250)
    RangeTable(4)=(Pitch=115,Range=300)
    RangeTable(5)=(Pitch=135,Range=350)
    RangeTable(6)=(Pitch=155,Range=400)
    RangeTable(7)=(Pitch=180,Range=450)
    RangeTable(8)=(Pitch=200,Range=500)
    RangeTable(9)=(Pitch=225,Range=550)
    RangeTable(10)=(Pitch=245,Range=600)
    RangeTable(11)=(Pitch=270,Range=650)
    RangeTable(12)=(Pitch=295,Range=700)
    RangeTable(13)=(Pitch=320,Range=750)
    RangeTable(14)=(Pitch=345,Range=800)
    RangeTable(15)=(Pitch=375,Range=850)
    RangeTable(16)=(Pitch=400,Range=900)
    RangeTable(17)=(Pitch=430,Range=950)
    NumberOfPitchSegments=6
    PitchSegmentSchema(0)=(Shape=MediumLengthTick,bShouldDrawLabel=true)
    PitchSegmentSchema(1)=(Shape=ShortTick)
    PitchSegmentSchema(2)=(Shape=ShortTick)
    PitchSegmentSchema(3)=(Shape=ShortTick)
    PitchSegmentSchema(4)=(Shape=ShortTick)
    PitchSegmentSchema(5)=(Shape=MediumLengthTick)
    PitchSegmentSchema(6)=(Shape=ShortTick)
    PitchSegmentSchema(7)=(Shape=ShortTick)
    PitchSegmentSchema(8)=(Shape=ShortTick)
    PitchSegmentSchema(9)=(Shape=ShortTick)

    NumberOfYawSegments=2
    YawSegmentSchema(0)=(Shape=MediumLengthTick,bShouldDrawLabel=true)
    YawSegmentSchema(1)=(Shape=ShortTick)
    YawSegmentSchema(2)=(Shape=ShortTick)
    YawSegmentSchema(3)=(Shape=ShortTick)
    YawSegmentSchema(4)=(Shape=ShortTick)
    YawSegmentSchema(5)=(Shape=ShortTick)
    YawSegmentSchema(6)=(Shape=ShortTick)
    YawSegmentSchema(7)=(Shape=ShortTick)
    YawSegmentSchema(8)=(Shape=ShortTick)
    YawSegmentSchema(9)=(Shape=ShortTick)

    YawIndicatorLength=120
}
