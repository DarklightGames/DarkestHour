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
    RangeTable(0)=(Degrees=0,Range=35)
    RangeTable(1)=(Degrees=10,Range=45)
    RangeTable(2)=(Degrees=20,Range=80)
    RangeTable(3)=(Degrees=30,Range=95)
    RangeTable(4)=(Degrees=40,Range=125)
    RangeTable(5)=(Degrees=50,Range=150)
    RangeTable(6)=(Degrees=60,Range=170)
    RangeTable(7)=(Degrees=70,Range=195)
    RangeTable(8)=(Degrees=80,Range=215)
    RangeTable(9)=(Degrees=90,Range=230)
    RangeTable(10)=(Degrees=100,Range=270)
    RangeTable(11)=(Degrees=110,Range=280)
    RangeTable(12)=(Degrees=120,Range=310)
    RangeTable(13)=(Degrees=130,Range=345)
    RangeTable(14)=(Degrees=140,Range=370)
    RangeTable(15)=(Degrees=150,Range=395)
    RangeTable(16)=(Degrees=160,Range=430)
    RangeTable(17)=(Degrees=170,Range=450)
    RangeTable(18)=(Degrees=180,Range=470)
    RangeTable(19)=(Degrees=190,Range=485)
    RangeTable(20)=(Degrees=200,Range=515)
    RangeTable(21)=(Degrees=210,Range=550)
    RangeTable(22)=(Degrees=220,Range=570)
    RangeTable(23)=(Degrees=230,Range=595)
    RangeTable(24)=(Degrees=240,Range=615)
    RangeTable(25)=(Degrees=250,Range=635)
    RangeTable(26)=(Degrees=260,Range=650)
    RangeTable(27)=(Degrees=270,Range=675)
    RangeTable(28)=(Degrees=280,Range=705)
    RangeTable(29)=(Degrees=290,Range=725)
    RangeTable(30)=(Degrees=300,Range=750)
    RangeTable(31)=(Degrees=310,Range=765)
    RangeTable(32)=(Degrees=320,Range=795)
    RangeTable(33)=(Degrees=330,Range=810)
    RangeTable(34)=(Degrees=340,Range=825)
    RangeTable(35)=(Degrees=350,Range=845)
    RangeTable(36)=(Degrees=360,Range=870)
    RangeTable(37)=(Degrees=370,Range=885)
    RangeTable(38)=(Degrees=380,Range=900)
    RangeTable(39)=(Degrees=390,Range=915)
    RangeTable(40)=(Degrees=400,Range=940)
    RangeTable(41)=(Degrees=410,Range=955)
    RangeTable(42)=(Degrees=420,Range=975)
    RangeTable(43)=(Degrees=430,Range=985)
    RangeTable(44)=(Degrees=440,Range=1005)
    RangeTable(45)=(Degrees=450,Range=1020)
    RangeTable(46)=(Degrees=460,Range=1035)
    RangeTable(47)=(Degrees=470,Range=1055)
    RangeTable(48)=(Degrees=480,Range=1065)
    RangeTable(49)=(Degrees=490,Range=1075)
    RangeTable(50)=(Degrees=500,Range=1095)
    RangeTable(51)=(Degrees=510,Range=1105)
    RangeTable(52)=(Degrees=520,Range=1120)
    RangeTable(53)=(Degrees=530,Range=1130)
    RangeTable(54)=(Degrees=540,Range=1145)
    RangeTable(55)=(Degrees=550,Range=1155)
    RangeTable(56)=(Degrees=560,Range=1165)
    RangeTable(57)=(Degrees=570,Range=1180)
    RangeTable(58)=(Degrees=580,Range=1185)
    RangeTable(59)=(Degrees=590,Range=1195)
    RangeTable(60)=(Degrees=600,Range=1205)
    RangeTable(61)=(Degrees=610,Range=1215)
    RangeTable(62)=(Degrees=620,Range=1220)
    RangeTable(63)=(Degrees=630,Range=1225)
    RangeTable(64)=(Degrees=640,Range=1235)
    AngleUnit = "mils"
}