//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
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

var() EAxisNation AxisNation;
var() EAlliedNation AlliedNation;

var() sound AlliesWinsMusic;            //Optional override for Allies victory music
var() sound AxisWinsMusic;              //Optional override for Axis victory music

var() ESpawnMode SpawnMode;
var() InterpCurve   AttritionRateCurve; //Colin: Attrition rate defines the maximum rate of reinforcement drain when the enemy controls all objectives.

var() Material LoadingScreenRef;        //Used to stop loading screen image from being removed on save (not otherwise used)
                                        //Must be set to myLevel.GUI.LoadingScreen to work!

var const bool bDHDebugMode;            // flag for whether debug commands can be run

singular static function bool DHDebugMode()
{
    return default.bDHDebugMode;
}

defaultproperties
{
    bDHDebugMode=true // TEMP - remove before any release !
    Texture=texture'DHEngine_Tex.LevelInfo'
    AlliesWinsMusic=sound'DH_win.Allies.DH_AlliesGroup'
    AxisWinsMusic=sound'DH_win.German.DH_GermanGroup'
    SpawnMode=ESM_RedOrchestra
}
