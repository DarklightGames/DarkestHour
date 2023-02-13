//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DHMaplistEditor extends MaplistEditor;

var automated GUISectionBackground  sb_container;

function AddSystemMenu(){}

function InitComponent(GUIController MyController, GUIComponent MyOwner)
{
    super.InitComponent(MyController, MyOwner);

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
        WinHeight=1.0
        TabOrder=1
        OnPreDraw=subcontainer.InternalPreDraw
    End Object
    sb_container=ROGUIContainerNoSkinAlt'DH_Interface.DHMaplistEditor.subcontainer'
    Begin Object Class=DHGUITreeListBox Name=ActiveMaps
        bVisibleWhenEmpty=true
        OnCreateComponent=ActiveMaps.InternalOnCreateComponent
        WinTop=0.108021
        WinLeft=0.605861
        WinWidth=0.368359
        TabOrder=7
    End Object
    lb_ActiveMaps=DHGUITreeListBox'DH_Interface.DHMaplistEditor.ActiveMaps'
    Begin Object Class=DHGUITreeListBox Name=InactiveMaps
        bVisibleWhenEmpty=true
        bSorted=true
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
        WinTop=0.3
        WinLeft=0.425
        WinWidth=0.145
        WinHeight=0.05
        TabOrder=6
        bScaleToParent=true
        bRepeatClick=true
        OnClickSound=CS_Up
        OnClick=DHMaplistEditor.ModifyMapList
        OnKeyEvent=AddButton.InternalOnKeyEvent
    End Object
    b_Add=GUIButton'DH_Interface.DHMaplistEditor.AddButton'
    Begin Object Class=GUIButton Name=AddAllButton
        Caption="Add All"
        StyleName="DHMenuTextButtonStyle"
        WinTop=0.36
        WinLeft=0.425
        WinWidth=0.145
        WinHeight=0.05
        TabOrder=5
        bScaleToParent=true
        OnClickSound=CS_Up
        OnClick=DHMaplistEditor.ModifyMapList
        OnKeyEvent=AddAllButton.InternalOnKeyEvent
    End Object
    b_AddAll=GUIButton'DH_Interface.DHMaplistEditor.AddAllButton'
    Begin Object Class=GUIButton Name=RemoveButton
        Caption="Remove"
        AutoSizePadding=(HorzPerc=0.5)
        StyleName="DHMenuTextButtonStyle"
        WinTop=0.7
        WinLeft=0.425
        WinWidth=0.145
        WinHeight=0.05
        TabOrder=10
        bScaleToParent=true
        bRepeatClick=true
        OnClickSound=CS_Down
        OnClick=DHMaplistEditor.ModifyMapList
        OnKeyEvent=RemoveButton.InternalOnKeyEvent
    End Object
    b_Remove=GUIButton'DH_Interface.DHMaplistEditor.RemoveButton'
    Begin Object Class=GUIButton Name=RemoveAllButton
        Caption="Remove All"
        StyleName="DHMenuTextButtonStyle"
        WinTop=0.76
        WinLeft=0.425
        WinWidth=0.145
        WinHeight=0.05
        TabOrder=11
        bScaleToParent=true
        OnClickSound=CS_Down
        OnClick=DHMaplistEditor.ModifyMapList
        OnKeyEvent=RemoveAllButton.InternalOnKeyEvent
    End Object
    b_RemoveAll=GUIButton'DH_Interface.DHMaplistEditor.RemoveAllButton'
    Begin Object Class=GUIButton Name=MoveUpButton
        Caption="Move Up"
        StyleName="DHMenuTextButtonStyle"
        WinTop=0.5
        WinLeft=0.425
        WinWidth=0.145
        WinHeight=0.05
        TabOrder=9
        bScaleToParent=true
        bRepeatClick=true
        OnClickSound=CS_Up
        OnClick=DHMaplistEditor.ModifyMapList
        OnKeyEvent=MoveUpButton.InternalOnKeyEvent
    End Object
    b_MoveUp=GUIButton'DH_Interface.DHMaplistEditor.MoveUpButton'
    Begin Object Class=GUIButton Name=MoveDownButton
        Caption="Move Down"
        StyleName="DHMenuTextButtonStyle"
        WinTop=0.56
        WinLeft=0.425
        WinWidth=0.145
        WinHeight=0.05
        TabOrder=8
        bScaleToParent=true
        bRepeatClick=true
        OnClickSound=CS_Down
        OnClick=DHMaplistEditor.ModifyMapList
        OnKeyEvent=MoveDownButton.InternalOnKeyEvent
    End Object
    b_MoveDown=GUIButton'DH_Interface.DHMaplistEditor.MoveDownButton'
    Begin Object Class=GUIButton Name=NewMaplistButton
        Caption="New"
        StyleName="DHMenuTextButtonStyle"
        WinLeft=0.6
        WinWidth=0.1
        WinHeight=0.05
        TabOrder=1
        OnClick=DHMaplistEditor.CustomMaplistClick
        OnKeyEvent=NewMaplistButton.InternalOnKeyEvent
    End Object
    b_New=GUIButton'DH_Interface.DHMaplistEditor.NewMaplistButton'
    Begin Object Class=GUIButton Name=DeleteMaplistButton
        Caption="Delete"
        StyleName="DHMenuTextButtonStyle"
        WinLeft=0.9
        WinWidth=0.1
        WinHeight=0.05
        TabOrder=3
        OnPreDraw=DHMaplistEditor.ButtonPreDraw
        OnClick=DHMaplistEditor.CustomMaplistClick
        OnKeyEvent=DeleteMaplistButton.InternalOnKeyEvent
    End Object
    b_Delete=GUIButton'DH_Interface.DHMaplistEditor.DeleteMaplistButton'
    Begin Object Class=GUIButton Name=RenameMaplistButton
        Caption="Rename"
        StyleName="DHMenuTextButtonStyle"
        WinLeft=0.75
        WinWidth=0.1
        WinHeight=0.05
        TabOrder=2
        OnClick=DHMaplistEditor.CustomMaplistClick
        OnKeyEvent=RenameMaplistButton.InternalOnKeyEvent
    End Object
    b_Rename=GUIButton'DH_Interface.DHMaplistEditor.RenameMaplistButton'
    Begin Object Class=DHGUIComboBox Name=SelectMaplistCombo
        bReadOnly=true
        WinWidth=0.55
        WinHeight=0.05
        TabOrder=0
        OnChange=DHMaplistEditor.MaplistSelectChange
        OnKeyEvent=SelectMaplistCombo.InternalOnKeyEvent
    End Object
    co_Maplist=DHGUIComboBox'DH_Interface.DHMaplistEditor.SelectMaplistCombo'
    Begin Object Class=DHGUISectionBackground Name=MapListSectionBackground
        Caption="Saved Map Lists"
        TopPadding=0.05
        BottomPadding=0.05
        NumColumns=2
        StyleName="DHSmallText"
        WinTop=0.08
        WinLeft=0.023646
        WinWidth=0.9431
        WinHeight=0.15
        OnPreDraw=MapListSectionBackground.InternalPreDraw
    End Object
    sb_MapList=DHGUISectionBackground'DH_Interface.DHMaplistEditor.MapListSectionBackground'
    Begin Object Class=DHGUISectionBackground Name=AvailBackground
        bFillClient=true
        Caption="Available Maps"
        LeftPadding=0.0025
        RightPadding=0.0025
        TopPadding=0.0025
        BottomPadding=0.0025
        WinTop=0.255
        WinLeft=0.025156
        WinWidth=0.380859
        WinHeight=0.716073
        bBoundToParent=true
        bScaleToParent=true
        OnPreDraw=AvailBackground.InternalPreDraw
    End Object
    sb_Avail=DHGUISectionBackground'DH_Interface.DHMaplistEditor.AvailBackground'
    Begin Object Class=DHGUISectionBackground Name=ActiveBackground
        bFillClient=true
        Caption="Selected Maps"
        LeftPadding=0.0025
        RightPadding=0.0025
        TopPadding=0.0025
        BottomPadding=0.0025
        WinTop=0.255
        WinLeft=0.586876
        WinWidth=0.380859
        WinHeight=0.716073
        bBoundToParent=true
        bScaleToParent=true
        OnPreDraw=ActiveBackground.InternalPreDraw
    End Object
    sb_Active=DHGUISectionBackground'DH_Interface.DHMaplistEditor.ActiveBackground'
    Begin Object Class=DHGUIHeader Name=TitleBar
        bUseTextHeight=true
        StyleName="DHNoBox"
        WinTop=0.017
        WinHeight=0.05
        RenderWeight=0.1
        bBoundToParent=true
        bScaleToParent=true
        bAcceptsInput=true
        bNeverFocus=false
        ScalingType=SCALE_X
        OnMousePressed=FloatingWindow.FloatingMousePressed
        OnMouseRelease=FloatingWindow.FloatingMouseRelease
    End Object
    t_WindowTitle=DHGUIHeader'DH_Interface.DHMaplistEditor.TitleBar'
    Begin Object Class=FloatingImage Name=FloatingFrameBackground
        Image=Texture'DH_GUI_Tex.Menu.DHDisplay_withcaption_noAlpha'
        DropShadow=none
        ImageStyle=ISTY_Stretched
        ImageRenderStyle=MSTY_Normal
        WinTop=0.02
        WinLeft=0.0
        WinWidth=1.0
        WinHeight=0.98
        RenderWeight=0.000003
    End Object
    i_FrameBG=FloatingImage'DH_Interface.DHMaplistEditor.FloatingFrameBackground'
}
