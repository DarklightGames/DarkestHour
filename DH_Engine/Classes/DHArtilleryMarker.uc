//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2018
//==============================================================================

class DHArtilleryMarker extends Object abstract;

var DHPlayer            Controller;         // the guy who fired the projectile / the guy who requested barrage
var float               Time;
var float               LocationX;
var float               LocationY;
var string              Type;               // HE, Smoke, etc.

var localized string    MarkerName;
var Material            IconMaterial;
var IntBox              IconCoords;
var color               IconColor;
var int                 LifetimeSeconds;    // Lifetime, in seconds, of the marker, or -1 for infinite
var int                 ExpiryTime;         // time created + LiftimeSeconds
var float               MaximumDistance;    // 

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
    LifetimeSeconds=10
    Time = -1.0;
    MaximumDistance = 3000.0;
}
