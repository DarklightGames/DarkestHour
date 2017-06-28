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
    CreditLines(38)=""
    CreditLines(39)="Textures:"
    CreditLines(40)=""
    CreditLines(41)="Protector"
    CreditLines(42)="Aeneas2020"
    CreditLines(43)="Blacklabel"
    CreditLines(44)="Fennich_FJR6"
    CreditLines(45)="FooBar"
    CreditLines(46)="CYoung"
    CreditLines(47)="Captain Obvious"
    CreditLines(48)="piotrlukasik"
    CreditLines(49)="Theel"
    CreditLines(50)="Groundwaffe"
    CreditLines(51)=""
    CreditLines(52)="Art:"
    CreditLines(53)=""
    CreditLines(54)="Der Landser"
    CreditLines(55)="Protector"
    CreditLines(56)="Aeneas2020"
    CreditLines(57)="Fennich_FJR6"
    CreditLines(58)=""
    CreditLines(59)="Animations:"
    CreditLines(60)=""
    CreditLines(61)="Exocet"
    CreditLines(62)="Mike Munk (TWI)"
    CreditLines(63)="TT33"
    CreditLines(64)="Razorneck"
    CreditLines(65)=""
    CreditLines(66)="Level Design:"
    CreditLines(67)=""
    CreditLines(68)="Theel"
    CreditLines(69)="SchutzeSepp"
    CreditLines(70)="Razorneck"
    CreditLines(71)="BOH-rekrut"
    CreditLines(72)="Jorg Biermann"
    CreditLines(73)="Exocet"
    CreditLines(74)="Nestor Makhno"
    CreditLines(75)="602RAF_Puff"
    CreditLines(76)="Drecks"
    CreditLines(77)="FlashPanHunter"
    CreditLines(78)="Jeff Duquette"
    CreditLines(79)="Sichartshofen"
    CreditLines(80)="Peter Klinger"
    CreditLines(81)="EvilHobo"
    CreditLines(82)="TWB*RedYager and TWB*JimMiller"
    CreditLines(83)="Ravelo"
    CreditLines(84)=""
    CreditLines(85)="Sound:"
    CreditLines(86)=""
    CreditLines(87)="Fennich_FJR6"
    CreditLines(88)="Blitzkreig"
    CreditLines(89)="Wiseq"
    CreditLines(90)="Boone"
    CreditLines(91)="Demonizer"
    CreditLines(92)="PsYcH0_Ch!cKeN"
    CreditLines(93)="Shurek"
    CreditLines(94)="602RAF_Puff"
    CreditLines(95)="engineer"
    CreditLines(96)="pillam"
    CreditLines(97)="Logan Laidlaw"
    CreditLines(98)="jmoney"
    CreditLines(99)=""
    CreditLines(100)="Other Contributors:"
    CreditLines(101)=""
    CreditLines(102)="After-Hourz Gaming Network"
    CreditLines(103)="All the lads from Splat"
    CreditLines(104)="The Wild Bunch"
    CreditLines(105)="Schneller"
    CreditLines(106)="Beppo and the lads from Sentry Studios"
    CreditLines(107)="Amizaur for vehicle optics code and German vehicle gun sights"
    CreditLines(108)="Thommy-L (Fatal Error)"
    CreditLines(109)="Carpathian Crosses Team"
    CreditLines(110)="Torben 'thens' Hensgens"
    CreditLines(111)="29th Infantry Division"
    CreditLines(112)="Good Guys Gaming Community"
    CreditLines(113)=""
    CreditLines(114)="Special Thanks:"
    CreditLines(115)=""
    CreditLines(116)="A huge thanks goes out to all the former members of the Darklight Games team. Without their years of hard work, we would never have made it to this point. We're eternally grateful."
    CreditLines(117)="All of our testers over the years. You've helped create a (mostly) bug free experience!"
    CreditLines(118)="Alan, John, Dayle & all the guys at Tripwire Interactive for their assistance, support, and of course for the game that we all love so much."
    CreditLines(119)="Our faithful community who has stuck by us over the years and continue to offer support and ideas for the betterment of the game."
    CreditLines(120)="And to everyone else who has contributed to this mod over the years that we may have missed, thank you!"

    bRequire640x480=false
    WinTop=0.1
    WinLeft=0.1
    WinWidth=0.8
    WinHeight=0.8
}
