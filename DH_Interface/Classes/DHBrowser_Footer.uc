//-----------------------------------------------------------
//
//-----------------------------------------------------------
class DHBrowser_Footer extends UT2k4Browser_Footer;

defaultproperties
{
     Begin Object Class=DHmoCheckBox Name=OnlyStandardCheckBox
         CaptionWidth=0.900000
         Caption="Standard Servers Only"
         OnCreateComponent=OnlyStandardCheckBox.InternalOnCreateComponent
         FontScale=FNS_Small
         WinTop=0.093073
         WinLeft=0.020000
         WinWidth=0.243945
         WinHeight=0.308203
         TabOrder=5
         bBoundToParent=True
         bScaleToParent=True
         bStandardized=False
     End Object
     ch_Standard=DHmoCheckBox'DH_Interface.DHBrowser_Footer.OnlyStandardCheckBox'

     Begin Object Class=GUITitleBar Name=BrowserStatus
         bUseTextHeight=False
         Justification=TXTA_Right
         FontScale=FNS_Small
         WinTop=0.030495
         WinLeft=0.238945
         WinWidth=0.761055
         WinHeight=0.450000
         bBoundToParent=True
         bScaleToParent=True
     End Object
     t_StatusBar=GUITitleBar'DH_Interface.DHBrowser_Footer.BrowserStatus'

     Begin Object Class=GUIButton Name=BrowserJoin
         Caption="JOIN"
         StyleName="DHSmallTextButtonStyle"
         WinTop=0.500000
         WinLeft=611.000000
         WinWidth=124.000000
         WinHeight=0.036482
         RenderWeight=2.000000
         TabOrder=2
         bBoundToParent=True
         OnClick=DHBrowser_Footer.InternalOnClick
         OnKeyEvent=BrowserJoin.InternalOnKeyEvent
     End Object
     b_Join=GUIButton'DH_Interface.DHBrowser_Footer.BrowserJoin'

     Begin Object Class=GUIButton Name=BrowserSpec
         Caption="SPECTATE"
         StyleName="DHSmallTextButtonStyle"
         WinTop=0.500000
         WinLeft=0.771094
         WinWidth=0.114648
         WinHeight=0.036482
         RenderWeight=2.000000
         TabOrder=1
         bBoundToParent=True
         OnClick=DHBrowser_Footer.InternalOnClick
         OnKeyEvent=BrowserSpec.InternalOnKeyEvent
     End Object
     b_Spectate=GUIButton'DH_Interface.DHBrowser_Footer.BrowserSpec'

     Begin Object Class=GUIButton Name=BrowserBack
         Caption="BACK"
         StyleName="DHSmallTextButtonStyle"
         WinTop=0.500000
         WinHeight=0.036482
         RenderWeight=2.000000
         TabOrder=4
         bBoundToParent=True
         OnClick=DHBrowser_Footer.InternalOnClick
         OnKeyEvent=BrowserBack.InternalOnKeyEvent
     End Object
     b_Back=GUIButton'DH_Interface.DHBrowser_Footer.BrowserBack'

     Begin Object Class=GUIButton Name=BrowserRefresh
         Caption="REFRESH"
         StyleName="DHSmallTextButtonStyle"
         WinTop=0.500000
         WinLeft=0.885352
         WinWidth=0.114648
         WinHeight=0.036482
         RenderWeight=2.000000
         TabOrder=3
         bBoundToParent=True
         OnClick=DHBrowser_Footer.InternalOnClick
         OnKeyEvent=BrowserRefresh.InternalOnKeyEvent
     End Object
     b_Refresh=GUIButton'DH_Interface.DHBrowser_Footer.BrowserRefresh'

     Begin Object Class=GUIButton Name=BrowserFilter
         Caption="FILTERS"
         bAutoSize=True
         StyleName="DHSmallTextButtonStyle"
         WinTop=0.500000
         WinHeight=0.036482
         RenderWeight=2.000000
         TabOrder=0
         bBoundToParent=True
         OnClick=DHBrowser_Footer.InternalOnClick
         OnKeyEvent=BrowserFilter.InternalOnKeyEvent
     End Object
     b_Filter=GUIButton'DH_Interface.DHBrowser_Footer.BrowserFilter'

}
