//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2018
//==============================================================================

class DHCommandMenu_ATGun extends DHCommandMenu;

function OnSelect(int Index, vector Location)
{
    local DHPlayer PC;
    local DHPawn P;
    local DHATGun Gun;

    PC = GetPlayerController();
    Gun = DHATGun(MenuObject);

    if (PC == none || Index < 0 || Index >= Options.Length || Gun == none)
    {
        return;
    }

    P = DHPawn(PC.Pawn);

    if (P == none)
    {
        return;
    }

    //PRI = DHPlayerReplicationInfo(PC.PlayerReplicationInfo);

    switch (Index)
    {
        case 0: // Rally Point
            P.GunToRotate = Gun;
            P.ServerGiveWeapon("DH_Weapons.DH_ATGunRotateWeapon");
            break;
        default:
            break;
    }

    Interaction.Hide();
}

function bool IsOptionDisabled(int OptionIndex)
{
}

defaultproperties
{
    // TODO: replace the icon
    Options(0)=(ActionText="Rotate",Material=Texture'DH_InterfaceArt2_tex.Icons.rally_point')
}

