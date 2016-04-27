//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
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
    CreditLines(14)="TT33"
    CreditLines(15)="PsYcH0_Ch!cKeN"
    CreditLines(16)="Teufelhund"
    CreditLines(17)="Fennich_FJR6"
    CreditLines(18)=""
    CreditLines(19)="Models:"
    CreditLines(20)=""
    CreditLines(21)="RustIronCrowe"
    CreditLines(22)="Apekop"
    CreditLines(23)="Coyote Ninja"
    CreditLines(24)="Diablo"
    CreditLines(25)="Garisson"
    CreditLines(26)="Maharzan"
    CreditLines(27)="Nights2o06"
    CreditLines(28)="ScubaSteve"
    CreditLines(29)="Silence14"
    CreditLines(30)="Tman"
    CreditLines(31)="2_k"
    CreditLines(32)="FooBar"
    CreditLines(33)="DmitriB"
    CreditLines(34)="Captain Obvious"
    CreditLines(35)="piotrlukasik"
    CreditLines(36)=""
    CreditLines(37)="Textures:"
    CreditLines(38)=""
    CreditLines(39)="Protector"
    CreditLines(40)="Aeneas2020"
    CreditLines(41)="Blacklabel"
    CreditLines(42)="Fennich_FJR6"
    CreditLines(43)="FooBar"
    CreditLines(44)="CYoung"
    CreditLines(45)="Captain Obvious"
    CreditLines(46)="piotrlukasik"
    CreditLines(47)=""
    CreditLines(48)="Art:"
    CreditLines(49)=""
    CreditLines(50)="Der Landser"
    CreditLines(51)="Protector"
    CreditLines(52)="Aeneas2020"
    CreditLines(53)="Fennich_FJR6"
    CreditLines(54)=""
    CreditLines(55)="Animations:"
    CreditLines(56)=""
    CreditLines(57)="Exocet"
    CreditLines(58)="Mike Munk (TWI)"
    CreditLines(59)="TT33"
    CreditLines(60)="Razorneck"
    CreditLines(61)=""
    CreditLines(62)="Level Design:"
    CreditLines(63)=""
    CreditLines(64)="Theel"
    CreditLines(65)="SchutzeSepp"
    CreditLines(66)="Razorneck"
    CreditLines(67)="BOH-rekrut"
    CreditLines(68)="Jorg Biermann"
    CreditLines(69)="Exocet"
    CreditLines(70)="Nestor Makhno"
    CreditLines(71)="602RAF_Puff"
    CreditLines(72)="Drecks"
    CreditLines(73)="FlashPanHunter"
    CreditLines(74)="Jeff Duquette"
    CreditLines(75)="Sichartshofen"
    CreditLines(76)="Peter Klinger"
    CreditLines(77)=""
    CreditLines(78)="Sound:"
    CreditLines(79)=""
    CreditLines(80)="Fennich_FJR6"
    CreditLines(81)="Blitzkreig"
    CreditLines(82)="Wiseq"
    CreditLines(83)="Boone"
    CreditLines(84)="Demonizer"
    CreditLines(85)="PsYcH0_Ch!cKeN"
    CreditLines(86)="Shurek"
    CreditLines(87)="602RAF_Puff"
    CreditLines(88)="engineer"
    CreditLines(89)="pillam"
    CreditLines(90)=""
    CreditLines(91)="Other Contributors:"
    CreditLines(92)=""
    CreditLines(93)="After-Hourz Gaming Network"
    CreditLines(94)="All the lads from Splat"
    CreditLines(95)="The Wild Bunch"
    CreditLines(96)="Schneller"
    CreditLines(97)="Beppo and the lads from Sentry Studios"
    CreditLines(98)="Amizaur for vehicle optics code and German vehicle gun sights"
    CreditLines(99)="Thommy-L (Fatal Error)"
    CreditLines(100)="Carpathian Crosses Team"
    CreditLines(101)="Torben 'thens' Hensgens"
    CreditLines(102)=""
    CreditLines(103)="Special Thanks:"
    CreditLines(104)=""
    CreditLines(105)="A huge thanks goes out to all the former members of the Darklight Games team. Without their years of hard work, we would never have made it to this point. We're eternally grateful."
    CreditLines(106)="All of our testers over the years. You've helped create a (mostly) bug free experience!"
    CreditLines(107)="Alan, John, Dayle & all the guys at Tripwire Interactive for their assistance, support, and of course for the game that we all love so much."
    CreditLines(108)="Our faithful community who has stuck by us over the years and continue to offer support and ideas for the betterment of the game."
    CreditLines(109)="And to everyone else who has contributed to this mod over the years that we may have missed, thank you!"

    bRequire640x480=false
    WinTop=0.1
    WinLeft=0.1
    WinWidth=0.8
    WinHeight=0.8
}
