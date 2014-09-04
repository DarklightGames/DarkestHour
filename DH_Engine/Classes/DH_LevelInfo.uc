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

var() EAxisNation AxisNation;
var() EAlliedNation AlliedNation;

var() byte SmokeBrightnessOverride; //Used to override the lighting brightness of smoke emitters
var() rangevector WindDirectionSpeed; //Used to make smoke grenades match other emitters in the level

//=============================================================================
// defaultproperties
//=============================================================================

defaultproperties
{
    SmokeBrightnessOverride=255
}
