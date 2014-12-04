//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DHCreditsPage extends LargeWindow;


const NUM_CREDIT_LINES = 120;

var automated GUIButton b_Close;

var automated GUIScrollTextBox lb_credits;

var localized string credit_lines[NUM_CREDIT_LINES];


function AddSystemMenu()
{
    local eFontScale tFontScale;

    b_ExitButton = GUIButton(t_WindowTitle.AddComponent("XInterface.GUIButton"));
    b_ExitButton.Style = Controller.GetStyle("DHCloseButton",tFontScale);
    b_ExitButton.OnClick = XButtonClicked;
    b_ExitButton.bNeverFocus=true;
    b_ExitButton.FocusInstead = t_WindowTitle;
    b_ExitButton.RenderWeight=1;
    b_ExitButton.bScaleToParent = false;
    b_ExitButton.OnPreDraw = SystemMenuPreDraw;
    b_ExitButton.bStandardized=true;
    b_ExitButton.StandardHeight=0.03;
    // Do not want OnClick() called from MousePressed()
    b_ExitButton.bRepeatClick = false;
}



function InitComponent(GUIController MyController, GUIComponent MyOwner)
{
    local string text;
    local int i;

    super.InitComponent(MyController, MyOwner);

    class'DHInterfaceUtil'.static.SetROStyle(MyController, Controls);

    for (i = 0; i < NUM_CREDIT_LINES; i++)
        text $= credit_lines[i] $ "|";

    lb_credits.SetContent(text);
}

function bool InternalOnClick(GUIComponent Sender)
{
    //if (Sender==Controls[1])
    if (Sender == b_close)
    {
        Controller.CloseMenu();
    }
    return true;
}

function bool ButtonClick(GUIComponent Sender)
{
    if (Sender == b_close)
        Controller.CloseMenu();

    return true;
}

defaultproperties
{
     Begin Object Class=GUIButton Name=CloseButton
         Caption="Close"
         StyleName="DHMenuTextButtonStyle"
         WinTop=0.900000
         WinLeft=0.400000
         WinWidth=0.200000
         bBoundToParent=true
         OnClick=DHCreditsPage.InternalOnClick
         OnKeyEvent=CloseButton.InternalOnKeyEvent
     End Object
     b_Close=GUIButton'DH_Interface.DHCreditsPage.CloseButton'

     Begin Object Class=DHGUIScrollTextBox Name=CreditText
         bNoTeletype=true
         OnCreateComponent=CreditText.InternalOnCreateComponent
         StyleName="DHLargeText"
         WinTop=0.080000
         WinLeft=0.070000
         WinWidth=0.860000
         WinHeight=0.800000
         bBoundToParent=true
         bScaleToParent=true
     End Object
     lb_credits=DHGUIScrollTextBox'DH_Interface.DHCreditsPage.CreditText'

     credit_lines(0)="DARKEST HOUR - EUROPE '44-'45"
     credit_lines(2)="Project Lead:"
     credit_lines(4)="Exocet"
     credit_lines(6)="Code:"
     credit_lines(8)="PsYcH0_Ch!cKeN"
     credit_lines(9)="Fennich_FJR6"
     credit_lines(10)="TT33"
     credit_lines(11)="Shurek"
     credit_lines(12)="Teufelhund"
     credit_lines(13)="Colin Basnett"
     credit_lines(15)="Models:"
     credit_lines(17)="Apekop"
     credit_lines(18)="Coyote Ninja"
     credit_lines(19)="Diablo"
     credit_lines(20)="Garisson"
     credit_lines(21)="Maharzan"
     credit_lines(22)="Nights2o06"
     credit_lines(23)="ScubaSteve"
     credit_lines(24)="Silence14"
     credit_lines(25)="Tman"
     credit_lines(26)="2_k"
     credit_lines(27)="FooBar"
     credit_lines(28)="RustIronCrowe"
     credit_lines(29)="DmitriB"
     credit_lines(30)="Captain Obvious"
     credit_lines(32)="Textures:"
     credit_lines(34)="Protector"
     credit_lines(35)="Aeneas2020"
     credit_lines(36)="Blacklabel"
     credit_lines(37)="Fennich_FJR6"
     credit_lines(38)="FooBar"
     credit_lines(39)="CYoung"
     credit_lines(40)="Captain Obvious"
     credit_lines(42)="Art:"
     credit_lines(44)="Der Landser"
     credit_lines(45)="Protector"
     credit_lines(46)="Aeneas2020"
     credit_lines(47)="Fennich_FJR6"
     credit_lines(49)="Animations:"
     credit_lines(51)="Exocet"
     credit_lines(52)="Mike Munk (TWI)"
     credit_lines(53)="TT33"
     credit_lines(54)="Razorneck"
     credit_lines(56)="Map Design:"
     credit_lines(58)="Exocet"
     credit_lines(59)="SchutzeSepp"
     credit_lines(60)="Nestor Makhno"
     credit_lines(61)="Razorneck"
     credit_lines(62)="602RAF_Puff"
     credit_lines(63)="Drecks"
     credit_lines(64)="FlashPanHunter"
     credit_lines(65)="Jeff Duquette"
     credit_lines(66)="Sichartshofen"
     credit_lines(67)="BOH-rekrut"
     credit_lines(68)="Theel"
     credit_lines(69)="Jorg Biermann"
     credit_lines(71)="Sound:"
     credit_lines(73)="Fennich_FJR6"
     credit_lines(74)="Blitzkreig"
     credit_lines(75)="Wiseq"
     credit_lines(76)="Boone"
     credit_lines(77)="Demonizer"
     credit_lines(78)="PsYcH0_Ch!cKeN"
     credit_lines(79)="Shurek"
     credit_lines(80)="602RAF_Puff"
     credit_lines(81)="engineer"
     credit_lines(82)="pillam"
     credit_lines(84)="Historical Research:"
     credit_lines(86)="101.SS Keltisch WereWolf"
     credit_lines(87)="Del"
     credit_lines(88)="Abshire"
     credit_lines(89)="Lt. Stephenson"
     credit_lines(90)="Alan Wilson (TWI)"
     credit_lines(92)="Public Relations:"
     credit_lines(94)="PsYcH0_Ch!cKeN"
     credit_lines(95)="Nestor Makhno"
     credit_lines(96)="Wilson [29th ID]"
     credit_lines(97)="RustIronCrowe"
     credit_lines(98)="Colin Basnett"
     credit_lines(100)="Other Contributors:"
     credit_lines(102)="After-Hourz Gaming Network"
     credit_lines(103)="All the lads from Splat"
     credit_lines(104)="The Wild Bunch"
     credit_lines(105)="Schneller"
     credit_lines(106)="Beppo and the lads from Sentry Studios"
     credit_lines(107)="Amizaur for vehicle optics code and German vehicle gun sights"
     credit_lines(108)="Thommy-L (Fatal Error) for getting the test team's act together this last release"
     credit_lines(110)="Special Thanks:"
     credit_lines(112)="A huge thanks goes out to all the former members of the Dark-Light Games team. Without their years of hard work, we would never have made it to this point. We're eternally grateful."
     credit_lines(113)="All of our testers over the years, especially this last release.  You've helped create a (mostly) bug free experience!"
     credit_lines(114)="Alan, John, Dayle & all the guys at Tripwire Interactive for their assistance, support, and of course for the game that we all love so much."
     credit_lines(115)="Our faithful community who has stuck by us over the years and continue to offer support and ideas for the betterment of the game."
     credit_lines(116)="And to everyone else who has contributed to this mod over the past four years that we may have missed, thank you!"
     Begin Object Class=DHGUIHeader Name=TitleBar
         StyleName="DHLargeText"
         WinTop=0.020000
         WinHeight=0.050000
         RenderWeight=0.100000
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
         WinTop=0.020000
         WinLeft=0.000000
         WinWidth=1.000000
         WinHeight=0.980000
         RenderWeight=0.000003
     End Object
     i_FrameBG=FloatingImage'DH_Interface.DHCreditsPage.FloatingFrameBackground'

     bRequire640x480=false
     WinTop=0.100000
     WinLeft=0.100000
     WinWidth=0.800000
     WinHeight=0.800000
}
