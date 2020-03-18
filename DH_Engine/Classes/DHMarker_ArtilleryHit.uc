//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2018
//==============================================================================

class DHMarker_ArtilleryHit extends DHMarker_Artillery abstract;

var int             ClosestFireRequestIndex; // this can be used for quickly finding nearest fire requests later on
var float           MaximumDistance;    // 

static function bool CanPlayerUse(DHPlayerReplicationInfo PRI)
{
    return true;
}

defaultproperties
{
    MarkerName="Generic artillery hit"
    IconMaterial=Texture'DH_InterfaceArt2_tex.Icons.Attack'
    IconColor=(R=204,G=255,B=0,A=255)
    IconCoords=(X1=0,Y1=0,X2=31,Y2=31)
}
