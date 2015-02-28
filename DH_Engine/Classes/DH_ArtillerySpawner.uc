//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DH_ArtillerySpawner extends ROArtillerySpawner;

// Matt: modified to spawn DH_ArtilleryShell instead of RO version
function Timer()
{
    local vector       AimVec;
    local ROVolumeTest RVT;
    local ROPlayer     ROP;

    // Hack: Lets find a better way to prevent arty from spilling to the next round
    // Also kill the arty strike if the commander switches teams or leaves the server
    if (!ROTeamGame(Level.Game).IsInState('RoundInPlay') || InstigatorController == none || InstigatorController.GetTeamNum() != OwningTeam)
    {
        if (LastSpawnedShell != none && !LastSpawnedShell.bDeleteMe)
        {
            LastSpawnedShell.Destroy();
        }

        Destroy();

        return;
    }

    RVT = Spawn(class'ROVolumeTest', self, , OriginalArtyLocation);

    // If the place this arty is falling has become a NoArtyVolume after the strike was called, cancel the strike
    if (RVT != none && RVT.IsInNoArtyVolume())
    {
        ROP = ROPlayer(InstigatorController);

        if (ROP != none)
        {
            ROP.ReceiveLocalizedMessage(class'ROArtilleryMsg', 5);
        }

        RVT.Destroy();

        if (LastSpawnedShell != none && !LastSpawnedShell.bDeleteMe)
        {
            LastSpawnedShell.Destroy();
        }

        Destroy();
       
        return;
    }

    RVT.Destroy();

    if (SpawnCounter <= BatterySize)
    {
        AimVec = vect(0.0, 0.0, 0.0);
        AimVec.X += Rand(SpreadAmount);

        if (FRand() > 0.5)
        {
           AimVec.X *= -1.0;
        }

        AimVec.Y += Rand(SpreadAmount);

        if (FRand() > 0.5)
        {
           AimVec.Y *= -1;
        }

        LastSpawnedShell = Spawn(class'DH_ArtilleryShell', InstigatorController, , Location + AimVec, rotator(PhysicsVolume.Gravity));

        SpawnCounter++;
        SetTimer(FRand() * 1.5, false);

        return;
    }

    if (SalvoCounter < SalvoAmount)
    {
        SalvoCounter++;
        SpawnCounter = 0;
        SetTimer(Max(Rand(20), 10), false); // time between salvos
    }
    else
    {
        Destroy();
    }
}

defaultproperties
{
}
