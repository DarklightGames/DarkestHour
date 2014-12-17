//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DHTab_Controls extends ROTab_Controls;

defaultproperties
{
    Begin Object Class=DHGUIProportionalContainer Name=InputBK1
        HeaderBase=texture'DH_GUI_Tex.Menu.DHDisplay_withcaption'
        Caption="Bindings"
        LeftPadding=0.000000
        RightPadding=0.000000
        TopPadding=0.010000
        BottomPadding=0.000000
        ImageOffset(2)=10.000000
        WinTop=0.004000
        WinLeft=0.021641
        WinWidth=0.956718
        WinHeight=0.956718
        OnPreDraw=InputBK1.InternalPreDraw
    End Object
    i_BG1=DHGUIProportionalContainer'DH_Interface.DHTab_Controls.InputBK1'
    Begin Object Class=GUILabel Name=HintLabel
        TextAlign=TXTA_Center
        bMultiLine=true
        VertAlign=TXTA_Center
        FontScale=FNS_Small
        StyleName="DHSmallText"
        WinTop=0.950000
        WinHeight=0.050000
        bBoundToParent=true
        bScaleToParent=true
    End Object
    l_Hint=GUILabel'DH_Interface.DHTab_Controls.HintLabel'
    Begin Object Class=DHGUIMultiColumnListBox Name=BindListBox
        HeaderColumnPerc(0)=0.500000
        HeaderColumnPerc(1)=0.250000
        HeaderColumnPerc(2)=0.250000
        SelectedStyleName="DHListSelectionStyle"
        OnCreateComponent=DHTab_Controls.InternalOnCreateComponent
        StyleName="DHNoBox"
        WinHeight=0.900000
        TabOrder=0
        bBoundToParent=true
        bScaleToParent=true
    End Object
    lb_Binds=DHGUIMultiColumnListBox'DH_Interface.DHTab_Controls.BindListBox'
    SectionStyleName="DHListSection"
    PanelCaption="Controls"
}
