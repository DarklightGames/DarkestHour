//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2022
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

// Used when evaluating permissions to place/remove/see the marker.
// LevelSelector determines who should see it: team/squad/the player themself.
// RoleSelector determines roles which should see the marker.
struct SVisibilityPermissions
{
    var DHPlayerReplicationInfo.ERoleSelector RoleSelector;
    var EScopeType                            LevelSelector;
};

var array<DHPlayerReplicationInfo.ERoleSelector> Permissions_CanPlace;
var array<SVisibilityPermissions> Permissions_CanSee;
var array<SVisibilityPermissions> Permissions_CanRemove;

struct SExternalNotification
{
    var DHPlayerReplicationInfo.ERoleSelector RoleSelector;
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
var int                 Cooldown;               // [s] reenabling interval between adding two consequent markers
var int                 ActivationTimeout;      // [s] how long it takes after placing for this marker to become activated

var     string          CalculatingString;

enum EMarkerType
{
    MT_Friendly,
    MT_Enemy,
    MT_OffMapArtilleryRequest,
    MT_OnMapArtilleryRequest,
    MT_ArtilleryHit,
    MT_ArtilleryBarrage,
    MT_Measurement,
    MT_Movement
};

var EMarkerType Type;

// The console command to run when this marker is placed as a result of using the spotting menu. Used for playing voice call-outs.
var string SpottingConsoleCommand;

// Override this function to determine if this map marker can be used. This
// function is evaluated once at the beginning of the map.
static function bool CanBeUsed(DHGameReplicationInfo GRI)
{
    return true;
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

        if (PRI.CheckRole(Permissions[i].RoleSelector))
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
    local bool bIsPlaceable;

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

    bIsPlaceable = false;

    for (i = 0; i < default.Permissions_CanPlace.Length; i++)
    {
        bIsPlaceable = bIsPlaceable || PRI.CheckRole(default.Permissions_CanPlace[i]);
    }

    return bIsPlaceable;
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

static function color GetIconColor(DHPlayer PC, DHGameReplicationInfo.MapMarker Marker)
{
    return default.IconColor;
}

static function bool IsMarkerActive(DHPlayer PC, DHGameReplicationInfo.MapMarker Marker)
{
    local DHGameReplicationInfo GRI;

    if (PC == none)
    {
        return false;
    }

    GRI = DHGameReplicationInfo(PC.GameReplicationInfo);

    return GRI != none && GRI.ElapsedTime >= Marker.CreationTime + default.ActivationTimeout;
}

// Override to run specific logic when this marker is placed.
// Override it only if it is really necessary.
static function OnMapMarkerPlaced(DHPlayer PC, DHGameReplicationInfo.MapMarker Marker)
{
    local int i;
    local DHPlayerReplicationInfo.ERoleSelector RoleSelector;
    local class<ROCriticalMessage> Message;
    local int MessageIndex;

    // Handle cooldown
    if (Marker.MapMarkerClass.default.Cooldown > 0)
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
    if (Marker.MapMarkerClass.default.OnPlacedMessage != none)
    {
        PC.ReceiveLocalizedMessage(
            Marker.MapMarkerClass.default.OnPlacedMessage,
            Marker.MapMarkerClass.default.OnPlacedMessageIndex,,,
            Marker.MapMarkerClass
            );
    }
}

// Override to run specific logic when this marker is removed.
static function OnMapMarkerRemoved(DHPlayer PC, DHGameReplicationInfo.MapMarker Marker);

// Override this to have a caption accompany the marker.
static function string GetCaptionString(DHPlayer PC, DHGameReplicationInfo.MapMarker Marker)
{
    return "";
}

static function string GetDistanceString(DHPlayer PC, DHGameReplicationInfo.MapMarker Marker)
{
    local int Distance;
    local vector V;

    if (PC == none || PC.Pawn == none)
    {
        return "";
    }

    if (Marker.MapMarkerClass != none && !Marker.MapMarkerClass.static.IsMarkerActive(PC, Marker))
    {
        return default.CalculatingString;
    }

    V = PC.Pawn.Location - Marker.WorldLocation;
    V.Z = 0.0;

    Distance = class'DHUnits'.static.UnrealToMeters(VSize(V));

    return (Distance / 5) * 5 $ "m";
}

defaultproperties
{
    IconCoords=(X1=0,Y1=0,X2=31,Y2=31)
    LifetimeSeconds=-1
    GroupIndex=-1
    Scope=TEAM
    OverwritingRule=OFF
    bShouldShowOnCompass=false
    CalculatingString="Calculating..."
}
