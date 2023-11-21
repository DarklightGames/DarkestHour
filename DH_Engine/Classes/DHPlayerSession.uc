//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DHPlayerSession extends Object;

var string      IDHash;
var int         WeaponLockViolations;
var int         WeaponUnlockTime;
var int         LastKilledTime;
var int         Kills;
var int         Deaths;
var int         NextChangeTeamTime;
var byte        TeamIndex;

var DHScoreManager ScoreManager;

function Save(DHPlayer PC)
{
    local DHPlayerReplicationInfo PRI;

    if (PC == none)
    {
        Log("Failed to save player session: No constroller");
        return;
    }

    PRI = DHPlayerReplicationInfo(PC.PlayerReplicationInfo);

    if (PRI == none)
    {
        Log("Failed to save player session: No PRI");
        return;
    }

    // Scores
    ScoreManager = PC.ScoreManager;
    Deaths = PRI.Deaths;
    Kills = PRI.Kills;

    // Misc
    LastKilledTime = PC.LastKilledTime;
    NextChangeTeamTime = PC.NextChangeTeamTime;

    // Weapon lock
    WeaponUnlockTime = PC.WeaponUnlockTime;
    WeaponLockViolations = PC.WeaponLockViolations;

    // Save current team
    if (PRI.Team != none)
    {
        TeamIndex = PRI.Team.TeamIndex;
    }
    else
    {
        TeamIndex = 255;
    }
}

function Load(DHPlayer PC)
{
    local DHPlayerReplicationInfo PRI;
    local DHGameReplicationInfo GRI;
    local DarkestHourGame DHG;
    local int i;

    if (PC == none)
    {
        Log("Failed to load player session: No controller");
        return;
    }

    PRI = DHPlayerReplicationInfo(PC.PlayerReplicationInfo);

    if (PRI == none)
    {
        Log("Failed to load player session: No PRI");
        return;
    }

    if (ScoreManager != none)
    {
        PC.ScoreManager = ScoreManager;
    }
    else
    {
        Log("Error when loading player session: Missing ScoreManager");
    }

    // Scores
    PRI.Deaths = Deaths;
    PRI.Kills = Kills;
    PRI.DHKills = Kills;
    PRI.Score = ScoreManager.TotalScore;
    PRI.TotalScore = ScoreManager.TotalScore;

    for (i = 0; i < arraycount(PRI.CategoryScores); ++i)
    {
        PRI.CategoryScores[i] = ScoreManager.CategoryScores[i];
    }

    // Misc
    PC.LastKilledTime = LastKilledTime;
    PC.NextChangeTeamTime = NextChangeTeamTime;

    // Weapon lock
    PC.WeaponLockViolations = WeaponLockViolations;

    GRI = DHGameReplicationInfo(PC.GameReplicationInfo);

    if (GRI != none && WeaponUnlockTime > GRI.ElapsedTime)
    {
        PC.LockWeapons(WeaponUnlockTime - GRI.ElapsedTime);
    }

    DHG = DarkestHourGame(PC.Level.Game);

    if (DHG != none)
    {
        if (TeamIndex < arraycount(DHG.Teams))
        {
            // Add player back to the old team
            DHG.Teams[TeamIndex].AddToTeam(PC);
        }
    }
    else
    {
        Log("Failed to add to player to the team from the previous session: Game is none");
    }

    // Ensure a correct team score manager is linked
    PC.LinkTeamScoreManager();
}
