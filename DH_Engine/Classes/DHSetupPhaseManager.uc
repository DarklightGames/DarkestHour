//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
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
var() array<name>       SetupPhaseBoundaryVols;             // Array of minefield volumes to disable once setup phase is over
var() array<name>       SetupPhaseBoundaryDSMs;             // Array of DestroyableStaticMeshes to disable once phase is over
var() bool              bScaleStartingReinforcements;       // Scales starting reinforcements to current number of players
var() bool              bReplacePreStart;                   // If true will override the game's default PreStartTime, making it zero
var() bool              bResetRoundTimer;                   // If true will reset the round's timer to the proper value when phase is over
var() TeamReinf         PhaseEndReinforcements;             // What to set reinforcements to at the end of the phase (0 means no change, -1 set to zero)
var() bool              bPreventTimeChangeAtZeroReinf;      // bTimeChangesAtZeroReinf will be set to false for this match
var() int               SpawningEnabledTime;                // Round time at which players can spawn
var() sound             PhaseEndSound;

var int                 TimerCount;
var int                 SetupPhaseDurationActual;
var int                 SpawningEnabledTimeActual;
var bool                bPlayersCanNowSpawn;

event PreBeginPlay()
{
    local DarkestHourGame G;

    G = DarkestHourGame(Level.Game);

    if (G == none)
    {
        return;
    }

    // Remove the pre start time if we are using a post-start setup phase!
    if (bReplacePreStart)
    {
        G.PreStartTime = 0;
    }

    if (bPreventTimeChangeAtZeroReinf)
    {
        G.bTimeChangesAtZeroReinf = false;
    }

    // Handle more detailed timer
    SetupPhaseDurationActual = SetupPhaseDuration + 5;
    SpawningEnabledTimeActual = SpawningEnabledTime + 5;

    // Handle other Game setup

    super.PreBeginPlay();
}

function Reset()
{
    bPlayersCanNowSpawn = false;
    TimerCount = 0;
    GotoState('Initialize');
}

auto state Initialize
{
    function BeginState()
    {
        GotoState('Timing');
    }
}

state Timing
{
    function BeginState()
    {
        local DHGameReplicationInfo GRI;

        GRI = DHGameReplicationInfo(Level.Game.GameReplicationInfo);

        if (GRI == none)
        {
            return;
        }

        GRI.SpawningEnableTime = SpawningEnabledTimeActual;

        SetTimer(1.0, true);
    }

    function Timer()
    {
        local string s;
        local Controller C;
        local PlayerController PC;

        if (TimerCount < SetupPhaseDurationActual)
        {
            // Set the message out every 5 seconds
            if (TimerCount > 0 && TimerCount % 1 == 0)
            {
                for (C = Level.ControllerList; C != none; C = C.NextController)
                {
                    PC = PlayerController(C);

                    if (PC != none)
                    {
                        s = Repl(PhaseMessage, "{0}", SetupPhaseDurationActual - TimerCount);
                        PC.ClientMessage(s,'CriticalEvent');
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

        // Disable phase boundaries (volumes are static)
        foreach AllActors(class'ROMineVolume', V)
        {
            for (i = 0; i < SetupPhaseBoundaryVols.Length; ++i)
            {
                if (V.Tag == SetupPhaseBoundaryVols[i])
                {
                    V.Deactivate();
                }
            }
        }

        // Disable DSMS
        foreach AllActors(class'DHDestroyableSM', DSM)
        {
            for (i = 0; i < SetupPhaseBoundaryDSMs.Length; ++i)
            {
                if (DSM.Tag == SetupPhaseBoundaryDSMs[i])
                {
                    DSM.DestroyDSM(none);
                }
            }
        }

        // Reset round time if desired
        if (bResetRoundTimer)
        {
            G.ModifyRoundTime(G.LevelInfo.RoundDuration*60, 2);
        }

        // Reset reinforcements (scaled if true)
        if (bScaleStartingReinforcements)
        {
            GRI.SpawnsRemaining[ALLIES_TEAM_INDEX] = G.LevelInfo.Allies.SpawnLimit * FMax(0.1, (G.NumPlayers / G.MaxPlayers));
            GRI.SpawnsRemaining[AXIS_TEAM_INDEX] = G.LevelInfo.Axis.SpawnLimit * FMax(0.1, (G.NumPlayers / G.MaxPlayers));
        }

        // Handle phase end reinforcement changes
        if (PhaseEndReinforcements.AxisReinforcements != 0)
        {
            if (PhaseEndReinforcements.AxisReinforcements == -1)
            {
                GRI.SpawnsRemaining[AXIS_TEAM_INDEX] = 0;
            }
            else
            {
                GRI.SpawnsRemaining[AXIS_TEAM_INDEX] = PhaseEndReinforcements.AxisReinforcements;
            }
        }

        if (PhaseEndReinforcements.AlliesReinforcements != 0)
        {
            if (PhaseEndReinforcements.AlliesReinforcements == -1)
            {
                GRI.SpawnsRemaining[ALLIES_TEAM_INDEX] = 0;
            }
            else
            {
                GRI.SpawnsRemaining[ALLIES_TEAM_INDEX] = PhaseEndReinforcements.AlliesReinforcements;
            }
        }

        // Announce the end of the phase
        for (C = Level.ControllerList; C != none; C = C.NextController)
        {
            PC = PlayerController(C);

            if (PC != none)
            {
                PC.ClientMessage(PhaseEndMessage,'CriticalEvent');
                PC.PlayAnnouncement(PhaseEndSound, 1, true);
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
    PhaseEndSound=sound'DH_AlliedVehicleSounds.higgins.HigginsRampOpen01''
    PhaseMessage="Round Begins In: {0} seconds"
    PhaseEndMessage="Round Has Started!"
    bReplacePreStart=true
    bScaleStartingReinforcements=true
    SetupPhaseDuration=60
    SpawningEnabledTime=30
    Texture=texture'DHEngine_Tex.LevelActor'
    bHidden=true
    RemoteRole=ROLE_None
}
