//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DHTab_MutatorSP extends UT2K4Tab_MutatorSP;

var automated DHGUIPlainBackground  sb_ButtonBackground;

function InitComponent(GUIController MyController, GUIComponent MyOwner)
{
    super.InitComponent(MyController, MyOwner);
        class'DHInterfaceUtil'.static.SetROStyle(MyController, Controls);
}

defaultproperties
{
    Begin Object Class=DHGUIPlainBackground Name=ButtonBackground
        LeftPadding=0.0025
        RightPadding=0.0025
        TopPadding=0.0025
        BottomPadding=0.0025
        WinTop=0.036614
        WinLeft=0.421015
        WinWidth=0.155861
        WinHeight=0.547697
        OnPreDraw=ButtonBackground.InternalPreDraw
    End Object
    sb_ButtonBackground=DHGUIPlainBackground'DH_Interface.DHTab_MutatorSP.ButtonBackground'
    Begin Object Class=DHGUISectionBackground Name=AvailBackground
        Caption="Available Mutators"
        LeftPadding=0.0025
        RightPadding=0.0025
        TopPadding=0.0025
        BottomPadding=0.0025
        WinTop=0.036614
        WinLeft=0.025156
        WinWidth=0.380859
        WinHeight=0.547697
        OnPreDraw=AvailBackground.InternalPreDraw
    End Object
    sb_Avail=DHGUISectionBackground'DH_Interface.DHTab_MutatorSP.AvailBackground'
    Begin Object Class=DHGUISectionBackground Name=ActiveBackground
        Caption="Active Mutators"
        LeftPadding=0.0025
        RightPadding=0.0025
        TopPadding=0.0025
        BottomPadding=0.0025
        WinTop=0.036614
        WinLeft=0.586876
        WinWidth=0.380859
        WinHeight=0.547697
        OnPreDraw=ActiveBackground.InternalPreDraw
    End Object
    sb_Active=DHGUISectionBackground'DH_Interface.DHTab_MutatorSP.ActiveBackground'
    Begin Object Class=DHGUISectionBackground Name=DescriptionBackground
        Caption="Mutator Details"
        LeftPadding=0.0025
        RightPadding=0.0025
        TopPadding=0.0025
        BottomPadding=0.0025
        WinTop=0.610678
        WinLeft=0.025976
        WinWidth=0.942969
        WinHeight=0.355936
        OnPreDraw=DescriptionBackground.InternalPreDraw
    End Object
    sb_Description=DHGUISectionBackground'DH_Interface.DHTab_MutatorSP.DescriptionBackground'
    Begin Object Class=GUIListBox Name=IAMutatorAvailList
        SelectedStyleName="DHListSelectionStyle"
        bVisibleWhenEmpty=true
        bSorted=true
        HandleContextMenuOpen=UT2K4Tab_MutatorBase.ContextMenuOpen
        OnCreateComponent=IAMutatorAvailList.InternalOnCreateComponent
        StyleName="DHSmallText"
        WinTop=0.144937
        WinLeft=0.026108
        WinWidth=0.378955
        WinHeight=0.501446
        TabOrder=0
        Begin Object Class=GUIContextMenu Name=RCMenu
        End Object
        ContextMenu=GUIContextMenu'GUI2K4.UT2K4Tab_MutatorBase.RCMenu'
        OnChange=UT2K4Tab_MutatorBase.ListChange
    End Object
    lb_Avail=GUIListBox'DH_Interface.DHTab_MutatorSP.IAMutatorAvailList'
    Begin Object Class=GUIListBox Name=IAMutatorSelectedList
        SelectedStyleName="DHListSelectionStyle"
        bVisibleWhenEmpty=true
        bSorted=true
        OnCreateComponent=IAMutatorSelectedList.InternalOnCreateComponent
        StyleName="DHSmallText"
        WinTop=0.144937
        WinLeft=0.584376
        WinWidth=0.378955
        WinHeight=0.501446
        TabOrder=5
        ContextMenu=GUIContextMenu'GUI2K4.UT2K4Tab_MutatorBase.RCMenu'
        OnChange=UT2K4Tab_MutatorBase.ListChange
    End Object
    lb_Active=GUIListBox'DH_Interface.DHTab_MutatorSP.IAMutatorSelectedList'
    Begin Object Class=DHGUIScrollTextBox Name=IAMutatorScroll
        bNoTeletype=true
        CharDelay=0.0025
        EOLDelay=0.5
        bVisibleWhenEmpty=true
        OnCreateComponent=IAMutatorScroll.InternalOnCreateComponent
        StyleName="DHSmallText"
        WinTop=0.648595
        WinLeft=0.028333
        WinWidth=0.938254
        WinHeight=0.244296
        bTabStop=false
        bNeverFocus=true
    End Object
    lb_MutDesc=DHGUIScrollTextBox'DH_Interface.DHTab_MutatorSP.IAMutatorScroll'
    Begin Object Class=GUIButton Name=IAMutatorConfig
        Caption="Configure Mutators"
        StyleName="DHMenuTextButtonStyle"
        WinTop=0.910277
        WinLeft=0.729492
        WinWidth=0.239063
        WinHeight=0.054648
        TabOrder=6
        bVisible=false
        OnClick=UT2K4Tab_MutatorBase.MutConfigClick
        OnKeyEvent=IAMutatorConfig.InternalOnKeyEvent
    End Object
    b_Config=GUIButton'DH_Interface.DHTab_MutatorSP.IAMutatorConfig'
    Begin Object Class=GUIButton Name=IAMutatorAdd
        Caption="Add"
        StyleName="DHMenuTextButtonStyle"
        WinTop=0.174114
        WinLeft=0.425
        WinWidth=0.145
        WinHeight=0.05
        TabOrder=1
        OnClickSound=CS_Up
        OnClick=UT2K4Tab_MutatorBase.AddMutator
        OnKeyEvent=IAMutatorAdd.InternalOnKeyEvent
    End Object
    b_Add=GUIButton'DH_Interface.DHTab_MutatorSP.IAMutatorAdd'
    Begin Object Class=GUIButton Name=IAMutatorAll
        Caption="Add All"
        StyleName="DHMenuTextButtonStyle"
        WinTop=0.239218
        WinLeft=0.425
        WinWidth=0.145
        WinHeight=0.05
        TabOrder=2
        OnClickSound=CS_Up
        OnClick=UT2K4Tab_MutatorBase.AddAllMutators
        OnKeyEvent=IAMutatorAll.InternalOnKeyEvent
    End Object
    b_AddAll=GUIButton'DH_Interface.DHTab_MutatorSP.IAMutatorAll'
    Begin Object Class=GUIButton Name=IAMutatorRemove
        Caption="Remove"
        StyleName="DHMenuTextButtonStyle"
        WinTop=0.404322
        WinLeft=0.425
        WinWidth=0.145
        WinHeight=0.05
        TabOrder=4
        OnClickSound=CS_Down
        OnClick=UT2K4Tab_MutatorBase.RemoveMutator
        OnKeyEvent=IAMutatorRemove.InternalOnKeyEvent
    End Object
    b_Remove=GUIButton'DH_Interface.DHTab_MutatorSP.IAMutatorRemove'
    Begin Object Class=GUIButton Name=IAMutatorClear
        Caption="Remove All"
        StyleName="DHMenuTextButtonStyle"
        WinTop=0.340259
        WinLeft=0.425
        WinWidth=0.145
        WinHeight=0.05
        TabOrder=3
        OnClickSound=CS_Down
        OnClick=UT2K4Tab_MutatorBase.RemoveAllMutators
        OnKeyEvent=IAMutatorClear.InternalOnKeyEvent
    End Object
    b_RemoveAll=GUIButton'DH_Interface.DHTab_MutatorSP.IAMutatorClear'
    MutConfigMenu="DH_Interface.DHMutatorConfigMenu"
}
