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
    RangeTable(1)=(Pitch=10,Range=45)
    RangeTable(2)=(Pitch=20,Range=80)
    RangeTable(3)=(Pitch=30,Range=95)
    RangeTable(4)=(Pitch=40,Range=125)
    RangeTable(5)=(Pitch=50,Range=150)
    RangeTable(6)=(Pitch=60,Range=170)
    RangeTable(7)=(Pitch=70,Range=195)
    RangeTable(8)=(Pitch=80,Range=215)
    RangeTable(9)=(Pitch=90,Range=230)
    RangeTable(10)=(Pitch=100,Range=270)
    RangeTable(11)=(Pitch=110,Range=280)
    RangeTable(12)=(Pitch=120,Range=310)
    RangeTable(13)=(Pitch=130,Range=345)
    RangeTable(14)=(Pitch=140,Range=370)
    RangeTable(15)=(Pitch=150,Range=395)
    RangeTable(16)=(Pitch=160,Range=430)
    RangeTable(17)=(Pitch=170,Range=450)
    RangeTable(18)=(Pitch=180,Range=470)
    RangeTable(19)=(Pitch=190,Range=485)
    RangeTable(20)=(Pitch=200,Range=515)
    RangeTable(21)=(Pitch=210,Range=550)
    RangeTable(22)=(Pitch=220,Range=570)
    RangeTable(23)=(Pitch=230,Range=595)
    RangeTable(24)=(Pitch=240,Range=615)
    RangeTable(25)=(Pitch=250,Range=635)
    RangeTable(26)=(Pitch=260,Range=650)
    RangeTable(27)=(Pitch=270,Range=675)
    RangeTable(28)=(Pitch=280,Range=705)
    RangeTable(29)=(Pitch=290,Range=725)
    RangeTable(30)=(Pitch=300,Range=750)
    RangeTable(31)=(Pitch=310,Range=765)
    RangeTable(32)=(Pitch=320,Range=795)
    RangeTable(33)=(Pitch=330,Range=810)
    RangeTable(34)=(Pitch=340,Range=825)
    RangeTable(35)=(Pitch=350,Range=845)
    RangeTable(36)=(Pitch=360,Range=870)
    RangeTable(37)=(Pitch=370,Range=885)
    RangeTable(38)=(Pitch=380,Range=900)
    RangeTable(39)=(Pitch=390,Range=915)
    RangeTable(40)=(Pitch=400,Range=940)
    RangeTable(41)=(Pitch=410,Range=955)
    RangeTable(42)=(Pitch=420,Range=975)
    RangeTable(43)=(Pitch=430,Range=985)
    RangeTable(44)=(Pitch=440,Range=1005)
    RangeTable(45)=(Pitch=450,Range=1020)
    RangeTable(46)=(Pitch=460,Range=1035)
    RangeTable(47)=(Pitch=470,Range=1055)
    RangeTable(48)=(Pitch=480,Range=1065)
    RangeTable(49)=(Pitch=490,Range=1075)
    RangeTable(50)=(Pitch=500,Range=1095)
    RangeTable(51)=(Pitch=510,Range=1105)
    RangeTable(52)=(Pitch=520,Range=1120)
    RangeTable(53)=(Pitch=530,Range=1130)
    RangeTable(54)=(Pitch=540,Range=1145)
    RangeTable(55)=(Pitch=550,Range=1155)
    RangeTable(56)=(Pitch=560,Range=1165)
    RangeTable(57)=(Pitch=570,Range=1180)
    RangeTable(58)=(Pitch=580,Range=1185)
    RangeTable(59)=(Pitch=590,Range=1195)
    RangeTable(60)=(Pitch=600,Range=1205)
    RangeTable(61)=(Pitch=610,Range=1215)
    RangeTable(62)=(Pitch=620,Range=1220)
    RangeTable(63)=(Pitch=630,Range=1225)
    RangeTable(64)=(Pitch=640,Range=1235)
    AngleUnit = "mils"
}