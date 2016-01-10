//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
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
};

enum ESpawnMode
{
    ESM_RedOrchestra,
    ESM_DarkestHour
};

enum EGameType
{
    EGT_Push,
    EGT_Attrition,
    EGT_SearchAndDestroy,
    EGT_Advance
};

enum EBattleType
{
    EBT_Infantry,
    EBT_MostlyInfantry,
    EBT_CombinedArms,
    EBT_MostlyTank,
    EBT_Tank
};

enum ELevelSize
{
    ELS_Small,
    ELS_Medium,
    ELS_Large,
    ELS_Huge
};

var() EGameType             GameType;
var() EBattleType           BattleType;
var() ELevelSize            LevelSize;

var() float                 PlayerRatioAlliesToAxis; //0.5 for 50% allies vs 50% axis

var() EAxisNation           AxisNation;
var() EAlliedNation         AlliedNation;

var() sound                 AlliesWinsMusic;
var() sound                 AxisWinsMusic;

var() ESpawnMode            SpawnMode;
var() InterpCurve           AttritionRateCurve; //Colin: Attrition rate defines the maximum rate of reinforcement drain when the enemy controls all objectives.

var() Material              LoadingScreenRef; //Used to stop loading screen image from being removed on save (not otherwise used)
                                              //Must be set to myLevel.GUI.LoadingScreen to work!

var const bool              bDHDebugMode; // flag for whether debug commands can be run

singular static function bool DHDebugMode()
{
    return default.bDHDebugMode;
}

defaultproperties
{
    bDHDebugMode=true

    PlayerRatioAlliesToAxis=0.5
    Texture=texture'DHEngine_Tex.LevelInfo'
    AlliesWinsMusic=sound'DH_win.Allies.DH_AlliesGroup'
    AxisWinsMusic=sound'DH_win.German.DH_GermanGroup'
    SpawnMode=ESM_RedOrchestra
}
