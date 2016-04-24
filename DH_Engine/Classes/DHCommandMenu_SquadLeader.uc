//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DHCommandMenu_SquadLeader extends DHCommandMenu;

function bool OnSelect(int Index)
{
    switch (Index)
    {
        case 0:
            break;
        case 1:
            break;
        case 2:
            break;
        case 3:
            break;
        case 4:
            break;
        default:
            break;
    }

    return false;
}

defaultproperties
{
    Options(0)=(Text="Fire")
    Options(1)=(Text="Attack")
    Options(2)=(Text="Defend")
    Options(3)=(Text="Move")
    Options(4)=(Text="Smoke")
}


