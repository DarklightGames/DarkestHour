//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2018
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
    CreditLines(16)="Hopkins"
    CreditLines(17)="Teufelhund"
    CreditLines(18)="Fennich_FJR6"
    CreditLines(19)="jmoney"
    CreditLines(20)=""
    CreditLines(21)="Models:"
    CreditLines(22)=""
    CreditLines(23)="RustIronCrowe"
    CreditLines(24)="Apekop"
    CreditLines(25)="Coyote Ninja"
    CreditLines(26)="Diablo"
    CreditLines(27)="Garisson"
    CreditLines(28)="Maharzan"
    CreditLines(29)="Nights2o06"
    CreditLines(30)="ScubaSteve"
    CreditLines(31)="Silence14"
    CreditLines(32)="Tman"
    CreditLines(33)="2_k"
    CreditLines(34)="FooBar"
    CreditLines(35)="DmitriB"
    CreditLines(36)="Captain Obvious"
    CreditLines(37)="piotrlukasik"
    CreditLines(38)="Theel"
    CreditLines(39)="Respio"
    CreditLines(40)=""
    CreditLines(41)="Textures:"
    CreditLines(42)=""
    CreditLines(43)="Protector"
    CreditLines(44)="Aeneas2020"
    CreditLines(45)="Blacklabel"
    CreditLines(46)="Fennich_FJR6"
    CreditLines(47)="FooBar"
    CreditLines(48)="CYoung"
    CreditLines(49)="Captain Obvious"
    CreditLines(50)="piotrlukasik"
    CreditLines(51)="Theel"
    CreditLines(52)="Groundwaffe"
    CreditLines(53)=""
    CreditLines(54)="Art:"
    CreditLines(55)=""
    CreditLines(56)="Der Landser"
    CreditLines(57)="Protector"
    CreditLines(58)="Aeneas2020"
    CreditLines(59)="Fennich_FJR6"
    CreditLines(60)=""
    CreditLines(61)="Animations:"
    CreditLines(62)=""
    CreditLines(63)="Exocet"
    CreditLines(64)="Mike Munk (TWI)"
    CreditLines(65)="TT33"
    CreditLines(66)="Razorneck"
    CreditLines(67)=""
    CreditLines(68)="Level Design:"
    CreditLines(69)=""
    CreditLines(70)="Theel"
    CreditLines(71)="SchutzeSepp"
    CreditLines(72)="Razorneck"
    CreditLines(73)="BOH-rekrut"
    CreditLines(74)="Jorg Biermann"
    CreditLines(75)="Exocet"
    CreditLines(76)="Nestor Makhno"
    CreditLines(77)="602RAF_Puff"
    CreditLines(78)="Drecks"
    CreditLines(79)="FlashPanHunter"
    CreditLines(80)="Jeff Duquette"
    CreditLines(81)="Sichartshofen"
    CreditLines(82)="kashash"
    CreditLines(83)="EvilHobo"
    CreditLines(84)="TWB*RedYager and TWB*JimMiller"
    CreditLines(85)="Ravelo"
    CreditLines(86)=""
    CreditLines(87)="Sound:"
    CreditLines(88)=""
    CreditLines(89)="Fennich_FJR6"
    CreditLines(90)="Blitzkreig"
    CreditLines(91)="Wiseq"
    CreditLines(92)="Boone"
    CreditLines(93)="Demonizer"
    CreditLines(94)="PsYcH0_Ch!cKeN"
    CreditLines(95)="Shurek"
    CreditLines(96)="602RAF_Puff"
    CreditLines(97)="engineer"
    CreditLines(98)="pillam"
    CreditLines(99)="Logan Laidlaw"
    CreditLines(100)="jmoney"
    CreditLines(101)="Nathan B. Lewis"
    CreditLines(102)=""
    CreditLines(103)="Past Patreon Supporters:"
    CreditLines(104)=""
    CreditLines(105)="-[SiN]-Titus"
    CreditLines(106)=".Reflected."
    CreditLines(107)="[DNR]Gun4hire"
    CreditLines(108)="8BitWarrior"
    CreditLines(109)="Brian Briggs"
    CreditLines(110)="Caleb Coates"
    CreditLines(111)="clad"
    CreditLines(112)="Clay McCarty"
    CreditLines(113)="Duncan Langford"
    CreditLines(114)="Frank Baele"
    CreditLines(115)="Garth Davis"
    CreditLines(116)="Glock Shanty"
    CreditLines(117)="Jeffrey Allan Beeler"
    CreditLines(118)="John Ciccariello"
    CreditLines(119)="Josef Erik Sedlácek"
    CreditLines(120)="Joshua Dressel"
    CreditLines(121)="Justin Hall"
    CreditLines(122)="Keith Olson"
    CreditLines(123)="Kevin Vones"
    CreditLines(124)="KS"
    CreditLines(125)="Mal"
    CreditLines(126)="Mikolaj Stefan"
    CreditLines(127)="Munakoiso"
    CreditLines(128)="Peter Senzamici"
    CreditLines(129)="PFC Patison [29th ID]"
    CreditLines(130)="ProjectMouthwash"
    CreditLines(131)="Rawhide"
    CreditLines(132)="Remington Spooner"
    CreditLines(133)="Robert Morra"
    CreditLines(134)="Saferight"
    CreditLines(135)="Sean Gift"
    CreditLines(136)="Zhang Han"
    CreditLines(137)=""
    CreditLines(138)="Other Contributors:"
    CreditLines(139)=""
    CreditLines(140)="After-Hourz Gaming Network"
    CreditLines(141)="All the lads from Splat"
    CreditLines(142)="The Wild Bunch"
    CreditLines(143)="Schneller"
    CreditLines(144)="Beppo and the lads from Sentry Studios"
    CreditLines(145)="Amizaur for vehicle optics code and German vehicle gun sights"
    CreditLines(146)="Thommy-L (Fatal Error)"
    CreditLines(147)="Carpathian Crosses Team"
    CreditLines(148)="Torben 'thens' Hensgens"
    CreditLines(149)="29th Infantry Division"
    CreditLines(150)="Good Guys Gaming Community"
    CreditLines(151)=""
    CreditLines(152)="Special Thanks:"
    CreditLines(153)=""
    CreditLines(154)="A huge thanks goes out to all the former members of the Darklight Games team. Without their years of hard work, we would never have made it to this point. We're eternally grateful."
    CreditLines(155)="All of our testers over the years. You've helped create a (mostly) bug free experience!"
    CreditLines(156)="Alan, John, Dayle & all the guys at Tripwire Interactive for their assistance, support, and of course for the game that we all love so much."
    CreditLines(157)="Our faithful community who has stuck by us over the years and continue to offer support and ideas for the betterment of the game."
    CreditLines(158)="And to everyone else who has contributed to this mod over the years that we may have missed, thank you!"

    bRequire640x480=false
    WinTop=0.1
    WinLeft=0.1
    WinWidth=0.8
    WinHeight=0.8
}
