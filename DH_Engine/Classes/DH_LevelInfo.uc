//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2017
//==============================================================================

class DH_LevelInfo extends ROLevelInfo
    placeable;

enum EAxisNation
{
    NATION_Germany,
};

enum EAlliedNation
{
    NATION_USA,
    NATION_Britain,
    NATION_Canada,
    NATION_USSR
};

enum ESpawnMode
{
    ESM_RedOrchestra,
    ESM_DarkestHour
};

enum EGameType
{
    GT_Push,
    GT_Attrition,
    GT_Advance,
    GT_Cutoff
};

enum ESeason
{
    SEASON_Spring,
    SEASON_Summer,
    SEASON_Autumn,
    SEASON_Winter
};

enum EWeather
{
    WEATHER_Clear,
    WEATHER_Rainy,
    WEATHER_Snowy
};

// These are used as hints for skinning dynamically placed objects.
var() ESeason               Season;
var() EWeather              Weather;

var() float                 AlliesToAxisRatio;          // Player ratio based on team, allows for unbalanced teams
var() bool                  bHardTeamRatio;             // Determines if AlliesToAxisRatio should be hard or soft (affected by # of players)
var() bool                  bSwapTeamsOnRoundEnd;        // Will swap teams & team score if the round ends

var() EAxisNation           AxisNation;
var() sound                 AxisWinsMusic;              // Optional override for Axis victory music
var() EAlliedNation         AlliedNation;
var() sound                 AlliesWinsMusic;            // Optional override for Allies victory music

var() EGameType             GameType;
var() ESpawnMode            SpawnMode;

var() bool                          bAreRallyPointsEnabled;
var() bool                          bAreConstructionsEnabled;
var() array<class<DHConstruction> > RestrictedConstructions;

// Colin: Defines the rate of reinforcement drain per minute
// when the enemy controls more objectives.
// For example, an in value of 1.0 should return the reinforcement
// drain per minute when one team controls all of the objectives.
// An in value of 0.5 should return the reinforcement drain per minute
// when the enemy holds 50% more of the objectives. (eg. Team A has 2
// objectives, while Team B has 4.)
var() InterpCurve           AttritionRateCurve;

var() bool                  bDisableTankLocking;     // option to disallow players from locking tanks & other armored vehicles, stopping other players from entering

var() material              LoadingScreenRef;        // Used to stop loading screen image from being removed on save (not otherwise used)
                                                     // Must be set to myLevel.GUI.LoadingScreen to work!

var const bool              bDHDebugMode;            // flag for whether debug commands can be run

singular static function bool DHDebugMode()
{
    return default.bDHDebugMode;
}

simulated function bool IsConstructionRestricted(class<DHConstruction> ConstructionClass)
{
    local int i;

    for (i = 0; i < RestrictedConstructions.Length; ++i)
    {
        if (ConstructionClass == RestrictedConstructions[i])
        {
            return true;
        }
    }

    return false;
}

static simulated function DH_LevelInfo GetInstance(LevelInfo Level)
{
    local DarkestHourGame G;
    local DHPlayer PC;
    local DH_LevelInfo LI;

    if (Level.Role == ROLE_Authority)
    {
        G = DarkestHourGame(Level.Game);

        if (G != none)
        {
            LI = G.DHLevelInfo;
        }
    }
    else
    {
        PC = DHPlayer(Level.GetLocalPlayerController());

        if (PC != none)
        {
            LI = PC.ClientLevelInfo;
        }
    }

    if (LI == none)
    {
        foreach Level.AllActors(class'DH_LevelInfo', LI)
        {
            break;
        }
    }

    return LI;
}

defaultproperties
{
    bDHDebugMode=true // TEMPDEBUG - revert to false before any release

    AlliesToAxisRatio=0.5
    Texture=texture'DHEngine_Tex.LevelInfo'
    AlliesWinsMusic=sound'DH_win.Allies.DH_AlliesGroup'
    AxisWinsMusic=sound'DH_win.German.DH_GermanGroup'
    SpawnMode=ESM_RedOrchestra
    Season=SEASON_Summer
}
