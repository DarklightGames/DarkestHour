// *************************************************************************
//
//  ***   DHSettings_Footer   ***
//
// *************************************************************************

class DHSettings_FooterNew extends UT2K4Settings_Footer;

defaultproperties
{
     Begin Object Class=GUIButton Name=BackB
         Caption="Back"
         StyleName="DHSmallTextButtonStyle"
         WinTop=0.085678
         WinHeight=0.036482
         RenderWeight=2.000000
         TabOrder=1
         bBoundToParent=true
         OnClick=DHSettings_FooterNew.InternalOnClick
         OnKeyEvent=BackB.InternalOnKeyEvent
     End Object
     b_Back=GUIButton'DH_Interface.DHSettings_FooterNew.BackB'

     Begin Object Class=GUIButton Name=DefaultB
         Caption="Defaults"
         StyleName="DHSmallTextButtonStyle"
         WinTop=0.085678
         WinLeft=0.885352
         WinWidth=0.114648
         WinHeight=0.036482
         RenderWeight=2.000000
         TabOrder=0
         bBoundToParent=true
         OnClick=DHSettings_FooterNew.InternalOnClick
         OnKeyEvent=DefaultB.InternalOnKeyEvent
     End Object
     b_Defaults=GUIButton'DH_Interface.DHSettings_FooterNew.DefaultB'

}
