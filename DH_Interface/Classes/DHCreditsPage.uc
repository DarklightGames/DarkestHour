//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
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
    CreditLines(82)="Aarón Q.V."
    CreditLines(83)=""
    CreditLines(84)="Level Design:"
    CreditLines(85)=""
    CreditLines(86)="Theel"
    CreditLines(87)="SchutzeSepp"
    CreditLines(88)="Razorneck"
    CreditLines(89)="BOH-rekrut"
    CreditLines(90)="Jorg Biermann"
    CreditLines(91)="Exocet"
    CreditLines(92)="Nestor Makhno"
    CreditLines(93)="602RAF_Puff"
    CreditLines(94)="Drecks"
    CreditLines(95)="FlashPanHunter"
    CreditLines(96)="Jeff Duquette"
    CreditLines(97)="Sichartshofen"
    CreditLines(98)="kashash"
    CreditLines(99)="EvilHobo"
    CreditLines(100)="TWB*RedYager and TWB*JimMiller"
    CreditLines(101)="Ravelo"
    CreditLines(102)="dolas"
    CreditLines(103)="Bäckis"
    CreditLines(104)="WOLFkraut"
    CreditLines(105)="Cpt.Caverne"
    CreditLines(106)=""
    CreditLines(107)="Sound:"
    CreditLines(108)=""
    CreditLines(109)="Fennich_FJR6"
    CreditLines(110)="Blitzkreig"
    CreditLines(111)="Wiseq"
    CreditLines(112)="Boone"
    CreditLines(113)="Demonizer"
    CreditLines(114)="PsYcH0_Ch!cKeN"
    CreditLines(115)="Shurek"
    CreditLines(116)="602RAF_Puff"
    CreditLines(117)="engineer"
    CreditLines(118)="pillam"
    CreditLines(119)="Logan Laidlaw"
    CreditLines(120)="jmoney"
    CreditLines(121)="Nathan B. Lewis"
    CreditLines(122)="AAZ"
    CreditLines(123)=""
    CreditLines(124)="Community Admins:"
    CreditLines(125)=""
    CreditLines(126)="Colonel_Ironnuts"
    CreditLines(127)="toaster"
    CreditLines(128)="Sugardust"
    CreditLines(129)="Wittmann"
    CreditLines(130)=""
    CreditLines(131)="Past Patreon Supporters:"
    CreditLines(132)=""
    CreditLines(133)="-[SiN]-Titus"
    CreditLines(134)=".Reflected."
    CreditLines(135)="[DNR]Gun4hire"
    CreditLines(136)="8BitWarrior"
    CreditLines(137)="Brian Briggs"
    CreditLines(138)="Caleb Coates"
    CreditLines(139)="clad"
    CreditLines(140)="Clay McCarty"
    CreditLines(141)="Duncan Langford"
    CreditLines(142)="Frank Baele"
    CreditLines(143)="Garth Davis"
    CreditLines(144)="Glock Shanty"
    CreditLines(145)="Jeffrey Allan Beeler"
    CreditLines(146)="John Ciccariello"
    CreditLines(147)="Josef Erik Sedlácek"
    CreditLines(148)="Joshua Dressel"
    CreditLines(149)="Justin Hall"
    CreditLines(150)="Keith Olson"
    CreditLines(151)="Kevin Vones"
    CreditLines(152)="KS"
    CreditLines(153)="Mal"
    CreditLines(154)="Mikolaj Stefan"
    CreditLines(155)="Munakoiso"
    CreditLines(156)="Peter Senzamici"
    CreditLines(157)="PFC Patison [29th ID]"
    CreditLines(158)="ProjectMouthwash"
    CreditLines(159)="Rawhide"
    CreditLines(160)="Remington Spooner"
    CreditLines(161)="Robert Morra"
    CreditLines(162)="Saferight"
    CreditLines(163)="Sean Gift"
    CreditLines(164)="Zhang Han"
    CreditLines(165)=""
    CreditLines(166)="Other Contributors:"
    CreditLines(167)=""
    CreditLines(168)="After-Hourz Gaming Network"
    CreditLines(169)="All the lads from Splat"
    CreditLines(170)="The Wild Bunch"
    CreditLines(171)="Schneller"
    CreditLines(172)="Beppo and the lads from Sentry Studios"
    CreditLines(173)="Amizaur for vehicle optics code and German vehicle gun sights"
    CreditLines(174)="Thommy-L (Fatal Error)"
    CreditLines(175)="Carpathian Crosses Team"
    CreditLines(176)="Torben 'thens' Hensgens"
    CreditLines(177)="29th Infantry Division"
    CreditLines(178)="Good Guys Gaming Community"
    CreditLines(179)="ChrisMo1944"
    CreditLines(180)=""
    CreditLines(181)="Special Thanks:"
    CreditLines(182)=""
    CreditLines(183)="A huge thanks goes out to all the former members of the Darklight Games team. Without their years of hard work, we would never have made it to this point. We're eternally grateful."
    CreditLines(184)="All of our testers over the years. You've helped create a (mostly) bug free experience!"
    CreditLines(185)="Alan, John, Dayle & all the guys at Tripwire Interactive for their assistance, support, and of course for the game that we all love so much."
    CreditLines(186)="Our faithful community who has stuck by us over the years and continue to offer support and ideas for the betterment of the game."
    CreditLines(187)="And to everyone else who has contributed to this mod over the years that we may have missed, thank you!"

    bRequire640x480=false
    WinTop=0.1
    WinLeft=0.1
    WinWidth=0.8
    WinHeight=0.8
}
