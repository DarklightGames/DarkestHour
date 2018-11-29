//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2018
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

struct ArtilleryType
{
    var() int                   TeamIndex;
    var() class<DHArtillery>    ArtilleryClass;             // The artillery class to use.
    var() bool                  bIsInitiallyActive;         // Whether or not this type of artillery is initially available (can be made available and unavailable during a round).
    var() int                   DelaySeconds;               // The amount of seconds it will take until the artillery actor is spawned.
    var() int                   Limit;                      // The amount of these types of artillery strikes that are available.
    var() int                   ConfirmIntervalSeconds;     // The amount of seconds it will take until another request can be confirmed.
};
var(Artillery) array<ArtilleryType> ArtilleryTypes;

// These are used as hints for skinning dynamically placed objects.
var() ESeason               Season;
var() EWeather              Weather;

var() float                 AlliesToAxisRatio;              // Player ratio based on team, allows for unbalanced teams
var() bool                  bHardTeamRatio;                 // Determines if AlliesToAxisRatio should be hard or soft (affected by # of players)
var() bool                  bReinforcementsScalesMunitions; // Setting this to true, will lower munition percentage based on reinforcement percentage TODO: Implement

var() float                 BaseMunitionPercentages[2];     // The starting munition percentage for each team
var() float                 MunitionLossPerMinute[2];       // The rate at which munition drains (if game type is setup to drain munitions)
var() EAxisNation           AxisNation;
var() sound                 AxisWinsMusic;                  // Optional override for Axis victory music

var() EAlliedNation         AlliedNation;
var() sound                 AlliesWinsMusic;                // Optional override for Allies victory music

var() class<DHGameType>     GameTypeClass;
var() ESpawnMode            SpawnMode;

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

var() int                   InfantrySpawnVehicleDuration;

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

function bool IsArtilleryInitiallyAvailable(int ArtilleryTypeIndex)
{
    if (ArtilleryTypeIndex < 0 ||
        ArtilleryTypeIndex >= ArtilleryTypes.Length ||
        ArtilleryTypes[ArtilleryTypeIndex].ArtilleryClass == none)
    {
        return false;
    }

    return ArtilleryTypes[ArtilleryTypeIndex].bIsInitiallyActive;
}

function int GetArtilleryLimit(int ArtilleryTypeIndex)
{
    local int Limit;

    if (ArtilleryTypeIndex < 0 ||
        ArtilleryTypeIndex >= ArtilleryTypes.Length ||
        ArtilleryTypes[ArtilleryTypeIndex].ArtilleryClass == none)
    {
        return 0;
    }

    Limit = ArtilleryTypes[ArtilleryTypeIndex].ArtilleryClass.static.GetLimitOverride(ArtilleryTypes[ArtilleryTypeIndex].TeamIndex, Level);

    if (Limit == -1)
    {
        Limit = ArtilleryTypes[ArtilleryTypeIndex].Limit;
    }

    return Limit;
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
    bDHDebugMode=false // TEMPDEBUG - revert to false before any release

    AlliesToAxisRatio=0.5
    Texture=Texture'DHEngine_Tex.LevelInfo'
    AlliesWinsMusic=Sound'DH_win.Allies.DH_AlliesGroup'
    AxisWinsMusic=Sound'DH_win.German.DH_GermanGroup'
    SpawnMode=ESM_RedOrchestra
    Season=SEASON_Summer
    GameTypeClass=class'DHGameType_Push'
    InfantrySpawnVehicleDuration=60

    // TODO: delay, limit and request interval need to be gotten from elsewhere?
    ArtilleryTypes(0)=(TeamIndex=0,ArtilleryClass=class'DHArtillery_Legacy',bIsInitiallyActive=true,Limit=1,ConfirmIntervalSeconds=0)
    ArtilleryTypes(1)=(TeamIndex=1,ArtilleryClass=class'DHArtillery_Legacy',bIsInitiallyActive=true,Limit=1,ConfirmIntervalSeconds=0)

    BaseMunitionPercentages(0)=60.0
    BaseMunitionPercentages(1)=60.0

    MunitionLossPerMinute(0)=1.0
    MunitionLossPerMinute(1)=1.0
}

