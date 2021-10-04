//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2019
//==============================================================================

class DHArtillerySpottingScope_LeIG18 extends DHArtillerySpottingScope
    abstract;

defaultproperties
{
    SpottingScopeOverlay=Texture'DH_VehicleOptics_tex.German.RblF16_artillery_sight'   // TODO: REPLACE

    YawScaleStep=5.0
    PitchScaleStep=10.0

    // to do: confirm those values are correct!
    RangeTable(0)=(Pitch=32,Range=100)
    RangeTable(1)=(Pitch=53,Range=150)
    RangeTable(2)=(Pitch=75,Range=200)
    RangeTable(3)=(Pitch=92,Range=250)
    RangeTable(4)=(Pitch=114,Range=300)
    RangeTable(5)=(Pitch=132,Range=350)
    RangeTable(6)=(Pitch=150,Range=400)
    RangeTable(7)=(Pitch=174,Range=450)
    RangeTable(8)=(Pitch=194,Range=500)
    RangeTable(9)=(Pitch=215,Range=550)
    RangeTable(10)=(Pitch=236,Range=600)
    RangeTable(11)=(Pitch=257,Range=650)
    RangeTable(12)=(Pitch=280,Range=700)
    RangeTable(13)=(Pitch=300,Range=750)
    RangeTable(14)=(Pitch=326,Range=800)
    RangeTable(15)=(Pitch=352,Range=850)
    RangeTable(16)=(Pitch=381,Range=900)
    RangeTable(17)=(Pitch=409,Range=950)
    RangeTable(18)=(Pitch=435,Range=1000)
    RangeTable(19)=(Pitch=467,Range=1050)
    RangeTable(20)=(Pitch=501,Range=1100)
    RangeTable(21)=(Pitch=545,Range=1150)
    RangeTable(22)=(Pitch=593,Range=1200)

    AngleUnit="mils"

    NumberOfPitchSegments=6
    PitchSegmentSchema(0)=(Shape=MediumLengthTick,bShouldDrawLabel=true)
    PitchSegmentSchema(1)=(Shape=ShortTick)
    PitchSegmentSchema(2)=(Shape=ShortTick)
    PitchSegmentSchema(3)=(Shape=ShortTick)
    PitchSegmentSchema(4)=(Shape=ShortTick)
    PitchSegmentSchema(5)=(Shape=ShortTick)
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

    YawIndicatorLength=120.0
}
