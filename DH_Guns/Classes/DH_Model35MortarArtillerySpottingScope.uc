//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_Model35MortarArtillerySpottingScope extends DHArtillerySpottingScope;

defaultproperties
{
    SpottingScopeOverlay=Texture'DH_Weapon_tex.Scopes.Springfield_Scope_Overlay'    // TODO: swap for the correct texture

    YawScaleStep=5.0
    PitchScaleStep=0.5

    RangeTable(0)=(Pitch=87,Range=100)
    RangeTable(1)=(Pitch=86,Range=150)
    RangeTable(2)=(Pitch=84,Range=200)
    RangeTable(3)=(Pitch=83,Range=250)
    RangeTable(4)=(Pitch=82,Range=300)
    RangeTable(5)=(Pitch=80,Range=350)
    RangeTable(6)=(Pitch=79,Range=400)
    RangeTable(7)=(Pitch=77,Range=450)
    RangeTable(8)=(Pitch=75,Range=500)
    RangeTable(9)=(Pitch=74,Range=550)
    RangeTable(10)=(Pitch=72,Range=600)
    RangeTable(11)=(Pitch=70,Range=650)
    RangeTable(12)=(Pitch=69,Range=700)
    RangeTable(13)=(Pitch=67,Range=750)
    RangeTable(14)=(Pitch=64,Range=800)
    RangeTable(15)=(Pitch=62,Range=850)
    RangeTable(16)=(Pitch=59,Range=900)
    RangeTable(17)=(Pitch=56,Range=950)
    RangeTable(18)=(Pitch=52,Range=1000)

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
