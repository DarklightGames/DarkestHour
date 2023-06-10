//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_CrewTeleporter extends DH_Teleporter;

var() int CrewTeam; // 0 for Axis, 1 for Allies

// Detects which is the current crew spawn area and will teleport players to a teleporter with the same tag as the crew spawn area

// Teleporter was touched by an actor.
simulated function PostTouch(Actor Other)
{
    local name       CurrentCrewSpawnTag;
    local Teleporter D, Dest[16];
    local int        i;

    CurrentCrewSpawnTag = ROTeamGame(Level.Game).CurrentTankCrewSpawnArea[CrewTeam].Tag;
    URL = string(CurrentCrewSpawnTag);

    if (InStr(URL, "/") >= 0 || InStr(URL, "#") >= 0)
    {
        // Teleport to a level on the net.
        if (Role == ROLE_Authority && Pawn(Other) != none && Pawn(Other).IsHumanControlled())
        {
            Level.Game.SendPlayer(PlayerController(Pawn(Other).Controller), URL);
        }
    }
    else
    {
        // Teleport to a random teleporter in this local level - if more than one pick random
        foreach AllActors(class'Teleporter', D)
        {
            if (string(D.Tag) ~= URL && D != self)
            {
                Dest[i] = D;
                i++;

                if (i > arraycount(Dest))
                {
                    break;
                }
            }
        }

        i = Rand(i);

        if (Dest[i] != none)
        {
            // Teleport the actor into the other teleporter
            if (Other.IsA('Pawn'))
            {
                Other.PlayTeleportEffect(false, true);
            }

            Dest[i].Accept(Other, self);

            if (Pawn(Other) != none)
            {
                TriggerEvent(Event, self, Pawn(Other));
            }
        }
    }
}
