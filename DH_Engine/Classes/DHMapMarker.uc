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

enum ELevelSelector
{
    SQUAD,
    TEAM
};

struct SVisibilityPermissions
{
    var DHGameReplicationInfo.ERoleSelector RoleSelector;
    var ELevelSelector LevelSelector;
};

var array<DHGameReplicationInfo.ERoleSelector> Permissions_CanPlace;
var array<SVisibilityPermissions> Permissions_CanSee;
var array<SVisibilityPermissions> Permissions_CanRemove;

struct SExternalNotification
{
    var DHGameReplicationInfo.ERoleSelector RoleSelector;
    var class<ROCriticalMessage> Message;
    var int               MessageIndex;
};

// which roles should be notified in OnMapMarkerPlace()
var array<SExternalNotification>  OnPlacedExternalNotifications;

// how the player should be notified in OnMapMarkerPlaced()
var class<ROCriticalMessage>  OnPlacedMessage;
var int                       OnPlacedMessageIndex;

var localized string    MarkerName;
var Material            IconMaterial;
var IntBox              IconCoords;
var color               IconColor;
var int                 LifetimeSeconds;        // Lifetime, in seconds, of the marker, or -1 for infinite
var int                 GroupIndex;             // Used for grouping map markers (e.g. in the context menu when placing them).
var bool                bShouldShowOnCompass;   // Whether or not this marker is displayed on the compass
var bool                bShouldDrawBeeLine;     // If true, draw a line from the player to this marker on the situation map.
var int                 RequiredSquadMembers;
var int                 Cooldown;

enum EMarkerType
{
    MT_Friendly,
    MT_Enemy,
    MT_OffMapArtilleryRequest,
    MT_OnMapArtilleryRequest,
    MT_ArtilleryHit,
    MT_ArtilleryBarrage,
    MT_Measurement,
    MT_Admin,
    MT_Movement
};

var EMarkerType Type;

// Override this function to determine if this map marker can be used. This
// function is evaluated once at the beginning of the map.
static function bool CanBeUsed(DHGameReplicationInfo GRI)
{
    return true;
}

static function bool CheckRole(DHGameReplicationInfo.ERoleSelector RoleSelector, DHPlayerReplicationInfo PRI)
{
    if (PRI == none)
    {
        return false;
    }

    switch (RoleSelector)
    {
        case ERS_ALL:
            return true;
        case ERS_SL:
            return PRI.IsSL();
        case ERS_ASL:
            return PRI.IsASL();
        case ERS_ARTILLERY_SPOTTER:
            return PRI.IsArtillerySpotter();
        case ERS_ARTILLERY_OPERATOR:
            return PRI.IsArtilleryOperator();
        case ERS_ADMIN:
            return PRI.IsAdmin();
        case ERS_PATRON:
            return PRI.IsPatron();
        default:
            return false;
    }
}

static function bool CheckPermissions(array<SVisibilityPermissions> Permissions, DHPlayerReplicationInfo PRI, DHGameReplicationInfo.MapMarker Marker)
{
    local int i;

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

        if (CheckRole(Permissions[i].RoleSelector, PRI))
        {
            return true;
        }
    }

    return false;
}

// Determine if this map marker can be placed by the provided player.
// Override it only if it is really necessary.
static function bool CanPlaceMarker(DHPlayerReplicationInfo PRI)
{
    local DHPlayer PC;
    local int i;
    local bool bIsVisible;

    if (PRI == none || PRI.Level == none)
    {
        return false;
    }

    PC = DHPlayer(PRI.Owner);

    if (PC == none)
    {
        return false;
    }

    if (default.Scope == SQUAD && (default.RequiredSquadMembers == 0 && PC.SquadReplicationInfo == none || PC.SquadReplicationInfo.GetMemberCount(PC.GetTeamNum(), PC.GetSquadIndex()) < default.RequiredSquadMembers))
    {
        return false;
    }

    bIsVisible = false;

    for (i = 0; i < default.Permissions_CanPlace.Length; i++)
    {
        bIsVisible = bIsVisible || CheckRole(default.Permissions_CanPlace[i], PRI);
    }

    return bIsVisible;
}

// Determine if this map marker can be removed by the provided player.
// Override it only if it is really necessary.
static function bool CanRemoveMarker(DHPlayerReplicationInfo PRI, DHGameReplicationInfo.MapMarker Marker)
{
    return CheckPermissions(default.Permissions_CanRemove, PRI, Marker);
}

// Determine if this map marker can be seen by the provided player.
// Override it only if it is really necessary.
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

// Override to run specific logic when this marker is placed.
// Override it only if it is really necessary.
static function OnMapMarkerPlaced(DHPlayer PC, DHGameReplicationInfo.MapMarker Marker)
{
    local int i;
    local DHGameReplicationInfo.ERoleSelector RoleSelector;
    local class<ROCriticalMessage> Message;
    local int MessageIndex;
    local string Text;
    local DHSquadReplicationInfo SRI;

    // Handle cooldown

    if(Marker.MapMarkerClass.default.Cooldown > 0)
    {
        PC.LockMapMarkerPlacing(Marker.MapMarkerClass);
    }

    // Broadcast notifications

    for (i = 0; i < default.OnPlacedExternalNotifications.Length; ++i)
    {
        RoleSelector = default.OnPlacedExternalNotifications[i].RoleSelector;
        Message = default.OnPlacedExternalNotifications[i].Message;
        MessageIndex = default.OnPlacedExternalNotifications[i].MessageIndex;
        PC.ServerNotifyRoles(RoleSelector, Message, MessageIndex, Marker.MapMarkerClass);
    }

    // Notify the player

    if(Marker.MapMarkerClass.default.OnPlacedMessage != none)
    {
        PC.ReceiveLocalizedMessage(Marker.MapMarkerClass.default.OnPlacedMessage, Marker.MapMarkerClass.default.OnPlacedMessageIndex,,, Marker.MapMarkerClass);
    }
}

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
