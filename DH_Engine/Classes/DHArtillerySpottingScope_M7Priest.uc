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

    RangeTable(0)=(Pitch=0,Range=115)
    RangeTable(1)=(Pitch=25,Range=200)
    RangeTable(2)=(Pitch=50,Range=300)
    RangeTable(3)=(Pitch=75,Range=400)
    RangeTable(4)=(Pitch=100,Range=500)
    RangeTable(5)=(Pitch=125,Range=600)
    RangeTable(6)=(Pitch=150,Range=700)
    RangeTable(7)=(Pitch=175,Range=800)
    RangeTable(8)=(Pitch=200,Range=900)
    RangeTable(9)=(Pitch=225,Range=1000)
    RangeTable(10)=(Pitch=250,Range=1100)
    RangeTable(11)=(Pitch=275,Range=1200)
    RangeTable(12)=(Pitch=300,Range=1300)
    RangeTable(13)=(Pitch=325,Range=1350)
    RangeTable(14)=(Pitch=350,Range=1400)
    RangeTable(15)=(Pitch=375,Range=1500)
    RangeTable(16)=(Pitch=400,Range=1600)
    RangeTable(17)=(Pitch=425,Range=1650)
    RangeTable(18)=(Pitch=450,Range=1700)
    RangeTable(19)=(Pitch=475,Range=1750)
    RangeTable(20)=(Pitch=500,Range=1800)
    RangeTable(21)=(Pitch=525,Range=1850)
    RangeTable(22)=(Pitch=550,Range=1850)
    RangeTable(23)=(Pitch=575,Range=1850)
    RangeTable(24)=(Pitch=600,Range=1900)
    RangeTable(25)=(Pitch=625,Range=1925)
    RangeTable(26)=(Pitch=650,Range=1950)
    RangeTable(27)=(Pitch=675,Range=1975)
    RangeTable(28)=(Pitch=700,Range=2000)
    RangeTable(29)=(Pitch=725,Range=2025)
    RangeTable(30)=(Pitch=750,Range=2050)
    RangeTable(31)=(Pitch=775,Range=2075)
    RangeTable(32)=(Pitch=800,Range=2100)
    RangeTable(33)=(Pitch=825,Range=2150)
    RangeTable(34)=(Pitch=850,Range=2200)
    RangeTable(35)=(Pitch=875,Range=2225)
    RangeTable(36)=(Pitch=900,Range=2250)
    RangeTable(37)=(Pitch=925,Range=2250)
    RangeTable(38)=(Pitch=950,Range=2250)
    RangeTable(39)=(Pitch=975,Range=2250)
    AngleUnit="mils"
}
