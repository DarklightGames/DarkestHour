//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DHGUISquadsComponent extends GUIPanel;

var automated array<DHGUISquadComponent> SquadComponents;

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
        WinWidth=0.25
        WinHeight=0.5
        WinLeft=0.0
        WinTop=0.0
    End Object
    SquadComponents(0)=SquadComponent0

    Begin Object Class=DHGUISquadComponent Name=SquadComponent1
        WinWidth=0.25
        WinHeight=0.5
        WinLeft=0.25
        WinTop=0.0
    End Object
    SquadComponents(1)=SquadComponent1

    Begin Object Class=DHGUISquadComponent Name=SquadComponent2
        WinWidth=0.25
        WinHeight=0.5
        WinLeft=0.5
        WinTop=0.0
    End Object
    SquadComponents(2)=SquadComponent2

    Begin Object Class=DHGUISquadComponent Name=SquadComponent3
        WinWidth=0.25
        WinHeight=0.5
        WinLeft=0.75
        WinTop=0.0
    End Object
    SquadComponents(3)=SquadComponent3

    Begin Object Class=DHGUISquadComponent Name=SquadComponent4
        WinWidth=0.25
        WinHeight=0.5
        WinLeft=0.0
        WinTop=0.5
    End Object
    SquadComponents(4)=SquadComponent4

    Begin Object Class=DHGUISquadComponent Name=SquadComponent5
        WinWidth=0.25
        WinHeight=0.5
        WinLeft=0.25
        WinTop=0.5
    End Object
    SquadComponents(5)=SquadComponent5

    Begin Object Class=DHGUISquadComponent Name=SquadComponent6
        WinWidth=0.25
        WinHeight=0.5
        WinLeft=0.5
        WinTop=0.5
    End Object
    SquadComponents(6)=SquadComponent6

    Begin Object Class=DHGUISquadComponent Name=SquadComponent7
        WinWidth=0.25
        WinHeight=0.5
        WinLeft=0.75
        WinTop=0.5
    End Object
    SquadComponents(7)=SquadComponent7

    //OnHide=InternalOnHide
    //OnShow=InternalOnShow
}

