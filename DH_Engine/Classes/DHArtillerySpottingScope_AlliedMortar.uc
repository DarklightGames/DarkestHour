//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2019
//==============================================================================

class DHArtillerySpottingScope_AlliedMortar extends DHArtillerySpottingScope
    abstract;

defaultproperties 
{
    // to do: replace with some cool American overlay
    SpottingScopeOverlay=Texture'DH_VehicleOptics_tex.British.BesaMG_sight'
    
    YawScaleStep=5.0
    PitchScaleStep=0.5

    // to do: confirm those values are correct!
    RangeTable(0)=(Pitch=86,Range=100)
    RangeTable(1)=(Pitch=84,Range=135)
    RangeTable(2)=(Pitch=82,Range=180)
    RangeTable(3)=(Pitch=80,Range=220)
    RangeTable(4)=(Pitch=78,Range=260)
    RangeTable(5)=(Pitch=76,Range=305)
    RangeTable(6)=(Pitch=74,Range=340)
    RangeTable(7)=(Pitch=72,Range=380)
    RangeTable(8)=(Pitch=70,Range=415)
    RangeTable(9)=(Pitch=68,Range=450)
    RangeTable(10)=(Pitch=66,Range=480)
    RangeTable(11)=(Pitch=64,Range=510)
    RangeTable(12)=(Pitch=62,Range=535)
    RangeTable(13)=(Pitch=60,Range=560)
    RangeTable(14)=(Pitch=58,Range=580)
    RangeTable(15)=(Pitch=56,Range=600)
    RangeTable(16)=(Pitch=54,Range=615)
    RangeTable(17)=(Pitch=52,Range=625)
    RangeTable(18)=(Pitch=50,Range=635)
    RangeTable(19)=(Pitch=48,Range=640)
    RangeTable(20)=(Pitch=46,Range=645)
    RangeTable(21)=(Pitch=44,Range=645)
    RangeTable(22)=(Pitch=42,Range=650)
    RangeTable(23)=(Pitch=40,Range=655)
}