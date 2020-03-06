//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2018
//==============================================================================

class DHArtilleryMarker extends Object abstract;

var DHPlayer        Controller; // the guy who fired the projectile / the guy who requested barrage
var float           Time;
var float           LocationX;
var float           LocationY;

var localized string    MarkerName;
var Material            IconMaterial;
var IntBox              IconCoords;
var color               IconColor;
var bool                bShouldShowOnCompass;   // Whether or not this marker is displayed on the compass
var bool                bIsSquadSpecific;       // If true, when this marker is placed, it will only be visible to squad members
var int                 LifetimeSeconds;        // Lifetime, in seconds, of the marker, or -1 for infinite

static function bool CanPlayerUse(DHPlayerReplicationInfo PRI)
{
    return true;
}

defaultproperties
{
    MarkerName="Artillery hit"
    IconMaterial=Texture'DH_InterfaceArt2_tex.Icons.Attack'
    IconColor=(R=204,G=255,B=0,A=255)
    IconCoords=(X1=0,Y1=0,X2=31,Y2=31)
    LifetimeSeconds=180 // 3 minutes
    Time = -1.0;
}
