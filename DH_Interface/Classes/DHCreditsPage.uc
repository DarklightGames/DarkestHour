//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2017
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
        Image=texture'DH_GUI_Tex.Menu.DHDisplay_withcaption_noAlpha'
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
    CreditLines(15)="Hopkins"
    CreditLines(16)="Teufelhund"
    CreditLines(17)="Fennich_FJR6"
    CreditLines(18)="jmoney"
    CreditLines(19)=""
    CreditLines(20)="Models:"
    CreditLines(21)=""
    CreditLines(22)="RustIronCrowe"
    CreditLines(23)="Apekop"
    CreditLines(24)="Coyote Ninja"
    CreditLines(25)="Diablo"
    CreditLines(26)="Garisson"
    CreditLines(27)="Maharzan"
    CreditLines(28)="Nights2o06"
    CreditLines(29)="ScubaSteve"
    CreditLines(30)="Silence14"
    CreditLines(31)="Tman"
    CreditLines(32)="2_k"
    CreditLines(33)="FooBar"
    CreditLines(34)="DmitriB"
    CreditLines(35)="Captain Obvious"
    CreditLines(36)="piotrlukasik"
    CreditLines(37)="Theel"
    CreditLines(38)="Respio"
    CreditLines(39)=""
    CreditLines(40)="Textures:"
    CreditLines(41)=""
    CreditLines(42)="Protector"
    CreditLines(43)="Aeneas2020"
    CreditLines(44)="Blacklabel"
    CreditLines(45)="Fennich_FJR6"
    CreditLines(46)="FooBar"
    CreditLines(47)="CYoung"
    CreditLines(48)="Captain Obvious"
    CreditLines(49)="piotrlukasik"
    CreditLines(50)="Theel"
    CreditLines(51)="Groundwaffe"
    CreditLines(52)=""
    CreditLines(53)="Art:"
    CreditLines(54)=""
    CreditLines(55)="Der Landser"
    CreditLines(56)="Protector"
    CreditLines(57)="Aeneas2020"
    CreditLines(58)="Fennich_FJR6"
    CreditLines(59)=""
    CreditLines(60)="Animations:"
    CreditLines(61)=""
    CreditLines(62)="Exocet"
    CreditLines(63)="Mike Munk (TWI)"
    CreditLines(64)="TT33"
    CreditLines(65)="Razorneck"
    CreditLines(66)=""
    CreditLines(67)="Level Design:"
    CreditLines(68)=""
    CreditLines(69)="Theel"
    CreditLines(70)="SchutzeSepp"
    CreditLines(71)="Razorneck"
    CreditLines(72)="BOH-rekrut"
    CreditLines(73)="Jorg Biermann"
    CreditLines(74)="Exocet"
    CreditLines(75)="Nestor Makhno"
    CreditLines(76)="602RAF_Puff"
    CreditLines(77)="Drecks"
    CreditLines(78)="FlashPanHunter"
    CreditLines(79)="Jeff Duquette"
    CreditLines(80)="Sichartshofen"
    CreditLines(81)="Peter Klinger"
    CreditLines(82)="EvilHobo"
    CreditLines(83)="TWB*RedYager and TWB*JimMiller"
    CreditLines(84)="Ravelo"
    CreditLines(85)=""
    CreditLines(86)="Sound:"
    CreditLines(87)=""
    CreditLines(88)="Fennich_FJR6"
    CreditLines(89)="Blitzkreig"
    CreditLines(90)="Wiseq"
    CreditLines(91)="Boone"
    CreditLines(92)="Demonizer"
    CreditLines(93)="PsYcH0_Ch!cKeN"
    CreditLines(94)="Shurek"
    CreditLines(95)="602RAF_Puff"
    CreditLines(96)="engineer"
    CreditLines(97)="pillam"
    CreditLines(98)="Logan Laidlaw"
    CreditLines(99)="jmoney"
    CreditLines(100)=""
    CreditLines(101)="Patreon Supporters:"
    CreditLines(102)=""
    CreditLines(103)="-[SiN]-Titus"
    CreditLines(104)=".Reflected."
    CreditLines(105)="[DNR]Gun4hire"
    CreditLines(106)="8BitWarrior"
    CreditLines(107)="Brian Briggs"
    CreditLines(108)="Caleb Coates"
    CreditLines(109)="clad"
    CreditLines(110)="Clay McCarty"
    CreditLines(111)="Duncan Langford"
    CreditLines(112)="Frank Baele"
    CreditLines(113)="Garth Davis"
    CreditLines(114)="Glock Shanty"
    CreditLines(115)="Jeffrey Allan Beeler"
    CreditLines(116)="John Ciccariello"
    CreditLines(117)="Josef Erik Sedlácek"
    CreditLines(118)="Joshua Dressel"
    CreditLines(119)="Justin Hall"
    CreditLines(120)="Keith Olson"
    CreditLines(121)="Kevin Vones"
    CreditLines(122)="KS"
    CreditLines(123)="Mal"
    CreditLines(124)="Mikolaj Stefan"
    CreditLines(125)="Munakoiso"
    CreditLines(126)="Peter Senzamici"
    CreditLines(127)="PFC Patison [29th ID]"
    CreditLines(128)="ProjectMouthwash"
    CreditLines(129)="Rawhide"
    CreditLines(130)="Remington Spooner"
    CreditLines(131)="Robert Morra"
    CreditLines(132)="Saferight"
    CreditLines(133)="Sean Gift"
    CreditLines(134)="Zhang Han"
    CreditLines(135)=""
    CreditLines(136)="Other Contributors:"
    CreditLines(137)=""
    CreditLines(138)="After-Hourz Gaming Network"
    CreditLines(139)="All the lads from Splat"
    CreditLines(140)="The Wild Bunch"
    CreditLines(141)="Schneller"
    CreditLines(142)="Beppo and the lads from Sentry Studios"
    CreditLines(143)="Amizaur for vehicle optics code and German vehicle gun sights"
    CreditLines(144)="Thommy-L (Fatal Error)"
    CreditLines(145)="Carpathian Crosses Team"
    CreditLines(146)="Torben 'thens' Hensgens"
    CreditLines(147)="29th Infantry Division"
    CreditLines(148)="Good Guys Gaming Community"
    CreditLines(149)=""
    CreditLines(150)="Special Thanks:"
    CreditLines(151)=""
    CreditLines(152)="A huge thanks goes out to all the former members of the Darklight Games team. Without their years of hard work, we would never have made it to this point. We're eternally grateful."
    CreditLines(153)="All of our testers over the years. You've helped create a (mostly) bug free experience!"
    CreditLines(154)="Alan, John, Dayle & all the guys at Tripwire Interactive for their assistance, support, and of course for the game that we all love so much."
    CreditLines(155)="Our faithful community who has stuck by us over the years and continue to offer support and ideas for the betterment of the game."
    CreditLines(156)="And to everyone else who has contributed to this mod over the years that we may have missed, thank you!"

    bRequire640x480=false
    WinTop=0.1
    WinLeft=0.1
    WinWidth=0.8
    WinHeight=0.8
}
