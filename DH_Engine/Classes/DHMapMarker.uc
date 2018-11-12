//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2018
//==============================================================================

class DHMapMarker extends Object
    abstract;

var localized string    MarkerName;
var Material            IconMaterial;
var IntBox              IconCoords;
var color               IconColor;
var bool                bShouldShowOnCompass;   // Whether or not this marker is displayed on the compass
var bool                bIsSquadSpecific;       // If true, when this marker is placed, it will only be visible to squad members
var int                 LifetimeSeconds;        // Lifetime, in seconds, of the marker, or -1 for infinite
var int                 GroupIndex;             // Used for grouping map markers (e.g. in the context menu when placing them).
var bool                bShouldOverwriteGroup;  // If true, adding this map marker will overwrite any existing markers that are in the same group.
var bool                bIsUnique;              // If true, only one of this type may be active for the team or squad (if squad specific)
var bool                bShouldDrawBeeLine;     // If true, draw a line from the player to this marker on the situation map.

// Override this function to determine if this map marker can be used. This
// function evaluated once at the beginning of the map.
static function bool CanBeUsed(DHGameReplicationInfo GRI)
{
    return true;
}

// Override this function to determine if this map marker can be placed by
// the provided player.
static function bool CanPlayerUse(DHPlayerReplicationInfo PRI)
{
    return false;
}

static function color GetBeeLineColor()
{
    return default.IconColor;
}

// Override to run specific logic when this marker is placed.
static function OnMapMarkerPlaced(DHPlayer PC);

defaultproperties
{
    IconCoords=(X1=0,Y1=0,X2=31,Y2=31)
    LifetimeSeconds=-1
    GroupIndex=-1
}

