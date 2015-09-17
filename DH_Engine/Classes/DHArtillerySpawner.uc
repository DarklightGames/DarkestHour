//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DHArtillerySpawner extends ROArtillerySpawner;

// Modified to spawn DHArtilleryShell instead of RO version
function Timer()
{
    local DHVolumeTest RVT;
    local vector       AimVec;

    // Destroy this actor if the round is over or if the arty officer has switched teams or left the server
    if (!ROTeamGame(Level.Game).IsInState('RoundInPlay') || InstigatorController == none || InstigatorController.GetTeamNum() != OwningTeam)
    {
        if (LastSpawnedShell != none && !LastSpawnedShell.bDeleteMe)
        {
            LastSpawnedShell.Destroy();
        }

        Destroy();

        return;
    }

    RVT = Spawn(class'DHVolumeTest', self,, OriginalArtyLocation);

    // If the place this arty is falling has become a NoArtyVolume after the strike was called, cancel the strike
    if (RVT != none && RVT.IsInNoArtyVolume())
    {
        if (ROPlayer(InstigatorController) != none)
        {
            ROPlayer(InstigatorController).ReceiveLocalizedMessage(class'ROArtilleryMsg', 5); // not a valid artillery target
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

    // If this salvo still has remaining shells to land, set a new timer & exit
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
           AimVec.Y *= -1.0;
        }

        LastSpawnedShell = Spawn(class'DHArtilleryShell', InstigatorController,, Location + AimVec, rotator(PhysicsVolume.Gravity));

        SpawnCounter++;
        SetTimer(FRand() * 1.5, false); // randomised time between individual shells landing

        return;
    }

    // If we still have remaining salvo(s) then set a new timer, otherwise destroy this actor
    if (SalvoCounter < SalvoAmount)
    {
        SalvoCounter++;
        SpawnCounter = 0;
        SetTimer(Max(Rand(20), 10), false); // randomised time between each salvo
    }
    else
    {
        Destroy();
    }
}

defaultproperties
{
}
