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
    CreditLines(4)="Colin Basnett"
    CreditLines(5)="Theel"
    CreditLines(6)="Exocet"
    CreditLines(7)=""
    CreditLines(8)="Code:"
    CreditLines(9)=""
    CreditLines(10)="Colin Basnett"
    CreditLines(11)="Matt UK"
    CreditLines(12)="Theel"
    CreditLines(13)="Shurek"
    CreditLines(14)="PsYcH0_Ch!cKeN"
    CreditLines(15)="dirtybirdy"
    CreditLines(16)="Daniel Mann"
    CreditLines(17)="Hopkins"
    CreditLines(18)="Teufelhund"
    CreditLines(19)="Fennich_FJR6"
    CreditLines(20)="jmoney"
    CreditLines(21)=""
    CreditLines(22)="Models:"
    CreditLines(23)=""
    CreditLines(24)="RustIronCrowe"
    CreditLines(25)="Apekop"
    CreditLines(26)="Coyote Ninja"
    CreditLines(27)="Diablo"
    CreditLines(28)="Garisson"
    CreditLines(29)="Maharzan"
    CreditLines(30)="Nights2o06"
    CreditLines(31)="ScubaSteve"
    CreditLines(32)="Silence14"
    CreditLines(33)="Tman"
    CreditLines(34)="2_k"
    CreditLines(35)="FooBar"
    CreditLines(36)="DmitriB"
    CreditLines(37)="Captain Obvious"
    CreditLines(38)="piotrlukasik"
    CreditLines(39)="Theel"
    CreditLines(40)="Respio"
    CreditLines(41)=""
    CreditLines(42)="Textures:"
    CreditLines(43)=""
    CreditLines(44)="Protector"
    CreditLines(45)="Aeneas2020"
    CreditLines(46)="Blacklabel"
    CreditLines(47)="Fennich_FJR6"
    CreditLines(48)="FooBar"
    CreditLines(49)="CYoung"
    CreditLines(50)="Captain Obvious"
    CreditLines(51)="piotrlukasik"
    CreditLines(52)="Theel"
    CreditLines(53)="Groundwaffe"
    CreditLines(54)=""
    CreditLines(55)="Art:"
    CreditLines(56)=""
    CreditLines(57)="Der Landser"
    CreditLines(58)="Protector"
    CreditLines(59)="Aeneas2020"
    CreditLines(60)="Fennich_FJR6"
    CreditLines(61)=""
    CreditLines(62)="Animations:"
    CreditLines(63)=""
    CreditLines(64)="Exocet"
    CreditLines(65)="Mike Munk (TWI)"
    CreditLines(66)="TT33"
    CreditLines(67)="Razorneck"
    CreditLines(68)=""
    CreditLines(69)="Level Design:"
    CreditLines(70)=""
    CreditLines(71)="Theel"
    CreditLines(72)="SchutzeSepp"
    CreditLines(73)="Razorneck"
    CreditLines(74)="BOH-rekrut"
    CreditLines(75)="Jorg Biermann"
    CreditLines(76)="Exocet"
    CreditLines(77)="Nestor Makhno"
    CreditLines(78)="602RAF_Puff"
    CreditLines(79)="Drecks"
    CreditLines(80)="FlashPanHunter"
    CreditLines(81)="Jeff Duquette"
    CreditLines(82)="Sichartshofen"
    CreditLines(83)="kashash"
    CreditLines(84)="EvilHobo"
    CreditLines(85)="TWB*RedYager and TWB*JimMiller"
    CreditLines(86)="Ravelo"
    CreditLines(87)=""
    CreditLines(88)="Sound:"
    CreditLines(89)=""
    CreditLines(90)="Fennich_FJR6"
    CreditLines(91)="Blitzkreig"
    CreditLines(92)="Wiseq"
    CreditLines(93)="Boone"
    CreditLines(94)="Demonizer"
    CreditLines(95)="PsYcH0_Ch!cKeN"
    CreditLines(96)="Shurek"
    CreditLines(97)="602RAF_Puff"
    CreditLines(98)="engineer"
    CreditLines(99)="pillam"
    CreditLines(100)="Logan Laidlaw"
    CreditLines(101)="jmoney"
    CreditLines(102)="Nathan B. Lewis"
    CreditLines(103)=""
    CreditLines(104)="Past Patreon Supporters:"
    CreditLines(105)=""
    CreditLines(106)="-[SiN]-Titus"
    CreditLines(107)=".Reflected."
    CreditLines(108)="[DNR]Gun4hire"
    CreditLines(109)="8BitWarrior"
    CreditLines(110)="Brian Briggs"
    CreditLines(111)="Caleb Coates"
    CreditLines(112)="clad"
    CreditLines(113)="Clay McCarty"
    CreditLines(114)="Duncan Langford"
    CreditLines(115)="Frank Baele"
    CreditLines(116)="Garth Davis"
    CreditLines(117)="Glock Shanty"
    CreditLines(118)="Jeffrey Allan Beeler"
    CreditLines(119)="John Ciccariello"
    CreditLines(120)="Josef Erik Sedlácek"
    CreditLines(121)="Joshua Dressel"
    CreditLines(122)="Justin Hall"
    CreditLines(123)="Keith Olson"
    CreditLines(124)="Kevin Vones"
    CreditLines(125)="KS"
    CreditLines(126)="Mal"
    CreditLines(127)="Mikolaj Stefan"
    CreditLines(128)="Munakoiso"
    CreditLines(129)="Peter Senzamici"
    CreditLines(130)="PFC Patison [29th ID]"
    CreditLines(131)="ProjectMouthwash"
    CreditLines(132)="Rawhide"
    CreditLines(133)="Remington Spooner"
    CreditLines(134)="Robert Morra"
    CreditLines(135)="Saferight"
    CreditLines(136)="Sean Gift"
    CreditLines(137)="Zhang Han"
    CreditLines(138)=""
    CreditLines(139)="Other Contributors:"
    CreditLines(140)=""
    CreditLines(141)="After-Hourz Gaming Network"
    CreditLines(142)="All the lads from Splat"
    CreditLines(143)="The Wild Bunch"
    CreditLines(144)="Schneller"
    CreditLines(145)="Beppo and the lads from Sentry Studios"
    CreditLines(146)="Amizaur for vehicle optics code and German vehicle gun sights"
    CreditLines(147)="Thommy-L (Fatal Error)"
    CreditLines(148)="Carpathian Crosses Team"
    CreditLines(149)="Torben 'thens' Hensgens"
    CreditLines(150)="29th Infantry Division"
    CreditLines(151)="Good Guys Gaming Community"
    CreditLines(152)=""
    CreditLines(153)="Special Thanks:"
    CreditLines(154)=""
    CreditLines(155)="A huge thanks goes out to all the former members of the Darklight Games team. Without their years of hard work, we would never have made it to this point. We're eternally grateful."
    CreditLines(156)="All of our testers over the years. You've helped create a (mostly) bug free experience!"
    CreditLines(157)="Alan, John, Dayle & all the guys at Tripwire Interactive for their assistance, support, and of course for the game that we all love so much."
    CreditLines(158)="Our faithful community who has stuck by us over the years and continue to offer support and ideas for the betterment of the game."
    CreditLines(159)="And to everyone else who has contributed to this mod over the years that we may have missed, thank you!"

    bRequire640x480=false
    WinTop=0.1
    WinLeft=0.1
    WinWidth=0.8
    WinHeight=0.8
}
