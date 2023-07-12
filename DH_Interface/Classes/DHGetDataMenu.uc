//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DHGetDataMenu extends UT2K4GetDataMenu;

defaultproperties
{
    Begin Object Class=GUIButton Name=CancelButton
        Caption="CANCEL"
        StyleName="DHMenuTextButtonStyle"
        Hint="Close this menu, discarding changes."
        WinTop=0.554167
        WinLeft=0.573047
        WinWidth=0.131641
        WinHeight=0.047812
        OnClick=DHGetDataMenu.InternalOnClick
        OnKeyEvent=CancelButton.InternalOnKeyEvent
    End Object
    b_Cancel=GUIButton'DH_Interface.DHGetDataMenu.CancelButton'
    Begin Object Class=DHmoEditBox Name=Data
        CaptionWidth=0.2
        OnCreateComponent=Data.InternalOnCreateComponent
        WinTop=0.4875
        WinLeft=0.302383
        WinWidth=0.4082
        TabOrder=0
    End Object
    ed_Data=DHmoEditBox'DH_Interface.DHGetDataMenu.Data'
    Begin Object Class=GUIButton Name=OkButton
        Caption="OK"
        StyleName="DHMenuTextButtonStyle"
        WinTop=0.3
        WinLeft=0.4
        WinWidth=0.2
        OnClick=DHGetDataMenu.InternalOnClick
        OnKeyEvent=OkButton.InternalOnKeyEvent
    End Object
    b_OK=GUIButton'DH_Interface.DHGetDataMenu.OkButton'
    Begin Object Class=GUILabel Name=DialogText
        TextAlign=TXTA_Center
        TextColor=(B=255,G=255,R=255)
        TextFont="DHMenuFont"
        FontScale=FNS_Large
        WinTop=0.319479
        WinHeight=0.09375
    End Object
    l_Text=GUILabel'DH_Interface.DHGetDataMenu.DialogText'
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
    i_FrameBG=FloatingImage'DH_Interface.DHGetDataMenu.MessageWindowFrameBackground'
}
