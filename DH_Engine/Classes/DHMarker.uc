//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2019
//==============================================================================

class DHMarker extends Object
    abstract;

var localized string    MarkerName;
var Material            IconMaterial;
var IntBox              IconCoords;
var color               IconColor;
var int                 LifetimeSeconds;        // Lifetime, in seconds, of the marker, or -1 for infinite
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

// Override these 2 functions to determine how the marker should be handled when
// added/removed.
static function AddMarker(DHPlayer PC, float MapLocationX, float MapLocationY)
{
}

static function RemoveMarker(DHPlayer PC, optional int Index)
{
}

// Override this to have a caption accompany the marker.
static function string GetCaptionString(DHPlayer PC, vector WorldLocation)
{
    return "";
}

defaultproperties
{
    IconCoords=(X1=0,Y1=0,X2=31,Y2=31)
    LifetimeSeconds=-1
    bShouldDrawBeeLine=false
}
