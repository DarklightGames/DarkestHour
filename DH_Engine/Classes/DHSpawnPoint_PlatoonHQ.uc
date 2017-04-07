//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================
// This is a generic spawn point. When squads were added, there was a di
//==============================================================================

class DHSpawnPoint_PlatoonHQ extends DHSpawnPointBase
    notplaceable;

var float SpawnRadius;

// TODO: Override with different style
simulated function string GetStyleName()
{
    if (IsBlocked())
    {
        return "DHSpawnPointBlockedButtonStyle";
    }
    else
    {
        return "DHSpawnButtonStyle";
    }
}

function bool PerformSpawn(DHPlayer PC)
{
    local DarkestHourGame G;
    local vector SpawnLocation;
    local rotator SpawnRotation;

    G = DarkestHourGame(Level.Game);

    if (PC == none || PC.Pawn != none || G == none)
    {
        return false;
    }

    if (CanSpawnWithParameters(GRI, PC.GetTeamNum(), PC.GetRoleIndex(), PC.GetSquadIndex(), PC.VehiclePoolIndex) &&
        GetSpawnPosition(SpawnLocation, SpawnRotation, PC.VehiclePoolIndex))
    {
        if (G.SpawnPawn(PC, SpawnLocation, SpawnRotation, self) == none)
        {
            return false;
        }

        return true;
    }

    return false;
}

function bool GetSpawnPosition(out vector SpawnLocation, out rotator SpawnRotation, int VehiclePoolIndex)
{
    local int i;
    local DHPawnCollisionTest CT;
    local vector L, X, Y, Z;
    local float ArcLength;

    ArcLength = (Pi * 2) / 8;

    for (i = 0; i < 8; ++i)
    {
        L = Location;
        L.X += Cos(ArcLength * i) * SpawnRadius;
        L.Y += Sin(ArcLength * i) * SpawnRadius;
        L.Z += 10.0 + class'DHPawn'.default.CollisionHeight / 2;

        CT = Spawn(class'DHPawnCollisionTest',,, L);

        if (CT != none)
        {
            break;
        }
    }

    if (CT != none)
    {
        GetAxes(rot(0, 0, 0), X, Y, Z);
        class'DHLib'.static.DrawStayingDebugCylinder(self, L, X, Y, Z, class'DHPawnCollisionTest'.default.CollisionRadius, class'DHPawnCollisionTest'.default.CollisionHeight, 20, 255, 0, 0);

        SpawnLocation = L;
        SpawnRotation = Rotation;
        CT.Destroy();
        return true;
    }

    return false;
}

defaultproperties
{
    SpawnRadius=60.0
}
