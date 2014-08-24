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

//=============================================================================
// defaultproperties
//=============================================================================

defaultproperties
{
}
