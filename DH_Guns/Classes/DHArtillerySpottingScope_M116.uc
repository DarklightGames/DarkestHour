//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DHArtillerySpottingScope_M116 extends DHArtillerySpottingScope;

defaultproperties
{
    SpottingScopeOverlay=Texture'DH_Weapon_tex.Scopes.Springfield_Scope_Overlay'

    YawScaleStep=10.0
    PitchScaleStep=10.0

    RangeTable(0)=(Range=100,Pitch=20)
    RangeTable(1)=(Range=200,Pitch=50)
    RangeTable(2)=(Range=300,Pitch=80)
    RangeTable(3)=(Range=400,Pitch=110)
    RangeTable(4)=(Range=500,Pitch=140)
    RangeTable(5)=(Range=600,Pitch=170)
    RangeTable(6)=(Range=700,Pitch=200)
    RangeTable(7)=(Range=800,Pitch=230)
    RangeTable(8)=(Range=900,Pitch=260)
    RangeTable(9)=(Range=1000,Pitch=290)
    RangeTable(10)=(Range=1100,Pitch=330)
    RangeTable(11)=(Range=1200,Pitch=365)
    RangeTable(12)=(Range=1300,Pitch=410)
    RangeTable(13)=(Range=1400,Pitch=455)
    RangeTable(14)=(Range=1500,Pitch=505)
    RangeTable(15)=(Range=1600,Pitch=570)
    RangeTable(16)=(Range=1700,Pitch=660)
    RangeTable(17)=(Range=1750,Pitch=750)

    NumberOfPitchSegments=6
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

    NumberOfYawSegments=4
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

    YawIndicatorLength=200
}
