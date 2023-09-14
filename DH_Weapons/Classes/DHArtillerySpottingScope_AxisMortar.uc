//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DHArtillerySpottingScope_AxisMortar extends DHArtillerySpottingScope;

defaultproperties
{
    SpottingScopeOverlay=Texture'DH_VehicleOptics_tex.German.RblF16_artillery_sight'   // TODO: REPLACE

    RangeTable(0)=(Range=50,Pitch=86.5)
    RangeTable(1)=(Range=75,Pitch=85.0)
    RangeTable(2)=(Range=100,Pitch=83.0)
    RangeTable(3)=(Range=125,Pitch=81.0)
    RangeTable(4)=(Range=150,Pitch=79.5)
    RangeTable(5)=(Range=175,Pitch=77.5)
    RangeTable(6)=(Range=200,Pitch=75.5)
    RangeTable(7)=(Range=225,Pitch=73.5)
    RangeTable(8)=(Range=250,Pitch=71.0)
    RangeTable(9)=(Range=275,Pitch=69.0)
    RangeTable(10)=(Range=300,Pitch=66.5)
    RangeTable(11)=(Range=325,Pitch=63.5)
    RangeTable(12)=(Range=350,Pitch=60.5)
    RangeTable(13)=(Range=375,Pitch=57.0)
    RangeTable(14)=(Range=400,Pitch=51.0)

    YawScaleStep=5.0
    PitchScaleStep=1.0
    PitchDecimalsTable=1

    PitchAngleUnit=AU_Degrees
    PitchIndicatorLength=200
    NumberOfPitchSegments=4
    PitchSegmentSchema(0)=(Shape=LongTick,bShouldDrawLabel=true)
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

    YawIndicatorLength=100
}

