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
    RangeTable(0)=(Mils=0.00,Range=35)
    RangeTable(1)=(Mils=10.00,Range=45)
    RangeTable(2)=(Mils=20.00,Range=80)
    RangeTable(3)=(Mils=30.00,Range=95)
    RangeTable(4)=(Mils=40.00,Range=125)
    RangeTable(5)=(Mils=50.00,Range=150)
    RangeTable(6)=(Mils=60.00,Range=170)
    RangeTable(7)=(Mils=70.00,Range=195)
    RangeTable(8)=(Mils=80.00,Range=215)
    RangeTable(9)=(Mils=90.00,Range=230)
    RangeTable(10)=(Mils=100.00,Range=270)
    RangeTable(11)=(Mils=110.00,Range=280)
    RangeTable(12)=(Mils=120.00,Range=310)
    RangeTable(13)=(Mils=130.00,Range=345)
    RangeTable(14)=(Mils=140.00,Range=370)
    RangeTable(15)=(Mils=150.00,Range=395)
    RangeTable(16)=(Mils=160.00,Range=430)
    RangeTable(17)=(Mils=170.00,Range=450)
    RangeTable(18)=(Mils=180.00,Range=470)
    RangeTable(19)=(Mils=190.00,Range=485)
    RangeTable(20)=(Mils=200.00,Range=515)
    RangeTable(21)=(Mils=210.00,Range=550)
    RangeTable(22)=(Mils=220.00,Range=570)
    RangeTable(23)=(Mils=230.00,Range=595)
    RangeTable(24)=(Mils=240.00,Range=615)
    RangeTable(25)=(Mils=250.00,Range=635)
    RangeTable(26)=(Mils=260.00,Range=650)
    RangeTable(27)=(Mils=270.00,Range=675)
    RangeTable(28)=(Mils=280.00,Range=705)
    RangeTable(29)=(Mils=290.00,Range=725)
    RangeTable(30)=(Mils=300.00,Range=750)
    RangeTable(31)=(Mils=310.00,Range=765)
    RangeTable(32)=(Mils=320.00,Range=795)
    RangeTable(33)=(Mils=330.00,Range=810)
    RangeTable(34)=(Mils=340.00,Range=825)
    RangeTable(35)=(Mils=350.00,Range=845)
    RangeTable(36)=(Mils=360.00,Range=870)
    RangeTable(37)=(Mils=370.00,Range=885)
    RangeTable(38)=(Mils=380.00,Range=900)
    RangeTable(39)=(Mils=390.00,Range=915)
    RangeTable(40)=(Mils=400.00,Range=940)
    RangeTable(41)=(Mils=410.00,Range=955)
    RangeTable(42)=(Mils=420.00,Range=975)
    RangeTable(43)=(Mils=430.00,Range=985)
    RangeTable(44)=(Mils=440.00,Range=1005)
    RangeTable(45)=(Mils=450.00,Range=1020)
    RangeTable(46)=(Mils=460.00,Range=1035)
    RangeTable(47)=(Mils=470.00,Range=1055)
    RangeTable(48)=(Mils=480.00,Range=1065)
    RangeTable(49)=(Mils=490.00,Range=1075)
    RangeTable(50)=(Mils=500.00,Range=1095)
    RangeTable(51)=(Mils=510.00,Range=1105)
    RangeTable(52)=(Mils=520.00,Range=1120)
    RangeTable(53)=(Mils=530.00,Range=1130)
    RangeTable(54)=(Mils=540.00,Range=1145)
    RangeTable(55)=(Mils=550.00,Range=1155)
    RangeTable(56)=(Mils=560.00,Range=1165)
    RangeTable(57)=(Mils=570.00,Range=1180)
    RangeTable(58)=(Mils=580.00,Range=1185)
    RangeTable(59)=(Mils=590.00,Range=1195)
    RangeTable(60)=(Mils=600.00,Range=1205)
    RangeTable(61)=(Mils=610.00,Range=1215)
    RangeTable(62)=(Mils=620.00,Range=1220)
    RangeTable(63)=(Mils=630.00,Range=1225)
    RangeTable(64)=(Mils=640.00,Range=1235)
}