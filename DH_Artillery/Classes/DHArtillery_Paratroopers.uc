//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DHArtillery_Paratroopers extends DHArtillery;

var DHSpawnPointBase SpawnPoint;

simulated function PostBeginPlay()
{
    if (Role == ROLE_Authority)
    {
        SpawnPoint = Spawn(class'DHSpawnPoint_Parachute', self);

        if (SpawnPoint == none)
        {
            Destroy();
            return;
        }

        SpawnPoint.SetIsActive(true);
    }

    super.PostBeginPlay();
}

function OnTeamIndexChanged()
{
    super.OnTeamIndexChanged();

    if (SpawnPoint != none)
    {
        SpawnPoint.SetTeamIndex(TeamIndex);
    }
}

event Destroyed()
{
    super.Destroyed();

    if (SpawnPoint != none)
    {
        SpawnPoint.Destroy();
    }
}

simulated function bool IsParadrop()
{
    return true;
}

defaultproperties
{
    MenuName="Paratroopers"
    MenuIcon=Material'DH_InterfaceArt2_tex.Icons.paratroopers'
    LifeSpan=90
    ArtilleryType=ArtyType_Paradrop
}

