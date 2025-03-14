//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_M2MortarArtillerySpottingScope extends DHArtillerySpottingScope;

defaultproperties
{
    SpottingScopeOverlay=Texture'DH_Weapon_tex.Scopes.Springfield_Scope_Overlay'

    YawScaleStep=5.0
    PitchScaleStep=0.5

    RangeTable(0)=(Range=125,Pitch=84)
    RangeTable(1)=(Range=150,Pitch=82)
    RangeTable(2)=(Range=175,Pitch=81)
    RangeTable(3)=(Range=200,Pitch=80)
    RangeTable(4)=(Range=225,Pitch=79)
    RangeTable(5)=(Range=250,Pitch=77)
    RangeTable(6)=(Range=275,Pitch=76)
    RangeTable(7)=(Range=300,Pitch=75)
    RangeTable(8)=(Range=325,Pitch=73)
    RangeTable(9)=(Range=350,Pitch=72)
    RangeTable(10)=(Range=375,Pitch=70)
    RangeTable(11)=(Range=400,Pitch=69)
    RangeTable(12)=(Range=425,Pitch=67)
    RangeTable(13)=(Range=450,Pitch=65)
    RangeTable(14)=(Range=475,Pitch=63)
    RangeTable(15)=(Range=500,Pitch=61)
    RangeTable(16)=(Range=525,Pitch=59)
    RangeTable(17)=(Range=550,Pitch=56)
    RangeTable(18)=(Range=575,Pitch=52)

    NumberOfPitchSegments=4
    PitchSegmentSchema(0)=(Shape=LongTick,bShouldDrawLabel=true)
    PitchSegmentSchema(1)=(Shape=ShortTick)
    PitchSegmentSchema(2)=(Shape=MediumLengthTick)
    PitchSegmentSchema(3)=(Shape=ShortTick)
    PitchSegmentSchema(4)=(Shape=MediumLengthTick)
    PitchSegmentSchema(5)=(Shape=ShortTick)
    PitchSegmentSchema(6)=(Shape=MediumLengthTick)
    PitchSegmentSchema(7)=(Shape=ShortTick)
    PitchSegmentSchema(8)=(Shape=MediumLengthTick)
    PitchSegmentSchema(9)=(Shape=ShortTick)

    NumberOfYawSegments=2
    YawSegmentSchema(0)=(Shape=MediumLengthTick,bShouldDrawLabel=true)
    YawSegmentSchema(1)=(Shape=ShortTick)
    YawSegmentSchema(2)=(Shape=ShortTick)
    YawSegmentSchema(3)=(Shape=ShortTick)
    YawSegmentSchema(4)=(Shape=ShortTick)
    YawSegmentSchema(5)=(Shape=MediumLengthTick,bShouldDrawLabel=true)
    YawSegmentSchema(6)=(Shape=ShortTick)
    YawSegmentSchema(7)=(Shape=ShortTick)
    YawSegmentSchema(8)=(Shape=ShortTick)
    YawSegmentSchema(9)=(Shape=ShortTick)

    YawIndicatorLength=200

    PitchAngleUnit=AU_Degrees
}
