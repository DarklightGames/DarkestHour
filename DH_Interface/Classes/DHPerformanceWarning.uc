//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DHPerformanceWarning extends UT2K4PerformWarn;

defaultproperties
{
	Begin Object Class=GUIButton Name=OkButton
		Caption="OK"
        StyleName="SquareButton"
		WinWidth=0.121875
		WinHeight=0.040000
		WinLeft=0.439063
		WinTop=0.550000
		OnClick=InternalOnClick
		TabOrder=0
	End Object

    b_Ok=OKButton
}
