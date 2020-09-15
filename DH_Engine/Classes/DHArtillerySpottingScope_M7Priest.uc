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
    
    YawScaleStep=5.0
    PitchScaleStep=5.0

    RangeTable(0)=(Degrees=0,Range=115)
    RangeTable(1)=(Degrees=25,Range=200)
    RangeTable(2)=(Degrees=55,Range=300)
    RangeTable(3)=(Degrees=75,Range=400)
    RangeTable(4)=(Degrees=100,Range=500)
    RangeTable(5)=(Degrees=125,Range=600)
    RangeTable(6)=(Degrees=150,Range=700)
    RangeTable(7)=(Degrees=180,Range=800)
    RangeTable(8)=(Degrees=205,Range=900)
    RangeTable(9)=(Degrees=230,Range=1000)
    RangeTable(10)=(Degrees=255,Range=1100)
    RangeTable(11)=(Degrees=285,Range=1200)
    RangeTable(12)=(Degrees=315,Range=1300)
    RangeTable(13)=(Degrees=345,Range=1400)
    RangeTable(14)=(Degrees=380,Range=1500)
    RangeTable(15)=(Degrees=415,Range=1600)
    RangeTable(16)=(Degrees=455,Range=1700)
    RangeTable(17)=(Degrees=500,Range=1800)
    RangeTable(18)=(Degrees=555,Range=1900)
    AngleUnit = "mils"
}