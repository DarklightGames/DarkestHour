//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DHGUISquadsComponent extends GUIPanel;

var automated array<DHGUISquadComponent> SquadComponents;

function InitComponent(GUIController MyController, GUIComponent MyOwner)
{
    local int i;

    super.InitComponent(MyController, MyOwner);
    for (i = 0; i < SquadComponents.Length - 1; i++)
    {
        SquadComponents[i].SquadIndex = i; //Need to set it so create squad button links correctly
    }
    SquadComponents[SquadComponents.Length - 1].SquadIndex = -1;
}

function InternalOnShow()
{
    local int i;

    for (i = 0; i < SquadComponents.Length; ++i)
    {
        SquadComponents[i].SetVisibility(true);
    }
}

function InternalOnHide()
{
    local int i;

    for (i = 0; i < SquadComponents.Length; ++i)
    {
        SquadComponents[i].SetVisibility(false);
    }
}

defaultproperties
{
    Begin Object Class=DHGUISquadComponent Name=SquadComponent0
        WinWidth=1.0
        WinHeight=0.12
        WinLeft=0.0
        WinTop=0.0
    End Object
    SquadComponents(0)=SquadComponent0

    Begin Object Class=DHGUISquadComponent Name=SquadComponent1
        WinWidth=1.0
        WinHeight=0.12
        WinLeft=0.0
        WinTop=0.12
    End Object
    SquadComponents(1)=SquadComponent1

    Begin Object Class=DHGUISquadComponent Name=SquadComponent2
        WinWidth=1.0
        WinHeight=0.12
        WinLeft=0.0
        WinTop=0.24
    End Object
    SquadComponents(2)=SquadComponent2

    Begin Object Class=DHGUISquadComponent Name=SquadComponent3
        WinWidth=1.0
        WinHeight=0.12
        WinLeft=0.0
        WinTop=0.36
    End Object
    SquadComponents(3)=SquadComponent3

    Begin Object Class=DHGUISquadComponent Name=SquadComponent4
        WinWidth=1.0
        WinHeight=0.12
        WinLeft=0.0
        WinTop=0.48
    End Object
    SquadComponents(4)=SquadComponent4

    Begin Object Class=DHGUISquadComponent Name=SquadComponent5
        WinWidth=1.0
        WinHeight=0.12
        WinLeft=0.0
        WinTop=0.60
    End Object
    SquadComponents(5)=SquadComponent5

    Begin Object Class=DHGUISquadComponent Name=SquadComponent6
        WinWidth=1.0
        WinHeight=0.12
        WinLeft=0.0
        WinTop=0.72
    End Object
    SquadComponents(6)=SquadComponent6

    Begin Object Class=DHGUISquadComponent Name=SquadComponent7  //Extra squad
        WinWidth=1.0
        WinHeight=0.12
        WinLeft=0.0
        WinTop=0.84
    End Object
    SquadComponents(7)=SquadComponent7

    Begin Object Class=DHGUISquadComponent Name=SquadComponent8  //Headquarters
        WinWidth=1.0
        WinHeight=0.12
        WinLeft=0.0
        WinTop=0.96
    End Object
    SquadComponents(8)=SquadComponent8

    Begin Object Class=DHGUISquadComponent Name=SquadComponent9  //Unassigned Players
        WinWidth=1.0
        WinHeight=0.12
        WinLeft=0.0
        WinTop=0.96
    End Object
    SquadComponents(9)=SquadComponent9
    

    //OnHide=InternalOnHide
    //OnShow=InternalOnShow
}

