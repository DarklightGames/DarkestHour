//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2019
//==============================================================================

class DHArtillerySpottingScope_LeIG18 extends DHArtillerySpottingScope
    abstract;

defaultproperties
{
    SpottingScopeOverlay=Texture'DH_VehicleOptics_tex.German.RblF16_artillery_sight'   // TODO: REPLACE

    YawScaleStep=10.0
    PitchScaleStep=10.0

    // to do: confirm those values are correct!
    RangeTable(0)=(Pitch=0,Range=35)
    RangeTable(1)=(Pitch=100,Range=270)
    RangeTable(2)=(Pitch=150,Range=395)
    RangeTable(3)=(Pitch=200,Range=515)
    RangeTable(4)=(Pitch=250,Range=635)
    RangeTable(5)=(Pitch=300,Range=750)
    RangeTable(6)=(Pitch=350,Range=845)
    RangeTable(7)=(Pitch=400,Range=940)
    RangeTable(8)=(Pitch=450,Range=1020)
    RangeTable(9)=(Pitch=500,Range=1095)
    RangeTable(11)=(Pitch=550,Range=1155)
    RangeTable(12)=(Pitch=600,Range=1205)
    RangeTable(13)=(Pitch=650,Range=1250)
    AngleUnit="mils"
}
