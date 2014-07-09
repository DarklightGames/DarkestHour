//-----------------------------------------------------------
//
//-----------------------------------------------------------
//class UT2K4_FilterListPage extends LargeWindow;
class DHFilterListPage extends UT2K4_FilterListPage;


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


function InitFilterList()
{
	local array<string> FilterNames;
	local moCheckbox ch;
	local int i;

	li_Filters.Clear();
	FilterNames = FM.GetFilterNames();
	for (i = 0; i < FilterNames.Length; i++)
	{
		ch = moCheckBox(li_Filters.AddItem("DH_Interface.DHmoCheckbox",,FilterNames[i]));
		if (ch != None)
			ch.Checked(FM.IsActiveAt(i));
	}

	if (li_Filters.ItemCount==0)
		DisableComponent(b_Remove);
	else
		EnableComponent(b_Remove);

	li_Filters.SetIndex(0);

}

function bool CreateClick(GUIComponent Sender)
{
	local string FN;
	local int i,cnt;
	local moCheckbox cb;

	cnt = 0;
	for (i=0;i<li_Filters.ItemCount;i++)
	{
		cb = moCheckbox( li_Filters.GetItem(i) );
		if (inStr(cb.Caption,"New Filter")>=0)
			cnt++;
	}

	if (cnt==0)
		FN ="New Filter";
	else
		FN = "New Filter"@cnt;

	FM.AddCustomFilter(FN);
	InitFilterList();
    i= FM.FindFilterIndex(FN);
    Controller.OpenMenu("DH_Interface.DHFilterEdit",""$i,FN);

    return true;
}

function bool EditClick(GUIComponent Sender)
{
	local string FN;
	local int i;
	local moCheckbox cb;

	cb = moCheckbox( li_Filters.Get() );
	FN = cb.Caption;
    i= FM.FindFilterIndex(FN);
    Controller.OpenMenu("DH_Interface.DHFilterEdit",""$i,FN);

    return true;
}

defaultproperties
{
     Begin Object Class=DHGUIPlainBackground Name=sbBackground
         bFillClient=True
         bNoCaption=True
         Caption="Filters..."
         LeftPadding=0.002500
         RightPadding=0.002500
         TopPadding=0.002500
         BottomPadding=0.002500
         WinTop=0.103281
         WinLeft=0.262656
         WinWidth=0.343359
         WinHeight=0.766448
         OnPreDraw=sbBackground.InternalPreDraw
     End Object
     sb_Background=DHGUIPlainBackground'DH_Interface.DHFilterListPage.sbBackground'

     Begin Object Class=GUIButton Name=bCreate
         Caption="Create"
         StyleName="DHMenuTextButtonStyle"
         WinTop=0.105000
         WinLeft=0.610001
         WinWidth=0.168750
         WinHeight=0.050000
         OnClick=DHFilterListPage.CreateClick
         OnKeyEvent=bCreate.InternalOnKeyEvent
     End Object
     b_Create=GUIButton'DH_Interface.DHFilterListPage.bCreate'

     Begin Object Class=GUIButton Name=bRemove
         Caption="Remove"
         StyleName="DHMenuTextButtonStyle"
         WinTop=0.158333
         WinLeft=0.610001
         WinWidth=0.168750
         WinHeight=0.050000
         OnClick=DHFilterListPage.RemoveClick
         OnKeyEvent=bRemove.InternalOnKeyEvent
     End Object
     b_Remove=GUIButton'DH_Interface.DHFilterListPage.bRemove'

     Begin Object Class=GUIButton Name=bEdit
         Caption="Edit"
         StyleName="DHMenuTextButtonStyle"
         WinTop=0.266666
         WinLeft=0.610001
         WinWidth=0.168750
         WinHeight=0.050000
         OnClick=DHFilterListPage.EditClick
         OnKeyEvent=bEdit.InternalOnKeyEvent
     End Object
     b_Edit=GUIButton'DH_Interface.DHFilterListPage.bEdit'

     Begin Object Class=GUIButton Name=bOk
         Caption="OK"
         StyleName="DHMenuTextButtonStyle"
         WinTop=0.770000
         WinLeft=0.610001
         WinWidth=0.168750
         WinHeight=0.050000
         OnClick=DHFilterListPage.OkClick
         OnKeyEvent=bOk.InternalOnKeyEvent
     End Object
     b_OK=GUIButton'DH_Interface.DHFilterListPage.bOk'

     Begin Object Class=GUIButton Name=bCancel
         Caption="Cancel"
         StyleName="DHMenuTextButtonStyle"
         WinTop=0.820000
         WinLeft=0.610001
         WinWidth=0.168750
         WinHeight=0.050000
         OnClick=DHFilterListPage.CancelClick
         OnKeyEvent=bCancel.InternalOnKeyEvent
     End Object
     b_Cancel=GUIButton'DH_Interface.DHFilterListPage.bCancel'

     Begin Object Class=DHGUIMultiOptionListBox Name=lbFilters
         SelectedStyleName="DHListSelectionStyle"
         OnCreateComponent=lbFilters.InternalOnCreateComponent
         StyleName="DHSmallText"
         WinTop=0.103281
         WinLeft=0.262656
         WinWidth=0.343359
         WinHeight=0.766448
     End Object
     lb_Filters=DHGUIMultiOptionListBox'DH_Interface.DHFilterListPage.lbFilters'

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
     t_WindowTitle=DHGUIHeader'DH_Interface.DHFilterListPage.TitleBar'

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
     i_FrameBG=FloatingImage'DH_Interface.DHFilterListPage.FloatingFrameBackground'

}
