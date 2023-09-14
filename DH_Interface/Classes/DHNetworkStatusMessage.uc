//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DHNetworkStatusMessage extends GUIPage;

var bool bIgnoreEsc;

var localized string LeaveMPButtonText;
var localized string LeaveSPButtonText;

var float ButtonWidth;
var float ButtonHeight;
var float ButtonHGap;
var float ButtonVGap;
var float BarHeight;
var float BarVPos;

function InitComponent(GUIController MyController, GUIComponent MyOwner)
{
    super.InitComponent(Mycontroller, MyOwner);

    PlayerOwner().ClearProgressMessages();
}

function bool InternalOnClick(GUIComponent Sender)
{
    if (Sender == Controls[1])
    {
        Controller.OpenMenu("DH_Interface.DHServerBrowser");
    }

    return true;
}

event HandleParameters(string Param1, string Param2)
{
    GUILabel(Controls[2]).Caption = Param1 $ "|" $ Param2;

    PlayerOwner().ClearProgressMessages();
}

defaultproperties
{
    bIgnoreEsc=true
    bRequire640x480=false
    OpenSound=Sound'ROMenuSounds.Generic.msfxEdit'

    Begin Object Class=GUIButton Name=NetStatBackground
        StyleName="SquareBar"
        WinTop=0.375
        WinHeight=0.25
        bAcceptsInput=false
        bNeverFocus=true
        OnKeyEvent=NetStatBackground.InternalOnKeyEvent
    End Object
    Controls(0)=GUIButton'DH_Interface.DHNetworkStatusMessage.NetStatBackground'

    Begin Object Class=GUIButton Name=NetStatOk
        Caption="OK"
        StyleName="MidGameButton"
        WinTop=0.675
        WinLeft=0.375
        WinWidth=0.25
        WinHeight=0.05
        bBoundToParent=true
        OnClick=DHNetworkStatusMessage.InternalOnClick
        OnKeyEvent=NetStatOk.InternalOnKeyEvent
    End Object
    Controls(1)=GUIButton'DH_Interface.DHNetworkStatusMessage.NetStatOk'

    Begin Object Class=GUILabel Name=NetStatLabel
        TextAlign=TXTA_Center
        TextColor=(B=255,G=255,R=255)
        TextFont="UT2HeaderFont"
        bMultiLine=true
        WinTop=0.125
        WinHeight=0.5
        bBoundToParent=true
    End Object
    Controls(2)=GUILabel'DH_Interface.DHNetworkStatusMessage.NetStatLabel'

    WinTop=0.375
    WinHeight=0.25
}
