//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DHTab_MainMP extends DHTab_MainSP;

var automated DHGUIPlainBackground  sb_ButtonBackground2;

defaultproperties
{
    Begin Object Class=DHGUIPlainBackground Name=ButtonBackground2
        WinTop=0.634726
        WinLeft=0.016993
        WinWidth=0.482149
        WinHeight=0.325816
        OnPreDraw=ButtonBackground2.InternalPreDraw
    End Object
    sb_ButtonBackground2=DHGUIPlainBackground'DH_Interface.ButtonBackground2'
}
