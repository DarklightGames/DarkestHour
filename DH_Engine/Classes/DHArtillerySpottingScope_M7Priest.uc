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

    RangeTable(0)=(Mils=0,Range=115)
    RangeTable(1)=(Mils=25,Range=200)
    RangeTable(2)=(Mils=55,Range=300)
    RangeTable(3)=(Mils=75,Range=400)
    RangeTable(4)=(Mils=100,Range=500)
    RangeTable(5)=(Mils=125,Range=600)
    RangeTable(6)=(Mils=150,Range=700)
    RangeTable(7)=(Mils=180,Range=800)
    RangeTable(8)=(Mils=205,Range=900)
    RangeTable(9)=(Mils=230,Range=1000)
    RangeTable(10)=(Mils=255,Range=1100)
    RangeTable(11)=(Mils=285,Range=1200)
    RangeTable(12)=(Mils=315,Range=1300)
    RangeTable(13)=(Mils=345,Range=1400)
    RangeTable(14)=(Mils=380,Range=1500)
    RangeTable(15)=(Mils=415,Range=1600)
    RangeTable(16)=(Mils=455,Range=1700)
    RangeTable(17)=(Mils=500,Range=1800)
    RangeTable(18)=(Mils=555,Range=1900)
}