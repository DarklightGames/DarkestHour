//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2021
//==============================================================================

class DHMapMarker extends Object
    abstract;

// EScopeType replaces DHMapMarker.bIsSquadSpecific and DHMapMarker.bIsVisibleToTeam.
enum EScopeType
{
    PERSONAL,
    SQUAD,
    TEAM
};
var EScopeType          Scope;

// EOverwritingRule replaces DHMapMarker.bIsUnique and DHMapMarker.bShouldOverwriteGroup.
enum EOverwritingRule
{
    UNIQUE_PER_GROUP,                           // there will always be exactly one or zero markers that have the given GroupIndex
    UNIQUE,                                     // there will always be exactly one or zero such marker
    OFF                                        // this marker can be drawn in any number on the map
};
var EOverwritingRule    OverwritingRule;

enum ERolePermissions
{
    NO_ONE,
    ALL,
    SL,
    ASL,
    SL_OR_ASL,
    ARTILLERY_OPERATOR,
    ARTILLERY_SPOTTER,
    ADMIN,
    PATRON
};

enum ELevelSelector
{
    SQUAD,
    TEAM
};

struct SVisibilityPermissions
{
    var ERolePermissions RoleSelector;
    var ELevelSelector LevelSelector;
};

var array<ERolePermissions> Permissions_CanPlace;
var array<SVisibilityPermissions> Permissions_CanSee;
var array<SVisibilityPermissions> Permissions_CanRemove;

var localized string    MarkerName;
var Material            IconMaterial;
var IntBox              IconCoords;
var color               IconColor;
var int                 LifetimeSeconds;        // Lifetime, in seconds, of the marker, or -1 for infinite
var int                 GroupIndex;             // Used for grouping map markers (e.g. in the context menu when placing them).
var bool                bShouldShowOnCompass;   // Whether or not this marker is displayed on the compass
var bool                bShouldDrawBeeLine;     // If true, draw a line from the player to this marker on the situation map.
var int                 RequiredSquadMembers;

// Override this function to determine if this map marker can be used. This
// function is evaluated once at the beginning of the map.
static function bool CanBeUsed(DHGameReplicationInfo GRI)
{
    return true;
}

static function bool CheckRole(ERolePermissions RoleSelector, DHPlayerReplicationInfo PRI)
{
    if (PRI == none)
    {
        return false;
    }

    switch (RoleSelector)
    {
        case NO_ONE:
            return false;
        case ALL:
            return true;
        case SL:
            return PRI.IsSL();
        case ASL:
            return PRI.IsASL();
        case ARTILLERY_SPOTTER:
            return PRI.IsArtillerySpotter();
        case ARTILLERY_OPERATOR:
            return PRI.IsArtilleryOperator();
        case ADMIN:
            return PRI.IsAdmin();
        case PATRON:
            return PRI.IsPatron();
        default:
            return false;
    }
}

static function bool CheckPermissions(array<SVisibilityPermissions> Permissions, DHPlayerReplicationInfo PRI, DHGameReplicationInfo.MapMarker Marker)
{
    local DHPlayer PC;
    local bool bIsVisible;
    local int i;
    local int SquadIndex;

    bIsVisible = false;

    if (PRI == none)
    {
        return false;
    }

    for (i = 0; i < Permissions.Length; i++)
    {
        if (Permissions[i].LevelSelector == SQUAD && Marker.SquadIndex != PRI.SquadIndex)
        {
            continue;
        }

        bIsVisible = bIsVisible || CheckRole(Permissions[i].RoleSelector, PRI);
    }

    return bIsVisible;
}

// Override this function to determine if this map marker can be placed by
// the provided player.
static function bool CanPlaceMarker(DHPlayerReplicationInfo PRI)
{
    local DHPlayer PC;
    local int i;
    local bool bIsVisible;

    bIsVisible = false;

    PC = DHPlayer(PRI.Owner);

    if(default.Scope == SQUAD
      && (default.RequiredSquadMembers == 0 && PC.SquadReplicationInfo == none
        || PC.SquadReplicationInfo != none
          && PC.SquadReplicationInfo.GetMemberCount(PC.GetTeamNum(), PC.GetSquadIndex()) < default.RequiredSquadMembers))
    {
        return false;
    }

    for (i = 0; i < default.Permissions_CanPlace.Length; i++)
    {
        bIsVisible = bIsVisible || CheckRole(default.Permissions_CanPlace[i], PRI);
    }

    return bIsVisible;
}

// Override this function to determine if this map marker can be removed by
// the provided player.
static function bool CanRemoveMarker(DHPlayerReplicationInfo PRI, DHGameReplicationInfo.MapMarker Marker)
{
    return CheckPermissions(default.Permissions_CanRemove, PRI, Marker);
}

// Override this function to determine if this map marker can be displayed on the map by
// the provided player.
static function bool CanSeeMarker(DHPlayerReplicationInfo PRI, DHGameReplicationInfo.MapMarker Marker)
{
    return CheckPermissions(default.Permissions_CanSee, PRI, Marker);
}

static function color GetBeeLineColor()
{
    return default.IconColor;
}

static function color GetIconColor(DHPlayerReplicationInfo PRI, DHGameReplicationInfo.MapMarker Marker)
{
    return default.IconColor;
}

static function bool IsOnMapArtillery()
{
    return false;
}

// Override to run specific logic when this marker is placed.
static function OnMapMarkerPlaced(DHPlayer PC, DHGameReplicationInfo.MapMarker Marker);

// Override to run specific logic when this marker is removed.
static function OnMapMarkerRemoved(DHPlayer PC, DHGameReplicationInfo.MapMarker Marker);

// Override this to have a caption accompany the marker.
static function string GetCaptionString(DHPlayer PC, DHGameReplicationInfo.MapMarker Marker)
{
    return "";
}

defaultproperties
{
    IconCoords=(X1=0,Y1=0,X2=31,Y2=31)
    LifetimeSeconds=-1
    GroupIndex=-1
    Scope=TEAM
    OverwritingRule=OFF
    bShouldShowOnCompass=false
    RequiredSquadMembers=0
}
