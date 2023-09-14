//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DHArtillerySpawner extends Actor;

var     int     OwningTeam;   // index no. of our team
var     int     ShellCounter; // no. of shells fired so far in current salvo (renamed from SpawnCounter)
var     int     SalvoCounter; // no. of salvoes fired so far

var     DHArtilleryShell    LastSpawnedShell; // reference to the last artillery shell spawned by this arty spawner

// Arty strike properties, taken from team's arty settings in the map's DHLevelInfo
var     int     BatterySize;  // no. of shells per salvo
var     int     SalvoAmount;  // no. of salvoes in this strike
var     int     SpreadAmount; // randomised spread of each shell (in UU)

// From deprecated ROArtillerySpawner, optimised a little
// And setting a LifeSpan for this actor, as a fail-safe in case the sequence of timers somehow gets interrupted & we don't ever get to end of arty strike
function PostBeginPlay()
{
    local ROLevelInfo LI;
    local float       StrikeDelay, MaxSalvoDuration;

    if (Controller(Owner) != none && ROTeamGame(Level.Game) != none && ROTeamGame(Level.Game).LevelInfo != none && ROGameReplicationInfo(Level.Game.GameReplicationInfo) != none)
    {
        // Record the team that called this arty strike
        // Also save strike position to GRI so team players see it on their map (note this also prevents team calling another strike until this one is over)
        OwningTeam = Controller(Owner).GetTeamNum();
        ROGameReplicationInfo(Level.Game.GameReplicationInfo).ArtyStrikeLocation[OwningTeam] = Location;

        // Get arty strike properties from our team's settings in the map's DHLevelInfo
        LI = ROTeamGame(Level.Game).LevelInfo;
        BatterySize = LI.GetBatterySize(OwningTeam);
        SalvoAmount = LI.GetSalvoAmount(OwningTeam);
        SpreadAmount = LI.GetSpreadAmount(OwningTeam);
        StrikeDelay = float(LI.GetStrikeDelay(OwningTeam)) * (0.85 + (FRand() * 0.3));  // +/- 15% randomisation on delay

        // Set timer until arty strike begins
        SetTimer(FMin(StrikeDelay, 1.0), false); // added a minimum to avoid any possibility of setting a null timer

        // Set LifeSpan until this actor destroys itself
        // Added as a fail-safe in case the sequence of timers somehow gets interrupted & we don't ever get to end of arty strike
        // If that happened this actor wouldn't destroy itself & arty strike would remain 'live', stopping the team from calling any more arty
        // This actor's LifeSpan is set to the maximum possible length of the strike, assuming the max random time between shells & salvoes
        MaxSalvoDuration = float(BatterySize - 1) * 1.5;
        LifeSpan = StrikeDelay + (float(SalvoAmount - 1) * 20.0) + (float(SalvoAmount) * MaxSalvoDuration) + 1.0;
    }
    else
    {
        Log("DHArtillerySpawner ERROR: spawned but missing vital actor(s) so destroying itself (Owner =" @ Owner $ ")");
        Destroy();
    }
}

// From deprecated ROArtillerySpawner
function Destroyed()
{
    if (ROGameReplicationInfo(Level.Game.GameReplicationInfo) != none)
    {
        ROGameReplicationInfo(Level.Game.GameReplicationInfo).ArtyStrikeLocation[OwningTeam] = vect(0.0, 0.0, 0.0);
    }
    else
    {
        Log("DHArtillerySpawner ERROR: actor destroyed but no GRI so can't clear the ArtyStrikeLocation to end the strike!");
    }

    LastSpawnedShell = none;
}

// Modified from deprecated ROArtillerySpawner to fix log errors causing 1 extra salvo & 1 extra shell per salvo (& re-factored a little to optimise)
// Also spawning shells a fixed distance above strike location as this actor is now located on strike location & we have deprecated OriginalArtyLocation
// And to stop shell being always net relevant to player who called arty as he was made its owner (now use another method to set shell's InstigatorController)
// Benefit if player re-spawns or otherwise moves well away from arty strike, as server can decide whether shells are relevant & should be replicated to him
function Timer()
{
    local DHVolumeTest VT;
    local vector       RandomSpread;
    local bool         bInvalid;

    // Cancel the strike if the arty officer has switched teams or left the server, or if the round is over
    if (Controller(Owner) == none || Controller(Owner).GetTeamNum() != OwningTeam || !(ROTeamGame(Level.Game) != none && ROTeamGame(Level.Game).IsInState('RoundInPlay')))
    {
        bInvalid = true;
    }
    // Check whether the target location has become a NoArtyVolume after the strike was called - if it has then cancel the strike
    else
    {
        VT = Spawn(class'DHVolumeTest', self,, Location); // using Location instead of deprecated OriginalArtyLocation this actor now located on strike location

        if (VT != none)
        {
            if (VT.DHIsInNoArtyVolume(DHGameReplicationInfo(Level.Game.GameReplicationInfo)))
            {
                bInvalid = true;

                if (Owner.IsA('PlayerController'))
                {
                    PlayerController(Owner).ReceiveLocalizedMessage(class'ROArtilleryMsg', 5); // not a valid artillery target
                }
            }

            VT.Destroy();
        }
    }

    // If not a valid strike then destroy this actor & any recent shell it spawned
    if (bInvalid)
    {
        if (LastSpawnedShell != none && !LastSpawnedShell.bDeleteMe)
        {
            LastSpawnedShell.Destroy();
        }

        Destroy();

        return;
    }

    // Make sure this salvo hasn't finished & then spawn an arty shell, with randomised spread based on the map's arty settings for the team
    if (ShellCounter < BatterySize)
    {
        RandomSpread.X += Rand((2 * SpreadAmount) + 1) - SpreadAmount; // gives +/- zero to SpreadAmount
        RandomSpread.Y += Rand((2 * SpreadAmount) + 1) - SpreadAmount;

        // Altered to spawn shell a standard approx 50m above strike location & to use a different method of setting shell's InstigatorController
        LastSpawnedShell = Spawn(class'DHArtilleryShell',,, Location + vect(0.0, 0.0, 3000.0) + RandomSpread, rotator(PhysicsVolume.Gravity));

        if (LastSpawnedShell != none)
        {
            LastSpawnedShell.SetInstigatorController(Controller(Owner));
            ShellCounter++;
        }

        // If this salvo still has remaining shells to land, set a new, fairly short timer to spawn the next shell & exit
        if (ShellCounter < BatterySize)
        {
            SetTimer(0.05 + (FRand() * 1.45), false); // randomised 0.05 to 1.5 seconds between shells (0.05 minimum to avoid any possibility of setting a null timer)

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
        ShellCounter = 0; // reset shell counter for next salvo
        SetTimer(10.0 + (FRand() * 10.0), false); // randomised 10 to 20 seconds between salvoes
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
    DrawType=DT_None
}
