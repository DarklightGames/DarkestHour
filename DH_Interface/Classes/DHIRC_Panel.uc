//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DHIRC_Panel extends UT2k4IRC_Panel;

function InitComponent(GUIController MyController, GUIComponent MyOwner)
{
    super.Initcomponent(MyController, MyOwner);

    class'ROInterfaceUtil'.static.SetROStyle(MyController, Controls);
}

defaultproperties
{
    Begin Object Class=DHmoComboBox Name=MyServerCombo
        CaptionWidth=0.25
        Caption="Server"
        OnCreateComponent=MyServerCombo.InternalOnCreateComponent
        WinTop=0.102967
        WinLeft=0.15
        WinWidth=0.4
        WinHeight=0.3
        RenderWeight=3.0
        TabOrder=0
        bBoundToParent=true
        bScaleToParent=true
        OnChange=DHIRC_Panel.InternalOnChange
    End Object
    co_Server=DHmoComboBox'DH_Interface.DHIRC_Panel.MyServerCombo'
    Begin Object Class=DHmoComboBox Name=MyChannelCombo
        CaptionWidth=0.25
        Caption="Channel"
        OnCreateComponent=MyChannelCombo.InternalOnCreateComponent
        WinTop=0.5
        WinLeft=0.15
        WinWidth=0.4
        WinHeight=0.3
        RenderWeight=3.0
        TabOrder=1
        bBoundToParent=true
        bScaleToParent=true
    End Object
    co_Channel=DHmoComboBox'DH_Interface.DHIRC_Panel.MyChannelCombo'
    Begin Object Class=GUIButton Name=MyConnectButton
        Caption="Connect"
        StyleName="DHSmallTextButtonStyle"
        WinTop=0.1
        WinLeft=0.56
        WinWidth=0.2
        WinHeight=0.3
        RenderWeight=3.0
        TabOrder=2
        bBoundToParent=true
        bScaleToParent=true
        OnClick=DHIRC_Panel.InternalOnClick
        OnKeyEvent=MyConnectButton.InternalOnKeyEvent
    End Object
    b_Connect=GUIButton'DH_Interface.DHIRC_Panel.MyConnectButton'
    Begin Object Class=GUIButton Name=MyRemoveServerButton
        Caption="Remove"
        StyleName="DHSmallTextButtonStyle"
        WinTop=0.1
        WinLeft=0.77
        WinWidth=0.2
        WinHeight=0.3
        RenderWeight=3.0
        TabOrder=4
        bBoundToParent=true
        bScaleToParent=true
        OnClick=DHIRC_Panel.InternalOnClick
        OnKeyEvent=MyRemoveServerButton.InternalOnKeyEvent
    End Object
    b_RemServer=GUIButton'DH_Interface.DHIRC_Panel.MyRemoveServerButton'
    Begin Object Class=GUIButton Name=MyJoinChannelButton
        Caption="Join"
        StyleName="DHSmallTextButtonStyle"
        WinTop=0.5
        WinLeft=0.56
        WinWidth=0.2
        WinHeight=0.3
        RenderWeight=3.0
        TabOrder=3
        bBoundToParent=true
        bScaleToParent=true
        OnClick=DHIRC_Panel.InternalOnClick
        OnKeyEvent=MyJoinChannelButton.InternalOnKeyEvent
    End Object
    b_JoinChannel=GUIButton'DH_Interface.DHIRC_Panel.MyJoinChannelButton'
    Begin Object Class=GUIButton Name=MyRemoveChannelButton
        Caption="Remove"
        StyleName="DHSmallTextButtonStyle"
        WinTop=0.5
        WinLeft=0.77
        WinWidth=0.2
        WinHeight=0.3
        RenderWeight=3.0
        TabOrder=5
        bBoundToParent=true
        bScaleToParent=true
        OnClick=DHIRC_Panel.InternalOnClick
        OnKeyEvent=MyRemoveChannelButton.InternalOnKeyEvent
    End Object
    b_RemChannel=GUIButton'DH_Interface.DHIRC_Panel.MyRemoveChannelButton'
    ServerHistory(0)="irc.gamesurge.net"
    ServerHistory(1)="Olya.NY.US.GameSurge.net"
    ConnectText="Connect"
    DisconnectText="Disconnect"
    LocalChannel="#redorchestra"
    OnPreDraw=DHIRC_Panel.PositionButtons
}
