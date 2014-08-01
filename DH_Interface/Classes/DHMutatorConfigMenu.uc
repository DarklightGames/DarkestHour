//==============================================================================
//	DHMutatorConfigMenu
//==============================================================================
class DHMutatorConfigMenu extends MutatorConfigMenu;

function AddSystemMenu()
{
	local eFontScale tFontScale;

	b_ExitButton = GUIButton(t_WindowTitle.AddComponent("XInterface.GUIButton"));
	b_ExitButton.Style = Controller.GetStyle("DHCloseButton",tFontScale);
	b_ExitButton.OnClick = XButtonClicked;
	b_ExitButton.bNeverFocus=true;
	b_ExitButton.FocusInstead = t_WindowTitle;
	b_ExitButton.RenderWeight=1;
	b_ExitButton.bScaleToParent=false;
	b_ExitButton.OnPreDraw = SystemMenuPreDraw;
	b_ExitButton.bStandardized=true;
	b_ExitButton.StandardHeight=0.03;
	// Do not want OnClick() called from MousePressed()
	b_ExitButton.bRepeatClick = false;
}

defaultproperties
{
     Begin Object Class=DHGUIMultiOptionListBox Name=ConfigList
         bVisibleWhenEmpty=true
         OnCreateComponent=DHMutatorConfigMenu.InternalOnCreateComponent
         WinTop=0.143333
         WinLeft=0.037500
         WinWidth=0.918753
         WinHeight=0.697502
         RenderWeight=0.900000
         TabOrder=1
         bBoundToParent=true
         bScaleToParent=true
         OnChange=DHMutatorConfigMenu.InternalOnChange
     End Object
     lb_Config=DHGUIMultiOptionListBox'DH_Interface.DHMutatorConfigMenu.ConfigList'

     Begin Object Class=DHmoCheckBox Name=AdvancedButton
         Caption="View Advanced Options"
         OnCreateComponent=AdvancedButton.InternalOnCreateComponent
         WinTop=0.911982
         WinLeft=0.037500
         WinWidth=0.310000
         WinHeight=0.040000
         RenderWeight=1.000000
         TabOrder=1
         bBoundToParent=true
         OnChange=DHMutatorConfigMenu.InternalOnChange
     End Object
     ch_Advanced=DHmoCheckBox'DH_Interface.DHMutatorConfigMenu.AdvancedButton'

     Begin Object Class=DHGUIPlainBackground Name=InternalFrameImage
         WinTop=0.092000
         WinLeft=0.040000
         WinWidth=0.675859
         WinHeight=0.548976
         OnPreDraw=InternalFrameImage.InternalPreDraw
     End Object
     sb_Main=DHGUIPlainBackground'DH_Interface.DHMutatorConfigMenu.InternalFrameImage'

     Begin Object Class=GUIButton Name=LockedCancelButton
         Caption="Cancel"
         bAutoShrink=false
         StyleName="DHMenuTextButtonStyle"
         WinTop=0.872397
         WinLeft=0.512695
         WinWidth=0.159649
         TabOrder=99
         bBoundToParent=true
         OnClick=DHMutatorConfigMenu.InternalOnClick
         OnKeyEvent=LockedCancelButton.InternalOnKeyEvent
     End Object
     b_Cancel=GUIButton'DH_Interface.DHMutatorConfigMenu.LockedCancelButton'

     Begin Object Class=GUIButton Name=LockedOKButton
         Caption="OK"
         bAutoShrink=false
         StyleName="DHMenuTextButtonStyle"
         WinTop=0.872397
         WinLeft=0.742188
         WinWidth=0.159649
         TabOrder=100
         bBoundToParent=true
         OnClick=DHMutatorConfigMenu.InternalOnClick
         OnKeyEvent=LockedOKButton.InternalOnKeyEvent
     End Object
     b_OK=GUIButton'DH_Interface.DHMutatorConfigMenu.LockedOKButton'

     Begin Object Class=DHGUIHeader Name=TitleBar
         bUseTextHeight=true
         StyleName="DHNoBox"
         WinTop=0.020000
         WinHeight=0.050000
         RenderWeight=0.100000
         bBoundToParent=true
         bScaleToParent=true
         bAcceptsInput=true
         bNeverFocus=false
         ScalingType=SCALE_X
         OnMousePressed=FloatingWindow.FloatingMousePressed
         OnMouseRelease=FloatingWindow.FloatingMouseRelease
     End Object
     t_WindowTitle=DHGUIHeader'DH_Interface.DHMutatorConfigMenu.TitleBar'

     Begin Object Class=FloatingImage Name=FloatingFrameBackground
         Image=Texture'DH_GUI_Tex.Menu.DHDisplay_withcaption_noAlpha'
         DropShadow=none
         ImageStyle=ISTY_Stretched
         ImageRenderStyle=MSTY_Normal
         WinTop=0.020000
         WinLeft=0.000000
         WinWidth=1.000000
         WinHeight=1.000000
         RenderWeight=0.000003
     End Object
     i_FrameBG=FloatingImage'DH_Interface.DHMutatorConfigMenu.FloatingFrameBackground'

}
