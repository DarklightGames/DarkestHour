// *************************************************************************
//
//	***   DHGameFooterSP   ***
//
// *************************************************************************

class DHGameFooterSP extends ButtonFooter;

var automated GUIButton b_Primary, b_Back;
var() localized string PrimaryCaption, PrimaryHint;

var UT2K4GamePageBase Owner;

function InitComponent(GUIController InController, GUIComponent InOwner)
{
	Super.InitComponent(InController, InOwner);
	Owner = UT2K4GamePageBase(MenuOwner);
	b_Primary.OnClick = Owner.InternalOnClick;
	//b_Secondary.OnClick = Owner.InternalOnClick;
	b_Back.OnClick = Owner.InternalOnClick;
}

function SetupButtons(optional string bPerButtonSizes)
{
	b_Primary.Caption = PrimaryCaption;
	b_Primary.SetHint(PrimaryHint);
	Super.SetupButtons(bPerButtonSizes);
}

defaultproperties
{
     Begin Object Class=GUIButton Name=GamePrimaryButton
         StyleName="DHSmallTextButtonStyle"
         WinTop=0.085678
         WinLeft=0.880000
         WinWidth=0.120000
         WinHeight=0.036482
         TabOrder=0
         bBoundToParent=true
         OnKeyEvent=GamePrimaryButton.InternalOnKeyEvent
     End Object
     b_Primary=GUIButton'DH_Interface.DHGameFooterSP.GamePrimaryButton'

     Begin Object Class=GUIButton Name=GameBackButton
         Caption="Back"
         StyleName="DHSmallTextButtonStyle"
         WinTop=0.085678
         WinWidth=0.120000
         WinHeight=0.036482
         TabOrder=2
         bBoundToParent=true
         OnKeyEvent=GameBackButton.InternalOnKeyEvent
     End Object
     b_Back=GUIButton'DH_Interface.DHGameFooterSP.GameBackButton'

}
