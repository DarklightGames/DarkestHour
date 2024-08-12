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

    for (i = 0; i < SquadComponents.Length; ++i)
    {
        switch (i)
        {
            case 5:
                SquadComponents[i].i_SquadType.Image = Material'DH_InterfaceArt2_tex.Icons.tank';
                SquadComponents[i].i_SquadType.Hint = "Tank Squad";
                SquadComponents[i].l_SquadTypeName.Caption = "Tanks";
                break;

            case 6:
                SquadComponents[i].i_SquadType.Image = Material'DH_InterfaceArt2_tex.Icons.supply_cache';
                SquadComponents[i].i_SquadType.Hint = "Constructs team buildings and transports supplies.";
                SquadComponents[i].l_SquadTypeName.Caption = "Logistic";
                break;

            case 7:
                SquadComponents[i].i_SquadType.SetVisibility(false);
                SquadComponents[i].i_SquadType.Hint = "Invite these players to a squad.";
                break;

            default:
                SquadComponents[i].i_SquadType.Image = Material'DH_InterfaceArt2_tex.Icons.infantry';
                SquadComponents[i].i_SquadType.Hint = "Infantry Squad";
                SquadComponents[i].l_SquadTypeName.Caption = "Infantry";
                break;
        }
    }
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

