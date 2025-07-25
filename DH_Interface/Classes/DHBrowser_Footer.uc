//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DHBrowser_Footer extends UT2k4Browser_Footer;

var automated GUIButton b_Main;

function bool InternalOnClick(GUIComponent Sender)
{
    local DHPlayer PC;
    if (Sender == b_Main)
    {
        //Open main menu
        PC = DHPlayer(PlayerOwner());
        PC.ConsoleCommand("DISCONNECT");
        Controller.CloseAll(false, true);
        Controller.OpenMenu("DH_Interface.DHMainMenu");
        return true;
    }

    super.InternalOnClick(Sender);
}

// Override to fix an epic bug that would allow this footer function to play with other UI elements in other GUI pages
// Ex- "FILTERS" was showing up in the deploy menu in MP only...
// This also allows a proper override of the Captions for the footer buttons
function UpdateActiveButtons(UT2K4Browser_Page CurrentPanel)
{
    if (CurrentPanel == none ||
        CurrentPanel != Class'DHBrowser_ServerListPageInternet' ||
        CurrentPanel != Class'DHBrowser_ServerListPageLAN' ||
        CurrentPanel != Class'DHBrowser_ServerListPageFavorites')
    {
        return;
    }

    UpdateButtonState(b_Join,     CurrentPanel.IsJoinAvailable(b_Join.default.Caption));
    UpdateButtonState(b_Refresh,  CurrentPanel.IsRefreshAvailable(b_Refresh.default.Caption));
    UpdateButtonState(b_Spectate, CurrentPanel.IsSpectateAvailable(b_Spectate.default.Caption));
    UpdateButtonState(b_Filter,   CurrentPanel.IsFilterAvailable(b_Filter.default.Caption));

    if (b_Filter.MenuState == MSAT_Disabled)
    {
        ch_Standard.Hide();
    }
    else
    {
        ch_Standard.Show();
    }
}

defaultproperties
{
    Begin Object Class=DHmoCheckBox Name=OnlyStandardCheckBox
        CaptionWidth=0.9
        Caption="Standard Servers Only"
        OnCreateComponent=OnlyStandardCheckBox.InternalOnCreateComponent
        FontScale=FNS_Small
        WinTop=0.093073
        WinLeft=0.02
        WinWidth=0.243945
        WinHeight=0.308203
        TabOrder=5
        bBoundToParent=true
        bScaleToParent=true
        bStandardized=false
    End Object
    ch_Standard=DHmoCheckBox'DH_Interface.OnlyStandardCheckBox'

    Begin Object Class=GUITitleBar Name=BrowserStatus   // TODO: fix font here.
        bUseTextHeight=false
        Justification=TXTA_Right
        FontScale=FNS_Small
        WinTop=0.030495
        WinLeft=0.238945
        WinWidth=0.761055
        WinHeight=0.45
        bBoundToParent=true
        bScaleToParent=true
        StyleName="DHSmallText"
    End Object
    t_StatusBar=GUITitleBar'DH_Interface.BrowserStatus'

    Begin Object Class=GUIButton Name=BrowserJoin
        Caption="Join"
        StyleName="DHSmallTextButtonStyle"
        WinTop=0.5
        WinLeft=611.0
        WinWidth=124.0
        WinHeight=0.036482
        RenderWeight=2.0
        TabOrder=2
        bBoundToParent=true
        OnClick=DHBrowser_Footer.InternalOnClick
        OnKeyEvent=BrowserJoin.InternalOnKeyEvent
    End Object
    b_Join=GUIButton'DH_Interface.BrowserJoin'

    Begin Object Class=GUIButton Name=BrowserSpec
        Caption="Spectate"
        StyleName="DHSmallTextButtonStyle"
        WinTop=0.5
        WinLeft=0.771094
        WinWidth=0.114648
        WinHeight=0.036482
        RenderWeight=2.0
        TabOrder=1
        bBoundToParent=true
        OnClick=DHBrowser_Footer.InternalOnClick
        OnKeyEvent=BrowserSpec.InternalOnKeyEvent
    End Object
    b_Spectate=GUIButton'DH_Interface.BrowserSpec'

    Begin Object class=GUIButton Name=BrowserMain
        Caption="Main"
        StyleName="DHSmallTextButtonStyle"
        WinTop=0.5
        WinHeight=0.036482
        RenderWeight=2.0
        TabOrder=4
        bBoundToParent=true
        OnClick=DHBrowser_Footer.InternalOnClick
        OnKeyEvent=BrowserMain.InternalOnKeyEvent
    End Object
    b_Main=GUIButton'DH_Interface.BrowserMain'

    Begin Object Class=GUIButton Name=BrowserBack
        Caption="Back"
        StyleName="DHSmallTextButtonStyle"
        WinTop=0.5
        WinHeight=0.036482
        RenderWeight=2.0
        TabOrder=5
        bBoundToParent=true
        OnClick=DHBrowser_Footer.InternalOnClick
        OnKeyEvent=BrowserBack.InternalOnKeyEvent
    End Object
    b_Back=GUIButton'DH_Interface.BrowserBack'

    Begin Object class=GUIButton Name=BrowserRefresh
        Caption="Refresh"
        StyleName="DHSmallTextButtonStyle"
        WinTop=0.5
        WinLeft=0.885352
        WinWidth=0.114648
        WinHeight=0.036482
        RenderWeight=2.0
        TabOrder=3
        bBoundToParent=true
        OnClick=DHBrowser_Footer.InternalOnClick
        OnKeyEvent=BrowserRefresh.InternalOnKeyEvent
    End Object
    b_Refresh=GUIButton'DH_Interface.BrowserRefresh'

    Begin Object Class=GUIButton Name=BrowserFilter
        Caption="Filters"
        bAutoSize=true
        StyleName="DHSmallTextButtonStyle"
        WinTop=0.5
        WinHeight=0.036482
        RenderWeight=2.0
        TabOrder=0
        bBoundToParent=true
        OnClick=DHBrowser_Footer.InternalOnClick
        OnKeyEvent=BrowserFilter.InternalOnKeyEvent
    End Object
    b_Filter=GUIButton'DH_Interface.BrowserFilter'
}
