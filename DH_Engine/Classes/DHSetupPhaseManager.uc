//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DHSetupPhaseManager extends Actor
    placeable
    hidecategories(Collision,Lighting,LightColor,Karma,Force,Sound);

struct TeamReinf
{
    var() int AxisReinforcements, AlliesReinforcements;
};

var() int               SetupPhaseDuration;                 // How long should the setup phase be in seconds
var() int               SpawningEnabledTime;                // Round time at which players can spawn

var() name              PhaseMineFieldTag;                  // Tag of minefield volumes to disable once setup phase is over
var() name              PhaseBoundaryTag;                   // Tag of DestroyableStaticMeshes to disable once phase is over
var() array<name>       InitialSpawnPointTags;              // Tags of spawn points that should only be active while in setup phase

var() bool              bScaleUpPhaseEndReinforcements;     // Scales the reinforcements set in "PhaseEndReinforcements" upward to account for more players
var() bool              bResetRoundTimer;                   // If true will reset the round's timer to the proper value when phase is over

var() TeamReinf         PhaseEndReinforcements;             // What to set reinforcements to at the end of the phase (-1 means no change)

var bool                bSkipPreStart;                      // If true will override the game's default PreStartTime, making it zero
var bool                bPlayersOpenedMenus;
var int                 TimerCount;
var int                 SetupPhaseDurationActual;
var int                 SpawningEnabledTimeActual;

function ModifySetupPhaseDuration(int Seconds, optional bool bSetToValue);

event PreBeginPlay()
{
    local DarkestHourGame G;

    G = DarkestHourGame(Level.Game);

    if (G == none)
    {
        return;
    }

    // Skip the pre start time if we are using a post-start setup phase!
    if (bSkipPreStart)
    {
        G.bSkipPreStartTime = true;
    }

    // Handle more detailed timer
    SetupPhaseDurationActual = SetupPhaseDuration + 5;
    SpawningEnabledTimeActual = SpawningEnabledTime + 5;

    super.PreBeginPlay();
}

function Reset()
{
    SetupPhaseDurationActual = SetupPhaseDuration;
    TimerCount = 0;
    bPlayersOpenedMenus = false;
    GotoState('Timing');
}

auto state Timing
{
    function BeginState()
    {
        local DHGameReplicationInfo GRI;

        GRI = DHGameReplicationInfo(Level.Game.GameReplicationInfo);

        if (GRI == none)
        {
            return;
        }

        // Reset
        bPlayersOpenedMenus = false;

        // Prevent weapon dropping
        Level.Game.bAllowWeaponThrowing = false;

        // Set the time at which spawning is allowed
        GRI.SpawningEnableTime = SpawningEnabledTimeActual;

        // Tell GRI that we are in setup phase (to prevent player mantling)
        GRI.bIsInSetupPhase = true;

        SetTimer(1.0, true);
    }

    function Timer()
    {
        local Controller C;
        local PlayerController PC;

        // Have everyone open their deploy menu
        if (!bPlayersOpenedMenus && DarkestHourGame(Level.Game) != none)
        {
            DarkestHourGame(Level.Game).OpenPlayerMenus();
            bPlayersOpenedMenus = true;
        }

        if (TimerCount < SetupPhaseDurationActual)
        {
            // Set the message out every x seconds (currently every second)
            if (TimerCount > 0 && TimerCount % 1 == 0)
            {
                for (C = Level.ControllerList; C != none; C = C.NextController)
                {
                    PC = PlayerController(C);

                    if (PC != none)
                    {
                        PC.ReceiveLocalizedMessage(class'DHSetupPhaseMessage', class'UInteger'.static.FromShorts(0, SetupPhaseDurationActual - TimerCount));
                    }
                }
            }

            ++TimerCount;
            return;
        }

        PhaseEnded();
    }

    function PhaseEnded()
    {
        local int i, UnspawnedPlayers[2];
        local Controller C;
        local PlayerController PC;
        local ROMineVolume V;
        local DHDestroyableSM DSM;
        local DarkestHourGame G;
        local DHGameReplicationInfo GRI;
        local float ScaleUpModifier;
        local Sound TeamRoundStartSounds[2];
        local DH_LevelInfo LI;

        TimerCount = 0;

        G = DarkestHourGame(Level.Game);

        if (G == none)
        {
            return;
        }

        GRI = DHGameReplicationInfo(G.GameReplicationInfo);

        if (GRI == none)
        {
            return;
        }

        // Allow weapon dropping
        G.bAllowWeaponThrowing = true;

        // Disable phase minefields (volumes are static, so use AllActors)
        if (PhaseMineFieldTag != '')
        {
            foreach AllActors(class'ROMineVolume', V, PhaseMineFieldTag)
            {
                V.Deactivate();
            }
        }

        if (PhaseBoundaryTag != '')
        {
            // Remove boundary (DSMs are dynamic)
            foreach DynamicActors(class'DHDestroyableSM', DSM, PhaseBoundaryTag)
            {
                DSM.DestroyDSM(none);
            }
        }

        // Get number of unspawned players
        for (C = Level.ControllerList; C != none; C = C.NextController)
        {
            PC = PlayerController(C);

            // Get the number of players not spawned on each team, we are going to add the number to the final reinforcement pool
            if (PC != none && PC.Pawn == none && PC.GetTeamNum() < arraycount(UnspawnedPlayers))
            {
                ++UnspawnedPlayers[PC.GetTeamNum()];
            }
        }

        if (bScaleUpPhaseEndReinforcements)
        {
            // Scale up the reinforcements at a factor of the number of players on the server / 2
            // Example: PhaseEndReinforcements=(AxisReinforcements=8,AlliesReinforcements=10)
            // There are 50 players on the server
            // 8 * (50 / 2) = 200
            // 10 * (50 / 2) = 250
            ScaleUpModifier = Max(10, G.GetNumPlayers()) * 0.5;
        }
        else
        {
            ScaleUpModifier = 1.0;
        }

        // Set the reinforcements
        if (PhaseEndReinforcements.AlliesReinforcements < 0)
        {
            GRI.SpawnsRemaining[ALLIES_TEAM_INDEX] = PhaseEndReinforcements.AlliesReinforcements;
        }
        else
        {
            GRI.SpawnsRemaining[ALLIES_TEAM_INDEX] = PhaseEndReinforcements.AlliesReinforcements * ScaleUpModifier + UnspawnedPlayers[ALLIES_TEAM_INDEX];
        }

        if (PhaseEndReinforcements.AxisReinforcements < 0)
        {
            GRI.SpawnsRemaining[AXIS_TEAM_INDEX] = PhaseEndReinforcements.AxisReinforcements;
        }
        else
        {
            GRI.SpawnsRemaining[AXIS_TEAM_INDEX] = PhaseEndReinforcements.AxisReinforcements * ScaleUpModifier + UnspawnedPlayers[AXIS_TEAM_INDEX];
        }

        // Set the starting reinforcements in DHGame (for use in reinforcement warning calculation)
        G.SpawnsAtRoundStart[ALLIES_TEAM_INDEX] = GRI.SpawnsRemaining[ALLIES_TEAM_INDEX];
        G.SpawnsAtRoundStart[AXIS_TEAM_INDEX] = GRI.SpawnsRemaining[AXIS_TEAM_INDEX];

        // Reset round time if desired
        if (bResetRoundTimer)
        {
            G.ModifyRoundTime(G.LevelInfo.RoundDuration * 60, 2);
        }

        // Deactivate any initial spawn points
        if (G.SpawnManager != none)
        {
            for (i = 0; i < InitialSpawnPointTags.Length; ++i)
            {
                G.SpawnManager.SetSpawnPointIsActiveByTag(InitialSpawnPointTags[i], false);
            }
        }

        // Announce the end of the phase
        LI = class'DH_LevelInfo'.static.GetInstance(Level);

        TeamRoundStartSounds[AXIS_TEAM_INDEX] = LI.GetTeamNationClass(AXIS_TEAM_INDEX).default.RoundStartSound;
        TeamRoundStartSounds[ALLIES_TEAM_INDEX] = LI.GetTeamNationClass(ALLIES_TEAM_INDEX).default.RoundStartSound;

        for (C = Level.ControllerList; C != none; C = C.NextController)
        {
            PC = PlayerController(C);

            if (PC != none && (PC.GetTeamNum() == AXIS_TEAM_INDEX || PC.GetTeamNum() == ALLIES_TEAM_INDEX))
            {
                PC.ReceiveLocalizedMessage(class'DHSetupPhaseMessage', 1);
                PC.PlayAnnouncement(TeamRoundStartSounds[PC.GetTeamNum()], 1, true);
            }
        }

        // Tell GRI that we are no longer in setup phase (to allow player mantling)
        GRI.bIsInSetupPhase = false;

        GotoState('Done');
    }

    function ModifySetupPhaseDuration(int Seconds, optional bool bSetToValue)
    {
        if (bSetToValue)
        {
            TimerCount = 0;
            SetupPhaseDurationActual = Max(0, Seconds);
        }
        else
        {
            SetupPhaseDurationActual += Seconds;
        }
    }
}

state Done
{
}

defaultproperties
{
    PhaseBoundaryTag="SetupBoundaries"
    PhaseEndReinforcements=(AxisReinforcements=18,AlliesReinforcements=18)
    bSkipPreStart=true
    bScaleUpPhaseEndReinforcements=true
    SetupPhaseDuration=60
    SpawningEnabledTime=30
    Texture=Texture'DHEngine_Tex.LevelActor'
    bHidden=true
    RemoteRole=ROLE_None
}
