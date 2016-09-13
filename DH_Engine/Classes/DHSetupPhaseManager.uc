//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DHSetupPhaseManager extends Actor
    placeable
    hidecategories(Collision,Lighting,LightColor,Karma,Force,Sound);

var() localized string  PhaseMessage;                       // Message to send periodically when phase is current
var() localized string  PhaseEndMessage;                    // Message to send to team when end is reached
var() int               SetupPhaseDuration;                 // How long should the setup phase be in seconds
var() array<name>       SetupPhaseBoundaryVols;             // Array of minefield volumes to disable once setup phase is over
var() bool              bScaleStartingReinforcements;       // Scales starting reinforcements to current number of players
var() bool              bReplacePreStart;                   // If true will override the game's default PreStartTime, making it zero

var int                 TimerCount;

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

    super.PreBeginPlay();
}

function Reset()
{
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

        SetTimer(1.0, true);
    }

    function Timer()
    {
        local int i;
        local string s;
        local Controller C;
        Local PlayerController PC;
        local ROMineVolume V;
        local DarkestHourGame G;
        local DHGameReplicationInfo GRI;

        if (TimerCount < SetupPhaseDuration)
        {
            // Set the message out every 5 seconds
            if (TimerCount % 5 == 0)
            {
                for (C = Level.ControllerList; C != none; C = C.NextController)
                {
                    PC = PlayerController(C);

                    if (PC != none)
                    {
                        s = Repl(PhaseMessage, "{0}", SetupPhaseDuration - TimerCount);
                        PC.ClientMessage(s,'CriticalEvent');
                    }
                }
            }

            ++TimerCount;
            return;
        }

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

        // Reset reinforcements (scaled if true)
        if (bScaleStartingReinforcements)
        {
            GRI.SpawnsRemaining[ALLIES_TEAM_INDEX] = G.LevelInfo.Allies.SpawnLimit * FMax(0.1, (G.NumPlayers / G.MaxPlayers));
            GRI.SpawnsRemaining[AXIS_TEAM_INDEX] = G.LevelInfo.Axis.SpawnLimit * FMax(0.1, (G.NumPlayers / G.MaxPlayers));
        }
        else
        {
            GRI.SpawnsRemaining[ALLIES_TEAM_INDEX] = G.LevelInfo.Allies.SpawnLimit;
            GRI.SpawnsRemaining[AXIS_TEAM_INDEX] = G.LevelInfo.Axis.SpawnLimit;
        }

        // Set the end message out
        for (C = Level.ControllerList; C != none; C = C.NextController)
        {
            PC = PlayerController(C);

            if (PC != none)
            {
                PC.ClientMessage(PhaseEndMessage,'CriticalEvent');
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
    PhaseMessage="In Setup Phase ({0} seconds remaining)"
    PhaseEndMessage="Setup Phase Ended! LIVE LIVE LIVE!"
    bReplacePreStart=true
    bScaleStartingReinforcements=true
    SetupPhaseDuration=60
    Texture=texture'DHEngine_Tex.LevelActor'
    bHidden=true
    RemoteRole=ROLE_None
}
