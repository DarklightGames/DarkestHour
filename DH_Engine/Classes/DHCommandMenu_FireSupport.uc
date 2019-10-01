//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2019
//==============================================================================

class DHCommandMenu_FireSupport extends DHCommandMenu;

function OnSelect(int Index, vector Location)
{
    local DHPlayer PC;

    PC = GetPlayerController();

    if (PC == none || Index < 0 || Index >= Options.Length)
    {
        return;
    }

    switch (Index)
    {
        case 0: // Artillery barrage
            PC.ServerSaveArtilleryPosition();
            break;
        case 1: // Fire request (HE)
            // TODO: !
            break;
        case 2: // Fire request (Smoke)
            // TODO: !
            break;
    }

    Interaction.Hide();
}

defaultproperties
{
    // TODO: Icons
    Options(0)=(ActionText="Artillery Barrage",Material=Texture'DH_InterfaceArt2_tex.Icons.fire')
    Options(1)=(ActionText="Fire Request (HE)",Material=Texture'DH_InterfaceArt2_tex.Icons.fire')
    Options(2)=(ActionText="Fire Request (Smoke)",Material=Texture'DH_InterfaceArt2_tex.Icons.fire')
}
