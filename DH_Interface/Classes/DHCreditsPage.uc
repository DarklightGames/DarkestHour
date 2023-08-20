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

    // TODO: Build the credit lines from lists of a categorized list.
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
    CreditLines(87)="Enfield"
    CreditLines(88)=""
    CreditLines(89)="Level Design:"
    CreditLines(90)=""
    CreditLines(91)="Theel"
    CreditLines(92)="SchutzeSepp"
    CreditLines(93)="Razorneck"
    CreditLines(94)="BOH-rekrut"
    CreditLines(95)="Jorg Biermann"
    CreditLines(96)="Exocet"
    CreditLines(97)="Nestor Makhno"
    CreditLines(98)="602RAF_Puff"
    CreditLines(99)="Drecks"
    CreditLines(100)="FlashPanHunter"
    CreditLines(101)="Jeff Duquette"
    CreditLines(102)="Sichartshofen"
    CreditLines(103)="kashash"
    CreditLines(104)="EvilHobo"
    CreditLines(105)="TWB*RedYager and TWB*JimMiller"
    CreditLines(106)="Ravelo"
    CreditLines(107)="dolas"
    CreditLines(108)="Bäckis"
    CreditLines(109)="WOLFkraut"
    CreditLines(110)="Cpt.Caverne"
    CreditLines(111)="Mad.Death.Hound"
    CreditLines(112)="John Davidson"
    CreditLines(113)=""
    CreditLines(114)="Sound:"
    CreditLines(115)=""
    CreditLines(116)="Fennich_FJR6"
    CreditLines(117)="Blitzkreig"
    CreditLines(118)="Wiseq"
    CreditLines(119)="Boone"
    CreditLines(120)="Demonizer"
    CreditLines(121)="PsYcH0_Ch!cKeN"
    CreditLines(122)="Shurek"
    CreditLines(123)="602RAF_Puff"
    CreditLines(124)="engineer"
    CreditLines(125)="pillam"
    CreditLines(126)="Logan Laidlaw"
    CreditLines(127)="jmoney"
    CreditLines(128)="Nathan B. Lewis"
    CreditLines(129)="AAZ"
    CreditLines(130)=""
    CreditLines(131)="Community Admins:"
    CreditLines(132)=""
    CreditLines(133)="Colonel_Ironnuts"
    CreditLines(134)="toaster"
    CreditLines(135)="Sugardust"
    CreditLines(136)="Wittmann"
    CreditLines(137)=""
    CreditLines(138)="Past Patreon Supporters:"
    CreditLines(139)=""
    CreditLines(140)="-[SiN]-Titus"
    CreditLines(141)=".Reflected."
    CreditLines(142)="[DNR]Gun4hire"
    CreditLines(143)="8BitWarrior"
    CreditLines(144)="Brian Briggs"
    CreditLines(145)="Caleb Coates"
    CreditLines(146)="clad"
    CreditLines(147)="Clay McCarty"
    CreditLines(148)="Duncan Langford"
    CreditLines(149)="Frank Baele"
    CreditLines(150)="Garth Davis"
    CreditLines(151)="Glock Shanty"
    CreditLines(152)="Jeffrey Allan Beeler"
    CreditLines(153)="John Ciccariello"
    CreditLines(154)="Josef Erik Sedlácek"
    CreditLines(155)="Joshua Dressel"
    CreditLines(156)="Justin Hall"
    CreditLines(157)="Keith Olson"
    CreditLines(158)="Kevin Vones"
    CreditLines(159)="KS"
    CreditLines(160)="Mal"
    CreditLines(161)="Mikolaj Stefan"
    CreditLines(162)="Munakoiso"
    CreditLines(163)="Peter Senzamici"
    CreditLines(164)="PFC Patison [29th ID]"
    CreditLines(165)="ProjectMouthwash"
    CreditLines(166)="Rawhide"
    CreditLines(167)="Remington Spooner"
    CreditLines(168)="Robert Morra"
    CreditLines(169)="Saferight"
    CreditLines(170)="Sean Gift"
    CreditLines(171)="Zhang Han"
    CreditLines(172)=""
    CreditLines(173)="Other Contributors:"
    CreditLines(174)=""
    CreditLines(175)="After-Hourz Gaming Network"
    CreditLines(176)="All the lads from Splat"
    CreditLines(177)="The Wild Bunch"
    CreditLines(178)="Schneller"
    CreditLines(179)="Beppo and the lads from Sentry Studios"
    CreditLines(180)="Amizaur for vehicle optics code and German vehicle gun sights"
    CreditLines(181)="Thommy-L (Fatal Error)"
    CreditLines(182)="Carpathian Crosses Team"
    CreditLines(183)="Torben 'thens' Hensgens"
    CreditLines(184)="29th Infantry Division"
    CreditLines(185)="Good Guys Gaming Community"
    CreditLines(186)="ChrisMo1944"
    CreditLines(187)=""
    CreditLines(188)="Special Thanks:"
    CreditLines(189)=""
    CreditLines(190)="A huge thanks goes out to all the former members of the Darklight Games team. Without their years of hard work, we would never have made it to this point. We're eternally grateful."
    CreditLines(191)="All of our testers over the years. You've helped create a (mostly) bug free experience!"
    CreditLines(192)="Alan, John, Dayle & all the guys at Tripwire Interactive for their assistance, support, and of course for the game that we all love so much."
    CreditLines(193)="Our faithful community who has stuck by us over the years and continue to offer support and ideas for the betterment of the game."
    CreditLines(194)="And to everyone else who has contributed to this mod over the years that we may have missed, thank you!"

    bRequire640x480=false
    WinTop=0.1
    WinLeft=0.1
    WinWidth=0.8
    WinHeight=0.8
}
