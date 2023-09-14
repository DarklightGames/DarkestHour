//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DHBrowser_OpenIP extends UT2K4GetDataMenu;

var localized string OKButtonHint;
var localized string CancelButtonHint;
var localized string EditBoxHint;

function InitComponent(GUIController pMyController, GUIComponent MyOwner)
{
    super.InitComponent(pMyController, MyOwner);

    ed_Data.MyEditBox.OnKeyEvent = InternalOnKeyEvent;
    b_OK.SetHint(OKButtonHint);
    b_Cancel.SetHint(CancelButtonHint);
    ed_Data.SetHint(EditBoxHint);
}

function HandleParameters(string s, string s2)
{
    if (s != "")
    {
        ed_Data.SetText(StripProtocol(s));
    }
}

function bool InternalOnClick(GUIComponent Sender)
{
    if (Sender == b_OK)
    {
        Execute();
    }
    else
    {
        Controller.CloseMenu(true);
    }

    return true;
}

function Execute()
{
    local string URL;

    URL = ed_Data.GetText();

    if (URL == "")
    {
        return;
    }

    URL = StripProtocol(URL);

    if (InStr(URL, ":") == -1)
    {
        URL $= ":7777";
    }

    ApplyURL(URL);
}

function ApplyURL(string URL)
{
    if (URL == "" || Left(URL, 1) == ":")
    {
        return;
    }

    PlayerOwner().ClientTravel(URL, TRAVEL_Absolute, false);
    Controller.CloseAll(false, true);
}

function bool InternalOnKeyEvent(out byte Key, out byte State, float Delta)
{
    if (!super.InternalOnKeyEvent(Key,State,Delta))
    {
        return ed_Data.MyEditBox.InternalOnKeyEvent(Key,State,Delta);
    }
}

function string StripProtocol(string s)
{
    local string Protocol;

    Protocol = PlayerOwner().GetURLProtocol();
    ReplaceText(s, Protocol $ "://", "");
    ReplaceText(s, Protocol, "");

    return s;
}

defaultproperties
{
    Begin Object Class=GUIButton Name=CancelButton
        Caption="CANCEL"
        StyleName="DHMenuTextButtonStyle"
        WinTop=0.3
        WinLeft=0.673047
        WinWidth=0.2
        WinHeight=0.047812
        OnClick=DHBrowser_OpenIP.InternalOnClick
        OnKeyEvent=CancelButton.InternalOnKeyEvent
    End Object
    b_Cancel=GUIButton'DH_Interface.DHBrowser_OpenIP.CancelButton'

    Begin Object Class=DHmoEditBox Name=IpEntryBox
        LabelJustification=TXTA_Right
        CaptionWidth=0.55
        Caption="IP Address: "
        OnCreateComponent=IpEntryBox.InternalOnCreateComponent
        WinTop=0.466667
        WinLeft=0.16
        WinHeight=0.04
        TabOrder=0
    End Object
    ed_Data=DHmoEditBox'DH_Interface.DHBrowser_OpenIP.IpEntryBox'

    Begin Object Class=GUIButton Name=OkButton
        Caption="OK"
        StyleName="DHMenuTextButtonStyle"
        WinTop=0.3
        WinLeft=0.4
        WinWidth=0.2
        OnClick=DHBrowser_OpenIP.InternalOnClick
        OnKeyEvent=OkButton.InternalOnKeyEvent
    End Object
    b_OK=GUIButton'DH_Interface.DHBrowser_OpenIP.OkButton'

    Begin Object Class=GUILabel Name=IPDesc
        Caption="Enter New IP Address"
        TextAlign=TXTA_Center
        TextColor=(B=255,G=255,R=255)
        TextFont="DHMenuFont"
        FontScale=FNS_Large
        WinTop=0.38
        WinHeight=32.0
    End Object
    l_Text=GUILabel'DH_Interface.DHBrowser_OpenIP.IPDesc'

    Begin Object Class=FloatingImage Name=MessageWindowFrameBackground
        Image=Texture'DH_GUI_Tex.Menu.DHDisplay1'
        DropShadowX=0
        DropShadowY=0
        StyleName="DHExitPageStyle"
        WinTop=0.06
        WinLeft=0.27
        WinWidth=0.47
        WinHeight=0.8
    End Object
    i_FrameBG=FloatingImage'DH_Interface.DHBrowser_OpenIP.MessageWindowFrameBackground'
}
