//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2018
//==============================================================================

class DHMapMarker_ArtilleryHit extends DHMapMarker
    abstract;

var DHPlayer        Controller; // the guy who fired the projectile
var vector          Location;
var float           Time;
var int             ClosestFireRequestIndex; // this can be used for quickly finding nearest fire requests later on

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
    GroupIndex=5
    bShouldShowOnCompass=true
    bIsUnique=true
    bIsSquadSpecific=false
    bIsVisibleToTeam=true
    LifetimeSeconds=180 // 3 minutes
}
