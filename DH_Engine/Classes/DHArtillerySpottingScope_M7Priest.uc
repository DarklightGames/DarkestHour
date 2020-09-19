//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2019
//==============================================================================

class DHArtillerySpottingScope_M7Priest extends DHArtillerySpottingScope
    abstract;

defaultproperties 
{
    // to do: replace with some cool American overlay
    SpottingScopeOverlay=Texture'DH_VehicleOptics_tex.British.BesaMG_sight'
    
    YawScaleStep=20.0
    PitchScaleStep=5.0

    RangeTable(0)=(Pitch=0,Range=115)
    RangeTable(1)=(Pitch=25,Range=200)
    RangeTable(2)=(Pitch=55,Range=300)
    RangeTable(3)=(Pitch=75,Range=400)
    RangeTable(4)=(Pitch=100,Range=500)
    RangeTable(5)=(Pitch=125,Range=600)
    RangeTable(6)=(Pitch=150,Range=700)
    RangeTable(7)=(Pitch=180,Range=800)
    RangeTable(8)=(Pitch=205,Range=900)
    RangeTable(9)=(Pitch=230,Range=1000)
    RangeTable(10)=(Pitch=255,Range=1100)
    RangeTable(11)=(Pitch=285,Range=1200)
    RangeTable(12)=(Pitch=315,Range=1300)
    RangeTable(13)=(Pitch=345,Range=1400)
    RangeTable(14)=(Pitch=380,Range=1500)
    RangeTable(15)=(Pitch=415,Range=1600)
    RangeTable(16)=(Pitch=455,Range=1700)
    RangeTable(17)=(Pitch=500,Range=1800)
    RangeTable(18)=(Pitch=555,Range=1900)
    AngleUnit = "mils"
}