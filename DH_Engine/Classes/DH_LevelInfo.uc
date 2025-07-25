//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_LevelInfo extends ROLevelInfo
    placeable;

enum EAxisNation
{
    NATION_Germany,
    NATION_Italy,
};

enum EAlliedNation
{
    NATION_USA,
    NATION_Britain,
    NATION_Canada,
    NATION_USSR,
    NATION_Poland,
    NATION_Czechoslovakia,
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
var(DH_Atmosphere) ESeason          Season;
var(DH_Atmosphere) EWeather         Weather;

var(DH_Nation) EAxisNation          AxisNation;
var private class<DHNation>         AxisNationClass;
var(DH_Nation) EAlliedNation        AlliedNation;
var private class<DHNation>         AlliedNationClass;
var(DH_Nation) sound                AxisWinsMusic;                  // Optional override for Axis victory music
var(DH_Nation) sound                AlliesWinsMusic;                // Optional override for Allies victory music

var(DH_Munitions) float             BaseMunitionPercentages[2];     // The starting munition percentage for each team

var(DH_GameSettings) float                          AlliesToAxisRatio;              // Player ratio based on team, allows for unbalanced teams
var(DH_GameSettings) bool                           bHardTeamRatio;                 // Determines if AlliesToAxisRatio should be hard or soft (affected by # of players)
var(DH_GameSettings) class<DHGameType>              GameTypeClass;
var(DH_GameSettings) ESpawnMode                     SpawnMode;

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

var() Material              LoadingScreenRef;        // Used to stop loading screen image from being removed on save (not otherwise used)
                                                     // Must be set to myLevel.GUI.LoadingScreen to work!

var const bool              bDHDebugMode;            // flag for whether debug commands can be run

struct SConstruction
{
    var() byte TeamIndex;
    var() class<DHConstruction> ConstructionClass;  // Construction class.
    var() int Limit; // The total limit alotted per round. -1 means no limit.
    var() int MaxActive; // The maximum amount active at a time. -1 means no limit.
};

// Leveler-defined constructions.
var(DH_Constructions) array<class<DHConstruction> > RestrictedConstructions;
// When set, use this construction loadout for the team. Otherwise, use the nation's default loadout.
var(DH_Constructions) array<class<DHConstructionLoadout> > TeamConstructionLoadoutClasses[2];
var(DH_Constructions) protected array<SConstruction> Constructions;

// Evaluated construction loadouts.
// The list is populated by the nation's default loadout classes and any level-specific overrides.
// The construction list in the GRI maps to this list by index.
var array<SConstruction> ConstructionsEvaluated;

singular static function bool DHDebugMode()
{
    return default.bDHDebugMode;
}

simulated function PostBeginPlay()
{
    super.PostBeginPlay();

    EvaluateConstructions();
}

// This is a backwards compatibility method.
// Ideally, we would go through all of our maps and explicitly
// set a nation class variable in the properties of the level info, but
// this is a huge amount of work and would also break back compatiblity
// with old maps.
simulated function string GetTeamNationClassName(int TeamIndex)
{
    switch (TeamIndex)
    {
        case AXIS_TEAM_INDEX:
            switch (AxisNation)
            {
                case NATION_Germany:
                    return "DH_GerPlayers.DHNation_Germany";
                case NATION_Italy:
                    return "DH_ItalyPlayers.DHNation_Italy";
                default:
                    break;
            }
            break;
        case ALLIES_TEAM_INDEX:
            switch (AlliedNation)
            {
                case NATION_Britain:
                    return "DH_BritishPlayers.DHNation_Britain";
                case NATION_Canada:
                    return "DH_BritishPlayers.DHNation_Canada";
                case NATION_Czechoslovakia:
                    return "DH_SovietPlayers.DHNation_Czechoslovakia";
                case NATION_Poland:
                    return "DH_SovietPlayers.DHNation_Poland";
                case NATION_USA:
                    return "DH_USPlayers.DHNation_USA";
                case NATION_USSR:
                    return "DH_SovietPlayers.DHNation_USSR";
                default:
                    break;
            }
            break;
    }

    return "";
}

simulated function class<DHNation> GetTeamNationClass(int TeamIndex)
{
    // We want to be calling this pretty frequently, and I don't trust DynamicLoadObject to be fast enough.
    // Therefore, we store the result in private variables and just serve those up if they have already
    // been calculated.
    switch (TeamIndex)
    {
        case AXIS_TEAM_INDEX:
            if (AxisNationClass == none)
            {
                AxisNationClass = class<DHNation>(DynamicLoadObject(GetTeamNationClassName(AXIS_TEAM_INDEX), Class'Class'));
            }
            return AxisNationClass;
        case ALLIES_TEAM_INDEX:
            if (AlliedNationClass == none)
            {
                AlliedNationClass = class<DHNation>(DynamicLoadObject(GetTeamNationClassName(ALLIES_TEAM_INDEX), Class'Class'));
            }
            return AlliedNationClass;
    }

    return none;
}

simulated function bool IsConstructionUnlimited(int TeamIndex, class<DHConstruction> ConstructionClass)
{
    local int ConstructionIndex;

    ConstructionIndex = GetConstructionIndex(TeamIndex, ConstructionClass);

    if (ConstructionIndex != -1)
    {
        return ConstructionsEvaluated[ConstructionIndex].Limit == -1;
    }

    return false;
}

simulated function int GetConstructionIndex(int TeamIndex, class<DHConstruction> ConstructionClass)
{
    local int i;

    for (i = 0; i < ConstructionsEvaluated.Length; ++i)
    {
        if (ConstructionsEvaluated[i].TeamIndex == TeamIndex &&
            ConstructionsEvaluated[i].ConstructionClass == ConstructionClass)
        {
            return i;
        }
    }

    return -1;
}

simulated function bool IsConstructionRestricted(class<DHConstruction> ConstructionClass)
{
    local int i;

    for (i = 0; i < RestrictedConstructions.Length; ++i)
    {
        if (ClassIsChildOf(ConstructionClass, RestrictedConstructions[i]))
        {
            return true;
        }
    }

    return false;
}

// Returns the maximum active limit for a team's construction class.
// If the value is -1, there is no limit to the number of active constructions.
simulated function int GetConstructionMaxActive(int TeamIndex, class<DHConstruction> ConstructionClass)
{
    local int ConstructionIndex;

    ConstructionIndex = GetConstructionIndex(TeamIndex, ConstructionClass);

    if (ConstructionIndex != -1)
    {
        return ConstructionsEvaluated[ConstructionIndex].MaxActive;
    }

    return -1;
}

// This function evaluates the level's construction classes and populates the ConstructionsEvaluated list.
simulated function EvaluateConstructions()
{
    local int i, TeamIndex, ConstructionIndex;
    local class<DHNation> NationClass;
    local class<DHConstructionLoadout> LoadoutClass;
    local SConstruction Construction;

    // Clear the evaluated constructions.
    ConstructionsEvaluated.Length = 0;

    // Add the nation's default construction classes.
    for (TeamIndex = 0; TeamIndex < 2; ++TeamIndex)
    {
        if (TeamConstructionLoadoutClasses[TeamIndex] != none)
        {
            // Use the level's construction loadout for this team.
            LoadoutClass = TeamConstructionLoadoutClasses[TeamIndex];
        }
        else
        {
            // No level-specific construction loadout, use the nation's default.
            NationClass = GetTeamNationClass(TeamIndex);

            if (NationClass == none)
            {
                Warn("Failed to get nation class for team index " $ TeamIndex);
                continue;
            }

            LoadoutClass = NationClass.default.DefaultConstructionLoadoutClass;
        }

        if (LoadoutClass == none)
        {
            Warn("Failed to get default construction loadout class for nation " $ NationClass);
            continue;
        }

        for (i = 0; i < LoadoutClass.default.Constructions.Length; ++i)
        {
            Construction.TeamIndex = TeamIndex;
            Construction.ConstructionClass = LoadoutClass.default.Constructions[i].ConstructionClass;
            Construction.Limit = LoadoutClass.default.Constructions[i].Limit;
            Construction.MaxActive = LoadoutClass.default.Constructions[i].MaxActive;

            ConstructionsEvaluated[ConstructionsEvaluated.Length] = Construction;
        }
    }

    // Now add or override any construction classes with the level's list.
    for (i = 0; i < Constructions.Length; ++i)
    {
        Construction = Constructions[i];
        ConstructionIndex = GetConstructionIndex(Construction.TeamIndex, Construction.ConstructionClass);

        if (ConstructionIndex == -1)
        {
            // Add the construction, it doesn't yet exist.
            ConstructionsEvaluated[ConstructionsEvaluated.Length] = Construction;
        }
        else
        {
            // Update the construction, it already exists.
            ConstructionsEvaluated[ConstructionIndex] = Construction;
        }
    }
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
        foreach Level.AllActors(Class'DH_LevelInfo', LI)
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
    AlliesWinsMusic=Sound'DH_win.DH_AlliesGroup'
    AxisWinsMusic=Sound'DH_win.DH_GermanGroup'
    SpawnMode=ESM_RedOrchestra
    Season=SEASON_Summer
    GameTypeClass=Class'DHGameType_Push'
    InfantrySpawnVehicleDuration=60

    // TODO: delay, limit and request interval need to be gotten from elsewhere?
    ArtilleryTypes(0)=(TeamIndex=0,ArtilleryClass=Class'DHArtillery_Legacy',bIsInitiallyActive=true,Limit=1,ConfirmIntervalSeconds=0)
    ArtilleryTypes(1)=(TeamIndex=1,ArtilleryClass=Class'DHArtillery_Legacy',bIsInitiallyActive=true,Limit=1,ConfirmIntervalSeconds=0)

    BaseMunitionPercentages(0)=60.0
    BaseMunitionPercentages(1)=60.0

    bIsDangerZoneInitiallyEnabled=true
    DangerZoneNeutral=128

    ObjectiveSpawnDistanceThreshold=125.0
    ObjectiveSpawnMinimumDepth=-1

    ZombieHealthMultiplier=1.0
}
