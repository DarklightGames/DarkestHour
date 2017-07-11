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

var() localized string  PhaseMessage;                       // Message to send periodically when phase is current
var() localized string  PhaseEndMessage;                    // Message to send to team when end is reached
var() int               SetupPhaseDuration;                 // How long should the setup phase be in seconds

var() name              PhaseMineFieldTag;                  // Tag of minefield volumes to disable once setup phase is over
var() name              PhaseBoundaryTag;                   // Tag of DestroyableStaticMeshes to disable once phase is over
var() array<name>       InitialSpawnPointTags;              // Tags of spawn points that should only be active while in setup phase

var() bool              bSkipPreStart;                      // If true will override the game's default PreStartTime, making it zero
var() bool              bResetRoundTimer;                   // If true will reset the round's timer to the proper value when phase is over
var() TeamReinf         PhaseEndReinforcements;             // What to set reinforcements to at the end of the phase (-1 means no change)
var() bool              bPreventTimeChangeAtZeroReinf;      // bTimeChangesAtZeroReinf will be set to false for this match
var() int               SpawningEnabledTime;                // Round time at which players can spawn
var() sound             PhaseEndSounds[2];                  // Axis and Allies Round Begin Sound

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

        if (TimerCount < SetupPhaseDurationActual)
        {
            // Set the message out every x seconds (currently every 1 second)
            if (TimerCount > 0 && TimerCount % 1 == 0)
            {
                for (C = Level.ControllerList; C != none; C = C.NextController)
                {
                    PC = PlayerController(C);

                    if (PC != none)
                    {
                        PC.ClientMessage(Repl(PhaseMessage, "{0}", SetupPhaseDurationActual - TimerCount), 'CriticalEvent');
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
        local int i;
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

        // Reset round time if desired
        if (bResetRoundTimer)
        {
            G.ModifyRoundTime(G.LevelInfo.RoundDuration * 60, 2);
        }

        // Handle Axis reinforcement changes, if any
        if (PhaseEndReinforcements.AxisReinforcements >= 0)
        {
            GRI.SpawnsRemaining[AXIS_TEAM_INDEX] = PhaseEndReinforcements.AxisReinforcements;
        }

        // Handle  Allied reinforcement changes, if any
        if (PhaseEndReinforcements.AlliesReinforcements >= 0)
        {
            GRI.SpawnsRemaining[ALLIES_TEAM_INDEX] = PhaseEndReinforcements.AlliesReinforcements;
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

            if (PC != none)
            {
                PC.ClientMessage(Repl(PhaseEndMessage, "{0}", GRI.SpawnsRemaining[PC.GetTeamNum()]), 'CriticalEvent');
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
    PhaseEndReinforcements=(AxisReinforcements=-1,AlliesReinforcements=-1)
    PhaseEndSounds(0)=sound'DH_SundrySounds.RoundBeginSounds.Axis_Start'
    PhaseEndSounds(1)=sound'DH_SundrySounds.RoundBeginSounds.US_Start'
    PhaseMessage="Round Begins In: {0} seconds"
    PhaseEndMessage="Round Has Started! Your team begins with {0} reinforcements."
    bSkipPreStart=true
    SetupPhaseDuration=60
    SpawningEnabledTime=30
    Texture=texture'DHEngine_Tex.LevelActor'
    bHidden=true
    RemoteRole=ROLE_None
}
