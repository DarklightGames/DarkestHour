//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_LevelInfo extends ROLevelInfo
    placeable;

//=============================================================================
// Variables
//=============================================================================

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

//=============================================================================
// defaultproperties
//=============================================================================

defaultproperties
{
    Texture=Texture'DHEngine_Tex.LevelInfo'
    SmokeBrightnessOverride=255
    AlliesWinsMusic=Sound'DH_win.Allies.DH_AlliesGroup'
    AxisWinsMusic=Sound'DH_win.German.DH_GermanGroup'
    SpawnMode=ESM_RedOrchestra
}

