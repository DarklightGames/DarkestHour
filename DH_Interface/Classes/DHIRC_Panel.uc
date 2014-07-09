//-----------------------------------------------------------
//
//-----------------------------------------------------------
class DHIRC_Panel extends UT2k4IRC_Panel;

function InitComponent(GUIController MyController, GUIComponent MyOwner)
{
	Super.Initcomponent(MyController, MyOwner);

    class'ROInterfaceUtil'.static.SetROStyle(MyController, Controls);
}

defaultproperties
{
     Begin Object Class=DHmoComboBox Name=MyServerCombo
         CaptionWidth=0.250000
         Caption="Server"
         OnCreateComponent=MyServerCombo.InternalOnCreateComponent
         WinTop=0.102967
         WinLeft=0.150000
         WinWidth=0.400000
         WinHeight=0.300000
         RenderWeight=3.000000
         TabOrder=0
         bBoundToParent=True
         bScaleToParent=True
         OnChange=DHIRC_Panel.InternalOnChange
     End Object
     co_Server=DHmoComboBox'DH_Interface.DHIRC_Panel.MyServerCombo'

     Begin Object Class=DHmoComboBox Name=MyChannelCombo
         CaptionWidth=0.250000
         Caption="Channel"
         OnCreateComponent=MyChannelCombo.InternalOnCreateComponent
         WinTop=0.500000
         WinLeft=0.150000
         WinWidth=0.400000
         WinHeight=0.300000
         RenderWeight=3.000000
         TabOrder=1
         bBoundToParent=True
         bScaleToParent=True
     End Object
     co_Channel=DHmoComboBox'DH_Interface.DHIRC_Panel.MyChannelCombo'

     Begin Object Class=GUIButton Name=MyConnectButton
         Caption="Connect"
         StyleName="DHSmallTextButtonStyle"
         WinTop=0.100000
         WinLeft=0.560000
         WinWidth=0.200000
         WinHeight=0.300000
         RenderWeight=3.000000
         TabOrder=2
         bBoundToParent=True
         bScaleToParent=True
         OnClick=DHIRC_Panel.InternalOnClick
         OnKeyEvent=MyConnectButton.InternalOnKeyEvent
     End Object
     b_Connect=GUIButton'DH_Interface.DHIRC_Panel.MyConnectButton'

     Begin Object Class=GUIButton Name=MyRemoveServerButton
         Caption="Remove"
         StyleName="DHSmallTextButtonStyle"
         WinTop=0.100000
         WinLeft=0.770000
         WinWidth=0.200000
         WinHeight=0.300000
         RenderWeight=3.000000
         TabOrder=4
         bBoundToParent=True
         bScaleToParent=True
         OnClick=DHIRC_Panel.InternalOnClick
         OnKeyEvent=MyRemoveServerButton.InternalOnKeyEvent
     End Object
     b_RemServer=GUIButton'DH_Interface.DHIRC_Panel.MyRemoveServerButton'

     Begin Object Class=GUIButton Name=MyJoinChannelButton
         Caption="Join"
         StyleName="DHSmallTextButtonStyle"
         WinTop=0.500000
         WinLeft=0.560000
         WinWidth=0.200000
         WinHeight=0.300000
         RenderWeight=3.000000
         TabOrder=3
         bBoundToParent=True
         bScaleToParent=True
         OnClick=DHIRC_Panel.InternalOnClick
         OnKeyEvent=MyJoinChannelButton.InternalOnKeyEvent
     End Object
     b_JoinChannel=GUIButton'DH_Interface.DHIRC_Panel.MyJoinChannelButton'

     Begin Object Class=GUIButton Name=MyRemoveChannelButton
         Caption="Remove"
         StyleName="DHSmallTextButtonStyle"
         WinTop=0.500000
         WinLeft=0.770000
         WinWidth=0.200000
         WinHeight=0.300000
         RenderWeight=3.000000
         TabOrder=5
         bBoundToParent=True
         bScaleToParent=True
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
