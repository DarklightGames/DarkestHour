//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2017
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

var() bool              bScaleStartingReinforcements;       // Scales starting reinforcements to current number of players
var() bool              bResetRoundTimer;                   // If true will reset the round's timer to the proper value when phase is over
var() bool              bPreventTimeChangeAtZeroReinf;      // bTimeChangesAtZeroReinf will be set to false for this match

var() TeamReinf         PhaseEndReinforcements;             // What to set reinforcements to at the end of the phase (-1 means no change)

var() sound             PhaseEndSounds[2];                  // Axis and Allies Round Begin Sound

var bool                bSkipPreStart;                      // If true will override the game's default PreStartTime, making it zero
var bool                bPlayersOpenedMenus;
var int                 TimerCount;
var int                 SetupPhaseDurationActual;
var int                 SpawningEnabledTimeActual;

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

    if (bPreventTimeChangeAtZeroReinf)
    {
        G.bTimeChangesAtZeroReinf = false;
    }

    // Handle more detailed timer
    SetupPhaseDurationActual = SetupPhaseDuration + 5;
    SpawningEnabledTimeActual = SpawningEnabledTime + 5;

    super.PreBeginPlay();
}

function Reset()
{
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

        // Tell GRI that we are no longer in setup phase (to allow player mantling)
        GRI.bIsInSetupPhase = false;

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

        // Handle Axis reinforcement changes
        if (PhaseEndReinforcements.AxisReinforcements >= 0)
        {
            GRI.SpawnsRemaining[AXIS_TEAM_INDEX] = PhaseEndReinforcements.AxisReinforcements + UnspawnedPlayers[AXIS_TEAM_INDEX];
        }
        else
        {
            GRI.SpawnsRemaining[AXIS_TEAM_INDEX] = G.LevelInfo.Axis.SpawnLimit + UnspawnedPlayers[AXIS_TEAM_INDEX];
        }

        // Handle Allied reinforcement changes
        if (PhaseEndReinforcements.AlliesReinforcements >= 0)
        {
            GRI.SpawnsRemaining[ALLIES_TEAM_INDEX] = PhaseEndReinforcements.AlliesReinforcements + UnspawnedPlayers[ALLIES_TEAM_INDEX];
        }
        else
        {
            GRI.SpawnsRemaining[ALLIES_TEAM_INDEX] = G.LevelInfo.Allies.SpawnLimit + UnspawnedPlayers[ALLIES_TEAM_INDEX];
        }

        // Now scale the reinforcements if desired
        if (bScaleStartingReinforcements)
        {
            // Scale reinforcements based on NumPlayers / Maxplayers, but only by a factor of 50%
            // Example: 400 is base reinf
            // = 400 - ((400 / 2.0) * (1.0 - 22 / 64))
            // = 400 - (200.0 * 0.6562)
            // with 22/64 players the reinf would be 269 instead of 400
            GRI.SpawnsRemaining[ALLIES_TEAM_INDEX] = G.LevelInfo.Allies.SpawnLimit - ((G.LevelInfo.Allies.SpawnLimit / 2.0) * (1.0 - G.NumPlayers / G.MaxPlayers));
            GRI.SpawnsRemaining[AXIS_TEAM_INDEX] = G.LevelInfo.Axis.SpawnLimit - ((G.LevelInfo.Axis.SpawnLimit / 2.0) * (1.0 - G.NumPlayers / G.MaxPlayers));
        }

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
        for (C = Level.ControllerList; C != none; C = C.NextController)
        {
            PC = PlayerController(C);

            if (PC != none && (PC.GetTeamNum() == AXIS_TEAM_INDEX || PC.GetTeamNum() == ALLIES_TEAM_INDEX))
            {
                PC.ReceiveLocalizedMessage(class'DHSetupPhaseMessage', 1);
                PC.PlayAnnouncement(PhaseEndSounds[PC.GetTeamNum()], 1, true);
            }
        }

        GotoState('Done');
    }
}

state Done
{
}

defaultproperties
{
    PhaseBoundaryTag='SetupBoundaries'
    PhaseEndReinforcements=(AxisReinforcements=-1,AlliesReinforcements=-1)
    PhaseEndSounds(0)=Sound'DH_SundrySounds.RoundBeginSounds.Axis_Start'
    PhaseEndSounds(1)=Sound'DH_SundrySounds.RoundBeginSounds.US_Start'
    bSkipPreStart=true
    bScaleStartingReinforcements=true
    SetupPhaseDuration=60
    SpawningEnabledTime=30
    Texture=Texture'DHEngine_Tex.LevelActor'
    bHidden=true
    RemoteRole=ROLE_None
}
