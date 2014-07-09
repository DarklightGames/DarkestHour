// *************************************************************************
//
//	***   DHMaplistEditor   ***
//
// *************************************************************************

class DHMaplistEditor extends MaplistEditor;

var automated GUISectionBackground  sb_container;

function AddSystemMenu()
{
	local eFontScale tFontScale;

	b_ExitButton = GUIButton(t_WindowTitle.AddComponent( "XInterface.GUIButton" ));
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
	b_ExitButton.bRepeatClick = False;
}


function InitComponent(GUIController MyController, GUIComponent MyOwner)
{
    	Super.InitComponent(MyController, MyOwner);

    	sb_MapList.ManageComponent(co_Maplist);
    	sb_MapList.ManageComponent(sb_container);
    	sb_container.ManageComponent(b_Delete);
    	sb_container.ManageComponent(b_Rename);
    	sb_container.ManageComponent(b_New);
}

function bool ButtonPreDraw(Canvas C)
{
    	return false;
}

defaultproperties
{
     Begin Object Class=ROGUIContainerNoSkinAlt Name=subcontainer
         NumColumns=3
         WinHeight=1.000000
         TabOrder=1
         OnPreDraw=subcontainer.InternalPreDraw
     End Object
     sb_container=ROGUIContainerNoSkinAlt'DH_Interface.DHMaplistEditor.subcontainer'

     Begin Object Class=DHGUITreeListBox Name=ActiveMaps
         bVisibleWhenEmpty=True
         OnCreateComponent=ActiveMaps.InternalOnCreateComponent
         WinTop=0.108021
         WinLeft=0.605861
         WinWidth=0.368359
         TabOrder=7
     End Object
     lb_ActiveMaps=DHGUITreeListBox'DH_Interface.DHMaplistEditor.ActiveMaps'

     Begin Object Class=DHGUITreeListBox Name=InactiveMaps
         bVisibleWhenEmpty=True
         bSorted=True
         OnCreateComponent=InactiveMaps.InternalOnCreateComponent
         WinTop=0.138078
         WinLeft=0.113794
         WinWidth=0.380394
         WinHeight=0.662671
         TabOrder=4
     End Object
     lb_AllMaps=DHGUITreeListBox'DH_Interface.DHMaplistEditor.InactiveMaps'

     Begin Object Class=GUIButton Name=AddButton
         Caption="Add"
         StyleName="DHMenuTextButtonStyle"
         WinTop=0.300000
         WinLeft=0.425000
         WinWidth=0.145000
         WinHeight=0.050000
         TabOrder=6
         bScaleToParent=True
         bRepeatClick=True
         OnClickSound=CS_Up
         OnClick=DHMaplistEditor.ModifyMapList
         OnKeyEvent=AddButton.InternalOnKeyEvent
     End Object
     b_Add=GUIButton'DH_Interface.DHMaplistEditor.AddButton'

     Begin Object Class=GUIButton Name=AddAllButton
         Caption="Add All"
         StyleName="DHMenuTextButtonStyle"
         WinTop=0.360000
         WinLeft=0.425000
         WinWidth=0.145000
         WinHeight=0.050000
         TabOrder=5
         bScaleToParent=True
         OnClickSound=CS_Up
         OnClick=DHMaplistEditor.ModifyMapList
         OnKeyEvent=AddAllButton.InternalOnKeyEvent
     End Object
     b_AddAll=GUIButton'DH_Interface.DHMaplistEditor.AddAllButton'

     Begin Object Class=GUIButton Name=RemoveButton
         Caption="Remove"
         AutoSizePadding=(HorzPerc=0.500000)
         StyleName="DHMenuTextButtonStyle"
         WinTop=0.700000
         WinLeft=0.425000
         WinWidth=0.145000
         WinHeight=0.050000
         TabOrder=10
         bScaleToParent=True
         bRepeatClick=True
         OnClickSound=CS_Down
         OnClick=DHMaplistEditor.ModifyMapList
         OnKeyEvent=RemoveButton.InternalOnKeyEvent
     End Object
     b_Remove=GUIButton'DH_Interface.DHMaplistEditor.RemoveButton'

     Begin Object Class=GUIButton Name=RemoveAllButton
         Caption="Remove All"
         StyleName="DHMenuTextButtonStyle"
         WinTop=0.760000
         WinLeft=0.425000
         WinWidth=0.145000
         WinHeight=0.050000
         TabOrder=11
         bScaleToParent=True
         OnClickSound=CS_Down
         OnClick=DHMaplistEditor.ModifyMapList
         OnKeyEvent=RemoveAllButton.InternalOnKeyEvent
     End Object
     b_RemoveAll=GUIButton'DH_Interface.DHMaplistEditor.RemoveAllButton'

     Begin Object Class=GUIButton Name=MoveUpButton
         Caption="Move Up"
         StyleName="DHMenuTextButtonStyle"
         WinTop=0.500000
         WinLeft=0.425000
         WinWidth=0.145000
         WinHeight=0.050000
         TabOrder=9
         bScaleToParent=True
         bRepeatClick=True
         OnClickSound=CS_Up
         OnClick=DHMaplistEditor.ModifyMapList
         OnKeyEvent=MoveUpButton.InternalOnKeyEvent
     End Object
     b_MoveUp=GUIButton'DH_Interface.DHMaplistEditor.MoveUpButton'

     Begin Object Class=GUIButton Name=MoveDownButton
         Caption="Move Down"
         StyleName="DHMenuTextButtonStyle"
         WinTop=0.560000
         WinLeft=0.425000
         WinWidth=0.145000
         WinHeight=0.050000
         TabOrder=8
         bScaleToParent=True
         bRepeatClick=True
         OnClickSound=CS_Down
         OnClick=DHMaplistEditor.ModifyMapList
         OnKeyEvent=MoveDownButton.InternalOnKeyEvent
     End Object
     b_MoveDown=GUIButton'DH_Interface.DHMaplistEditor.MoveDownButton'

     Begin Object Class=GUIButton Name=NewMaplistButton
         Caption="New"
         StyleName="DHMenuTextButtonStyle"
         WinLeft=0.600000
         WinWidth=0.100000
         WinHeight=0.050000
         TabOrder=1
         OnClick=DHMaplistEditor.CustomMaplistClick
         OnKeyEvent=NewMaplistButton.InternalOnKeyEvent
     End Object
     b_New=GUIButton'DH_Interface.DHMaplistEditor.NewMaplistButton'

     Begin Object Class=GUIButton Name=DeleteMaplistButton
         Caption="Delete"
         StyleName="DHMenuTextButtonStyle"
         WinLeft=0.900000
         WinWidth=0.100000
         WinHeight=0.050000
         TabOrder=3
         OnPreDraw=DHMaplistEditor.ButtonPreDraw
         OnClick=DHMaplistEditor.CustomMaplistClick
         OnKeyEvent=DeleteMaplistButton.InternalOnKeyEvent
     End Object
     b_Delete=GUIButton'DH_Interface.DHMaplistEditor.DeleteMaplistButton'

     Begin Object Class=GUIButton Name=RenameMaplistButton
         Caption="Rename"
         StyleName="DHMenuTextButtonStyle"
         WinLeft=0.750000
         WinWidth=0.100000
         WinHeight=0.050000
         TabOrder=2
         OnClick=DHMaplistEditor.CustomMaplistClick
         OnKeyEvent=RenameMaplistButton.InternalOnKeyEvent
     End Object
     b_Rename=GUIButton'DH_Interface.DHMaplistEditor.RenameMaplistButton'

     Begin Object Class=DHGUIComboBox Name=SelectMaplistCombo
         bReadOnly=True
         WinWidth=0.550000
         WinHeight=0.050000
         TabOrder=0
         OnChange=DHMaplistEditor.MaplistSelectChange
         OnKeyEvent=SelectMaplistCombo.InternalOnKeyEvent
     End Object
     co_Maplist=DHGUIComboBox'DH_Interface.DHMaplistEditor.SelectMaplistCombo'

     Begin Object Class=DHGUISectionBackground Name=MapListSectionBackground
         Caption="Saved Map Lists"
         TopPadding=0.050000
         BottomPadding=0.050000
         NumColumns=2
         StyleName="DHSmallText"
         WinTop=0.080000
         WinLeft=0.023646
         WinWidth=0.943100
         WinHeight=0.150000
         OnPreDraw=MapListSectionBackground.InternalPreDraw
     End Object
     sb_MapList=DHGUISectionBackground'DH_Interface.DHMaplistEditor.MapListSectionBackground'

     Begin Object Class=DHGUISectionBackground Name=AvailBackground
         bFillClient=True
         Caption="Available Maps"
         LeftPadding=0.002500
         RightPadding=0.002500
         TopPadding=0.002500
         BottomPadding=0.002500
         WinTop=0.255000
         WinLeft=0.025156
         WinWidth=0.380859
         WinHeight=0.716073
         bBoundToParent=True
         bScaleToParent=True
         OnPreDraw=AvailBackground.InternalPreDraw
     End Object
     sb_Avail=DHGUISectionBackground'DH_Interface.DHMaplistEditor.AvailBackground'

     Begin Object Class=DHGUISectionBackground Name=ActiveBackground
         bFillClient=True
         Caption="Selected Maps"
         LeftPadding=0.002500
         RightPadding=0.002500
         TopPadding=0.002500
         BottomPadding=0.002500
         WinTop=0.255000
         WinLeft=0.586876
         WinWidth=0.380859
         WinHeight=0.716073
         bBoundToParent=True
         bScaleToParent=True
         OnPreDraw=ActiveBackground.InternalPreDraw
     End Object
     sb_Active=DHGUISectionBackground'DH_Interface.DHMaplistEditor.ActiveBackground'

     Begin Object Class=DHGUIHeader Name=TitleBar
         bUseTextHeight=True
         StyleName="DHNoBox"
         WinTop=0.017000
         WinHeight=0.050000
         RenderWeight=0.100000
         bBoundToParent=True
         bScaleToParent=True
         bAcceptsInput=True
         bNeverFocus=False
         ScalingType=SCALE_X
         OnMousePressed=FloatingWindow.FloatingMousePressed
         OnMouseRelease=FloatingWindow.FloatingMouseRelease
     End Object
     t_WindowTitle=DHGUIHeader'DH_Interface.DHMaplistEditor.TitleBar'

     Begin Object Class=FloatingImage Name=FloatingFrameBackground
         Image=Texture'DH_GUI_Tex.Menu.DHDisplay_withcaption_noAlpha'
         DropShadow=None
         ImageStyle=ISTY_Stretched
         ImageRenderStyle=MSTY_Normal
         WinTop=0.020000
         WinLeft=0.000000
         WinWidth=1.000000
         WinHeight=0.980000
         RenderWeight=0.000003
     End Object
     i_FrameBG=FloatingImage'DH_Interface.DHMaplistEditor.FloatingFrameBackground'

}
