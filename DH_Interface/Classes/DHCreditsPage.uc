//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2021
//==============================================================================

class DHCreditsPage extends LargeWindow;

var automated GUIButton b_Close;
var automated GUIScrollTextBox lb_Credits;

var localized array<string> CreditLines;

function AddSystemMenu(){}

function InitComponent(GUIController MyController, GUIComponent MyOwner)
{
    local int i;
    local string S;

    super.InitComponent(MyController, MyOwner);

    class'DHInterfaceUtil'.static.SetROStyle(MyController, Controls);

    for (i = 0; i < CreditLines.Length; ++i)
    {
        S $= CreditLines[i] $ "|";
    }

    lb_Credits.SetContent(S);
}

function bool InternalOnClick(GUIComponent Sender)
{
    if (Sender == b_Close)
    {
        Controller.CloseMenu();
    }

    return true;
}

function bool ButtonClick(GUIComponent Sender)
{
    if (Sender == b_Close)
    {
        Controller.CloseMenu();
    }

    return true;
}

defaultproperties
{
    Begin Object Class=GUIButton Name=CloseButton
        Caption="Close"
        StyleName="DHMenuTextButtonStyle"
        WinTop=0.9
        WinLeft=0.4
        WinWidth=0.2
        bBoundToParent=true
        OnClick=DHCreditsPage.InternalOnClick
        OnKeyEvent=CloseButton.InternalOnKeyEvent
    End Object
    b_Close=GUIButton'DH_Interface.DHCreditsPage.CloseButton'
    Begin Object Class=DHGUIScrollTextBox Name=CreditText
        bNoTeletype=true
        OnCreateComponent=CreditText.InternalOnCreateComponent
        StyleName="DHLargeText"
        WinTop=0.08
        WinLeft=0.07
        WinWidth=0.86
        WinHeight=0.8
        bBoundToParent=true
        bScaleToParent=true
    End Object
    lb_Credits=DHGUIScrollTextBox'DH_Interface.DHCreditsPage.CreditText'

    Begin Object Class=DHGUIHeader Name=TitleBar
        StyleName="DHLargeText"
        WinTop=0.02
        WinHeight=0.05
        RenderWeight=0.1
        bBoundToParent=true
        bScaleToParent=true
        bAcceptsInput=true
        bNeverFocus=false
        ScalingType=SCALE_X
        OnMousePressed=DHCreditsPage.FloatingMousePressed
        OnMouseRelease=DHCreditsPage.FloatingMouseRelease
    End Object
    t_WindowTitle=DHGUIHeader'DH_Interface.DHCreditsPage.TitleBar'
    WindowName="Credits"
    Begin Object Class=FloatingImage Name=FloatingFrameBackground
        Image=Texture'DH_GUI_Tex.Menu.DHDisplay_withcaption_noAlpha'
        DropShadow=none
        ImageStyle=ISTY_Stretched
        ImageRenderStyle=MSTY_Normal
        WinTop=0.02
        WinLeft=0.0
        WinWidth=1.0
        WinHeight=0.98
        RenderWeight=0.000003
    End Object
    i_FrameBG=FloatingImage'DH_Interface.DHCreditsPage.FloatingFrameBackground'

    CreditLines(0)="DARKEST HOUR: EUROPE '44-'45"
    CreditLines(1)=""
    CreditLines(2)="Project Leads:"
    CreditLines(3)=""
    CreditLines(4)="dirtybirdy"
    CreditLines(5)="Colin Basnett"
    CreditLines(6)="Theel"
    CreditLines(7)="Exocet"
    CreditLines(8)=""
    CreditLines(9)="Code:"
    CreditLines(10)=""
    CreditLines(11)="Colin Basnett"
    CreditLines(12)="Matt UK"
    CreditLines(13)="Theel"
    CreditLines(14)="Shurek"
    CreditLines(15)="PsYcH0_Ch!cKeN"
    CreditLines(16)="dirtybirdy"
    CreditLines(17)="Daniel Mann"
    CreditLines(18)="mimi~"
    CreditLines(19)="Hopkins"
    CreditLines(20)="Teufelhund"
    CreditLines(21)="Fennich_FJR6"
    CreditLines(22)="jmoney"
    CreditLines(23)=""
    CreditLines(24)="Art Coordinator:"
    CreditLines(25)="Patison"
    CreditLines(26)=""
    CreditLines(27)="Models:"
    CreditLines(28)=""
    CreditLines(29)="RustIronCrowe"
    CreditLines(30)="Apekop"
    CreditLines(31)="Coyote Ninja"
    CreditLines(32)="Diablo"
    CreditLines(33)="Garisson"
    CreditLines(34)="Maharzan"
    CreditLines(35)="Nights2o06"
    CreditLines(36)="ScubaSteve"
    CreditLines(37)="Silence14"
    CreditLines(38)="Tman"
    CreditLines(39)="2_k"
    CreditLines(40)="FooBar"
    CreditLines(41)="DmitriB"
    CreditLines(42)="Captain Obvious"
    CreditLines(43)="piotrlukasik"
    CreditLines(44)="Theel"
    CreditLines(45)="Respio"
    CreditLines(46)="AAZ"
    CreditLines(47)="Mechanic"
    CreditLines(48)="eksha"
    CreditLines(49)="Leyawynn"
    CreditLines(50)="Matty"
    CreditLines(51)="Napoleon Blownapart"
    CreditLines(52)="Pvt.Winter"
    CreditLines(53)=""
    CreditLines(54)="Textures:"
    CreditLines(55)=""
    CreditLines(56)="Protector"
    CreditLines(57)="Aeneas2020"
    CreditLines(58)="Blacklabel"
    CreditLines(59)="Fennich_FJR6"
    CreditLines(60)="FooBar"
    CreditLines(61)="CYoung"
    CreditLines(62)="Captain Obvious"
    CreditLines(63)="piotrlukasik"
    CreditLines(64)="Theel"
    CreditLines(65)="Groundwaffe"
    CreditLines(66)="Matty"
    CreditLines(67)=""
    CreditLines(68)="Art:"
    CreditLines(69)=""
    CreditLines(70)="Der Landser"
    CreditLines(71)="Protector"
    CreditLines(72)="Aeneas2020"
    CreditLines(73)="Fennich_FJR6"
    CreditLines(74)=""
    CreditLines(75)="Animations:"
    CreditLines(76)=""
    CreditLines(77)="Exocet"
    CreditLines(78)="Mike Munk (TWI)"
    CreditLines(79)="TT33"
    CreditLines(80)="Razorneck"
    CreditLines(81)="AAZ"
    CreditLines(82)=""
    CreditLines(83)="Level Design:"
    CreditLines(84)=""
    CreditLines(85)="Theel"
    CreditLines(86)="SchutzeSepp"
    CreditLines(87)="Razorneck"
    CreditLines(88)="BOH-rekrut"
    CreditLines(89)="Jorg Biermann"
    CreditLines(90)="Exocet"
    CreditLines(91)="Nestor Makhno"
    CreditLines(92)="602RAF_Puff"
    CreditLines(93)="Drecks"
    CreditLines(94)="FlashPanHunter"
    CreditLines(95)="Jeff Duquette"
    CreditLines(96)="Sichartshofen"
    CreditLines(97)="kashash"
    CreditLines(98)="EvilHobo"
    CreditLines(99)="TWB*RedYager and TWB*JimMiller"
    CreditLines(100)="Ravelo"
    CreditLines(101)="dolas"
    CreditLines(102)="Bäckis"
    CreditLines(103)="WOLFkraut"
    CreditLines(104)="Cpt.Caverne"
    CreditLines(105)=""
    CreditLines(106)="Sound:"
    CreditLines(107)=""
    CreditLines(108)="Fennich_FJR6"
    CreditLines(109)="Blitzkreig"
    CreditLines(110)="Wiseq"
    CreditLines(111)="Boone"
    CreditLines(112)="Demonizer"
    CreditLines(113)="PsYcH0_Ch!cKeN"
    CreditLines(114)="Shurek"
    CreditLines(115)="602RAF_Puff"
    CreditLines(116)="engineer"
    CreditLines(117)="pillam"
    CreditLines(118)="Logan Laidlaw"
    CreditLines(119)="jmoney"
    CreditLines(120)="Nathan B. Lewis"
    CreditLines(121)="AAZ"
    CreditLines(122)=""
    CreditLines(123)="Community Admins:"
    CreditLines(124)=""
    CreditLines(125)="Colonel_Ironnuts"
    CreditLines(126)="toaster"
    CreditLines(127)="Sugardust"
    CreditLines(128)="Wittmann"
    CreditLines(129)=""
    CreditLines(130)="Past Patreon Supporters:"
    CreditLines(131)=""
    CreditLines(132)="-[SiN]-Titus"
    CreditLines(133)=".Reflected."
    CreditLines(134)="[DNR]Gun4hire"
    CreditLines(135)="8BitWarrior"
    CreditLines(136)="Brian Briggs"
    CreditLines(137)="Caleb Coates"
    CreditLines(138)="clad"
    CreditLines(139)="Clay McCarty"
    CreditLines(140)="Duncan Langford"
    CreditLines(141)="Frank Baele"
    CreditLines(142)="Garth Davis"
    CreditLines(143)="Glock Shanty"
    CreditLines(144)="Jeffrey Allan Beeler"
    CreditLines(145)="John Ciccariello"
    CreditLines(146)="Josef Erik Sedlácek"
    CreditLines(147)="Joshua Dressel"
    CreditLines(148)="Justin Hall"
    CreditLines(149)="Keith Olson"
    CreditLines(150)="Kevin Vones"
    CreditLines(151)="KS"
    CreditLines(152)="Mal"
    CreditLines(153)="Mikolaj Stefan"
    CreditLines(154)="Munakoiso"
    CreditLines(155)="Peter Senzamici"
    CreditLines(156)="PFC Patison [29th ID]"
    CreditLines(157)="ProjectMouthwash"
    CreditLines(158)="Rawhide"
    CreditLines(159)="Remington Spooner"
    CreditLines(160)="Robert Morra"
    CreditLines(161)="Saferight"
    CreditLines(162)="Sean Gift"
    CreditLines(163)="Zhang Han"
    CreditLines(164)=""
    CreditLines(165)="Other Contributors:"
    CreditLines(166)=""
    CreditLines(167)="After-Hourz Gaming Network"
    CreditLines(168)="All the lads from Splat"
    CreditLines(169)="The Wild Bunch"
    CreditLines(170)="Schneller"
    CreditLines(171)="Beppo and the lads from Sentry Studios"
    CreditLines(172)="Amizaur for vehicle optics code and German vehicle gun sights"
    CreditLines(173)="Thommy-L (Fatal Error)"
    CreditLines(174)="Carpathian Crosses Team"
    CreditLines(175)="Torben 'thens' Hensgens"
    CreditLines(176)="29th Infantry Division"
    CreditLines(177)="Good Guys Gaming Community"
    CreditLines(178)="ChrisMo1944"
    CreditLines(179)=""
    CreditLines(180)="Special Thanks:"
    CreditLines(181)=""
    CreditLines(182)="A huge thanks goes out to all the former members of the Darklight Games team. Without their years of hard work, we would never have made it to this point. We're eternally grateful."
    CreditLines(183)="All of our testers over the years. You've helped create a (mostly) bug free experience!"
    CreditLines(184)="Alan, John, Dayle & all the guys at Tripwire Interactive for their assistance, support, and of course for the game that we all love so much."
    CreditLines(185)="Our faithful community who has stuck by us over the years and continue to offer support and ideas for the betterment of the game."
    CreditLines(186)="And to everyone else who has contributed to this mod over the years that we may have missed, thank you!"

    bRequire640x480=false
    WinTop=0.1
    WinLeft=0.1
    WinWidth=0.8
    WinHeight=0.8
}
