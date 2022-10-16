//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2022
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
    NATION_USSR,
    NATION_Poland,
    NATION_Czechoslovakia
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

struct SNationString
{
    var string Germany, USA, Britain, Canada, USSR, Poland;
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
var(DH_Atmosphere) ESeason          Season;
var(DH_Atmosphere) EWeather         Weather;

var(DH_Nation) EAxisNation          AxisNation;
var(DH_Nation) EAlliedNation        AlliedNation;
var(DH_Nation) sound                AxisWinsMusic;                  // Optional override for Axis victory music
var(DH_Nation) sound                AlliesWinsMusic;                // Optional override for Allies victory music

var(DH_Munitions) float             BaseMunitionPercentages[2];     // The starting munition percentage for each team

var(DH_GameSettings) float                          AlliesToAxisRatio;              // Player ratio based on team, allows for unbalanced teams
var(DH_GameSettings) bool                           bHardTeamRatio;                 // Determines if AlliesToAxisRatio should be hard or soft (affected by # of players)
var(DH_GameSettings) class<DHGameType>              GameTypeClass;
var(DH_GameSettings) ESpawnMode                     SpawnMode;

var(DH_GameSettings) array<class<DHConstruction> >  RestrictedConstructions;
var(DH_GameSettings) int                            InfantrySpawnVehicleDuration;
var(DH_GameSettings) InterpCurve                    AttritionRateCurve;

var(DH_GameSettings) bool                           bIsDangerZoneInitiallyEnabled;
var(DH_GameSettings) byte                           DangerZoneNeutral;                  // Affects the size of the neutral area
var(DH_GameSettings) int                            DangerZoneBalance;                  // Shifts the balance between Axis and Allied zones (range: -127..127)
var(DH_GameSettings) float                          DangerZoneIntensityScale;           // DEPRECATED

var(DH_GameSettings) float                          ObjectiveSpawnDistanceThreshold;    // Distance away an objective must be to be considered for an active Obj Spawn
var(DH_GameSettings) int                            ObjectiveSpawnMinimumDepth;         // Override of gametype's minimum depth for calculating the closest valid Obj Spawn
var(DH_SpecialEvents) float                         ZombieHealthMultiplier;

// Colin: AttritionRateCurve defines the rate of reinforcement drain per minute
// when the enemy controls more objectives.
// For example, an in value of 1.0 should return the reinforcement
// drain per minute when one team controls all of the objectives.
// An in value of 0.5 should return the reinforcement drain per minute
// when the enemy holds 50% more of the objectives. (eg. Team A has 2
// objectives, while Team B has 4.)

var() material              LoadingScreenRef;        // Used to stop loading screen image from being removed on save (not otherwise used)
                                                     // Must be set to myLevel.GUI.LoadingScreen to work!

var const bool              bDHDebugMode;            // flag for whether debug commands can be run

struct STeamConstruction
{
    var() class<DHConstruction> ConstructionClass;
    var() int TeamIndex;
    var() int Limit;
    var() int ReplenishPeriodSeconds;   // How long it takes, in seconds, for the limit to be increased by one
};
var(DH_Constructions) array<STeamConstruction> TeamConstructions;

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

simulated function class<DHArtillery> GetArtilleryClass(int ArtilleryTypeIndex)
{
    if (ArtilleryTypeIndex >= 0 && ArtilleryTypeIndex < ArtilleryTypes.Length)
    {
        return ArtilleryTypes[ArtilleryTypeIndex].ArtilleryClass;
    }
}

simulated static function DH_LevelInfo GetInstance(LevelInfo Level)
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

    bIsDangerZoneInitiallyEnabled=true
    DangerZoneNeutral=128

    ObjectiveSpawnDistanceThreshold=125.0
    ObjectiveSpawnMinimumDepth=-1

    ZombieHealthMultiplier=1.0
}
