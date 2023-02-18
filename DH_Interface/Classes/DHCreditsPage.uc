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
    CreditLines(4)="Colin Basnett"
    CreditLines(5)="dirtybirdy"
    CreditLines(6)="Matty"
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
    CreditLines(74)="Patison"
    CreditLines(75)="Seven"
    CreditLines(76)=""
    CreditLines(77)="Animations:"
    CreditLines(78)=""
    CreditLines(79)="Exocet"
    CreditLines(80)="Mike Munk (TWI)"
    CreditLines(81)="TT33"
    CreditLines(82)="Razorneck"
    CreditLines(83)="AAZ"
    CreditLines(84)="Aarón Q.V."
    CreditLines(85)="Colin Basnett"
    CreditLines(86)="dirtybirdy"
    CreditLines(87)=""
    CreditLines(88)="Level Design:"
    CreditLines(89)=""
    CreditLines(90)="Theel"
    CreditLines(91)="SchutzeSepp"
    CreditLines(92)="Razorneck"
    CreditLines(93)="BOH-rekrut"
    CreditLines(94)="Jorg Biermann"
    CreditLines(95)="Exocet"
    CreditLines(96)="Nestor Makhno"
    CreditLines(97)="602RAF_Puff"
    CreditLines(98)="Drecks"
    CreditLines(99)="FlashPanHunter"
    CreditLines(100)="Jeff Duquette"
    CreditLines(101)="Sichartshofen"
    CreditLines(102)="kashash"
    CreditLines(103)="EvilHobo"
    CreditLines(104)="TWB*RedYager and TWB*JimMiller"
    CreditLines(105)="Ravelo"
    CreditLines(106)="dolas"
    CreditLines(107)="Bäckis"
    CreditLines(108)="WOLFkraut"
    CreditLines(109)="Cpt.Caverne"
    CreditLines(110)="Mad.Death.Hound"
    CreditLines(111)="John Davidson"
    CreditLines(112)=""
    CreditLines(113)="Sound:"
    CreditLines(114)=""
    CreditLines(115)="Fennich_FJR6"
    CreditLines(116)="Blitzkreig"
    CreditLines(117)="Wiseq"
    CreditLines(118)="Boone"
    CreditLines(119)="Demonizer"
    CreditLines(120)="PsYcH0_Ch!cKeN"
    CreditLines(121)="Shurek"
    CreditLines(122)="602RAF_Puff"
    CreditLines(123)="engineer"
    CreditLines(124)="pillam"
    CreditLines(125)="Logan Laidlaw"
    CreditLines(126)="jmoney"
    CreditLines(127)="Nathan B. Lewis"
    CreditLines(128)="AAZ"
    CreditLines(129)=""
    CreditLines(130)="Community Admins:"
    CreditLines(131)=""
    CreditLines(132)="Colonel_Ironnuts"
    CreditLines(133)="toaster"
    CreditLines(134)="Sugardust"
    CreditLines(135)="Wittmann"
    CreditLines(136)=""
    CreditLines(137)="Past Patreon Supporters:"
    CreditLines(138)=""
    CreditLines(139)="-[SiN]-Titus"
    CreditLines(140)=".Reflected."
    CreditLines(141)="[DNR]Gun4hire"
    CreditLines(142)="8BitWarrior"
    CreditLines(143)="Brian Briggs"
    CreditLines(144)="Caleb Coates"
    CreditLines(145)="clad"
    CreditLines(146)="Clay McCarty"
    CreditLines(147)="Duncan Langford"
    CreditLines(148)="Frank Baele"
    CreditLines(149)="Garth Davis"
    CreditLines(150)="Glock Shanty"
    CreditLines(151)="Jeffrey Allan Beeler"
    CreditLines(152)="John Ciccariello"
    CreditLines(153)="Josef Erik Sedlácek"
    CreditLines(154)="Joshua Dressel"
    CreditLines(155)="Justin Hall"
    CreditLines(156)="Keith Olson"
    CreditLines(157)="Kevin Vones"
    CreditLines(158)="KS"
    CreditLines(159)="Mal"
    CreditLines(160)="Mikolaj Stefan"
    CreditLines(161)="Munakoiso"
    CreditLines(162)="Peter Senzamici"
    CreditLines(163)="PFC Patison [29th ID]"
    CreditLines(164)="ProjectMouthwash"
    CreditLines(165)="Rawhide"
    CreditLines(166)="Remington Spooner"
    CreditLines(167)="Robert Morra"
    CreditLines(168)="Saferight"
    CreditLines(169)="Sean Gift"
    CreditLines(170)="Zhang Han"
    CreditLines(171)=""
    CreditLines(172)="Other Contributors:"
    CreditLines(173)=""
    CreditLines(174)="After-Hourz Gaming Network"
    CreditLines(175)="All the lads from Splat"
    CreditLines(176)="The Wild Bunch"
    CreditLines(177)="Schneller"
    CreditLines(178)="Beppo and the lads from Sentry Studios"
    CreditLines(179)="Amizaur for vehicle optics code and German vehicle gun sights"
    CreditLines(180)="Thommy-L (Fatal Error)"
    CreditLines(181)="Carpathian Crosses Team"
    CreditLines(182)="Torben 'thens' Hensgens"
    CreditLines(183)="29th Infantry Division"
    CreditLines(184)="Good Guys Gaming Community"
    CreditLines(185)="ChrisMo1944"
    CreditLines(186)=""
    CreditLines(187)="Special Thanks:"
    CreditLines(188)=""
    CreditLines(189)="A huge thanks goes out to all the former members of the Darklight Games team. Without their years of hard work, we would never have made it to this point. We're eternally grateful."
    CreditLines(190)="All of our testers over the years. You've helped create a (mostly) bug free experience!"
    CreditLines(191)="Alan, John, Dayle & all the guys at Tripwire Interactive for their assistance, support, and of course for the game that we all love so much."
    CreditLines(192)="Our faithful community who has stuck by us over the years and continue to offer support and ideas for the betterment of the game."
    CreditLines(193)="And to everyone else who has contributed to this mod over the years that we may have missed, thank you!"

    bRequire640x480=false
    WinTop=0.1
    WinLeft=0.1
    WinWidth=0.8
    WinHeight=0.8
}
