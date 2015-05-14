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

var() EAxisNation AxisNation;
var() EAlliedNation AlliedNation;

//These variables need removed
var() byte SmokeBrightnessOverride; //Used to override the lighting brightness of smoke emitters
var() rangevector WindDirectionSpeed; //Used to make smoke grenades match other emitters in the level

var() sound AlliesWinsMusic; //Optional override for Allies victory music
var() sound AxisWinsMusic; //Optional override for Axis victory music

var() ESpawnMode SpawnMode;

var() Material LoadingScreenRef; // Used to stop loading screen image from being removed on save (not otherwise used)
                                 // Must be set to myLevel.GUI.LoadingScreen to work!

var const bool bDHDebugMode; // flag for whether debug commands can be run

singular static function bool DHDebugMode()
{
    return default.bDHDebugMode;
}

defaultproperties
{
    Texture=texture'DHEngine_Tex.LevelInfo'
    SmokeBrightnessOverride=255
    AlliesWinsMusic=sound'DH_win.Allies.DH_AlliesGroup'
    AxisWinsMusic=sound'DH_win.German.DH_GermanGroup'
    SpawnMode=ESM_RedOrchestra
    bDHDebugMode=true // Matt: TEMP during development to aid testing - remove before release !
}
