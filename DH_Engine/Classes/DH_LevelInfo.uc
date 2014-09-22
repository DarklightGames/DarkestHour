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

struct VehiclePool
{
    var() class<Vehicle> VehicleClass;
    var() float          RespawnTime;
    var() byte           MaxSpawns; //value to determine the overall number of vehicles we can spawn
    var() byte           MaxActive; //value to determine how many active at once
};

var() EAxisNation AxisNation;
var() EAlliedNation AlliedNation;

var() byte SmokeBrightnessOverride; //Used to override the lighting brightness of smoke emitters
var() rangevector WindDirectionSpeed; //Used to make smoke grenades match other emitters in the level

var() sound AlliesWinsMusic; //Optional override for Allies victory music
var() sound AxisWinsMusic; //Optional override for Axis victory music

//Organize
var() array<VehiclePool> VehiclePools;
var() byte MaxTeamVehicles[2];
var() byte MaxDestroyedVehicles;

//=============================================================================
// defaultproperties
//=============================================================================

defaultproperties
{
    SmokeBrightnessOverride=255
    AlliesWinsMusic=Sound'DH_win.Allies.DH_AlliesGroup'
    AxisWinsMusic=Sound'DH_win.German.DH_GermanGroup'
    MaxTeamVehicles(0)=32
    MaxTeamVehicles(1)=32
    MaxDestroyedVehicles=8
}


