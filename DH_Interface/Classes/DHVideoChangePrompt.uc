//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DHVideoChangePrompt extends UT2K4VideoChangeOK;

defaultproperties
{
	Begin Object Class=GUIButton Name=bOk
		Caption="Keep Settings"
		WinWidth=0.200000
		WinHeight=0.040000
		WinLeft=0.175000
		WinTop=0.64
		bBoundToParent=true
		OnClick=InternalOnClick
	End Object
    b_Ok=bOk

	Begin Object Class=GUIButton Name=bCancel
		Caption="Restore Settings"
		WinWidth=0.2
		WinHeight=0.04
		WinLeft=0.65
		WinTop=0.64
		bBoundToParent=true
		OnClick=InternalOnClick
	End Object
    b_Cancel=bCancel
}
