//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DHGUIListBox extends ROGUIListBoxPlus;

function InitComponent(GUIController MyController, GUIComponent MyOwner)
{
    super.InitComponent(MyController, MyOwner);

    if (ContextMenu != none)
    {
        ContextMenu.OnOpen = MyOpen;
        ContextMenu.OnClose = MyClose;
        ContextMenu.OnSelect = NotifyContextSelect;
    }
}

defaultproperties
{
    Begin Object Class=DHGUIVertScrollBar Name=TheScrollbar
        bVisible=false
        OnPreDraw=TheScrollbar.GripPreDraw
    End Object
    MyScrollBar=TheScrollbar

    DefaultListClass="DH_Interface.DHGUIList"
}

