//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DHArtillerySpawner extends ROArtillerySpawner;

var     DHArtilleryShell    LastSpawnedDHShell; // reference to the last DH artillery shell spawned by this arty spawner

// Modified to use LastSpawnedDHShell instead of LastSpawnedShell
function Destroyed()
{
    if (ROGameReplicationInfo(Level.Game.GameReplicationInfo) != none)
    {
        ROGameReplicationInfo(Level.Game.GameReplicationInfo).ArtyStrikeLocation[OwningTeam] = vect(0.0, 0.0, 0.0); // remove arty location from GRI
    }

    LastSpawnedDHShell = none;
}

// Modified to fix log errors causing 1 extra salvo & 1 extra shell per salvo (also re-factored optimise slightly)
// Also to spawn DHArtilleryShell & LastSpawnedDHShell instead of RO versions
function Timer()
{
    local DHVolumeTest VT;
    local vector       RandomSpread;
    local bool         bInvalid;

    // Cancel the strike if the round is over or if the arty officer has switched teams or left the server
    if ((ROTeamGame(Level.Game) != none && !ROTeamGame(Level.Game).IsInState('RoundInPlay')) || InstigatorController == none || InstigatorController.GetTeamNum() != OwningTeam)
    {
        bInvalid = true;
    }
    // Check whether the target location has become a NoArtyVolume after the strike was called - if it has then cancel the strike
    else
    {
        VT = Spawn(class'DHVolumeTest', self,, OriginalArtyLocation);

        if (VT != none)
        {
            if (VT.IsInNoArtyVolume())
            {
                bInvalid = true;

                if (PlayerController(InstigatorController) != none)
                {
                    PlayerController(InstigatorController).ReceiveLocalizedMessage(class'ROArtilleryMsg', 5); // not a valid artillery target
                }
            }

            VT.Destroy();
        }
    }

    // If not a valid strike then destroy this actor & any recorded shell
    if (bInvalid)
    {
        if (LastSpawnedDHShell != none && !LastSpawnedDHShell.bDeleteMe)
        {
            LastSpawnedDHShell.Destroy();
        }

        Destroy();

        return;
    }

    // Make sure this salvo hasn't finished & then spawn an arty shell, with randomised spread based on the map's arty settings for the team
    if (SpawnCounter < BatterySize)
    {
        RandomSpread.X += Rand((2 * SpreadAmount) + 1) - SpreadAmount; // gives +/- zero to SpreadAmount
        RandomSpread.Y += Rand((2 * SpreadAmount) + 1) - SpreadAmount;

        LastSpawnedDHShell = Spawn(class'DHArtilleryShell', InstigatorController,, Location + RandomSpread, rotator(PhysicsVolume.Gravity));
        SpawnCounter++;

        // If this salvo still has remaining shells to land, set a new, fairly short timer to spawn the next shell & exit
        if (SpawnCounter < BatterySize)
        {
            SetTimer(FRand() * 1.5, false); // randomised 0 to 1.5 seconds between shells

            return;
        }
        // Otherwise this salvo has ended so increment the salvo counter
        else
        {
            SalvoCounter++;
        }
    }

    // If there's still at least one more salvo to come, set a new, longer timer to start the next salvo
    if (SalvoCounter < SalvoAmount)
    {
        SpawnCounter = 0; // reset shell counter for next salvo
        SetTimer(10.0 + (10.0 * FRand()), false); // randomised 10 to 20 seconds between salvoes
    }
    // Otherwise destroy this actor as the arty strike has finished
    else
    {
        Destroy();
    }
}

defaultproperties
{
    RemoteRole=ROLE_None // added as no need for this actor to replicate to net clients
}
