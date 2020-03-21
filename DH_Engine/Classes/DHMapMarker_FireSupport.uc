//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2018
//==============================================================================

class DHMapMarker_FireSupport extends DHMapMarker
    abstract;

var string TypeName;

// Any squad leader can call artillery support.
static function bool CanPlaceMarker(DHPlayerReplicationInfo PRI)
{
    return PRI != none && DHPlayer(PRI.Owner).IsSL();
}

// An artillery support request can be removed only by the SL of the squad that called artillery request.
static function bool CanRemoveMarker(DHPlayerReplicationInfo PRI, DHGameReplicationInfo.MapMarker Marker)
{
    local DHPlayer PC;

    if (PRI == none)
        return false;

    PC = DHPlayer(PRI.Owner);

    return PC.IsSL() && PRI.SquadIndex == Marker.SquadIndex;
}

// Only allow artillery roles and the SL who made the mark to see artillery requests.
static function bool CanSeeMarker(DHPlayerReplicationInfo PRI, DHGameReplicationInfo.MapMarker Marker)
{
    local DHPlayer PC;
    if(PRI == none)
        return false;

    PC = DHPlayer(PRI.Owner);
    return (PC.IsArtilleryRole()) || PC.IsSL() && PRI.SquadIndex == Marker.SquadIndex;
}

static function string GetCaptionString(DHPlayer PC, DHGameReplicationInfo.MapMarker Marker)
{
    local DHPlayerReplicationInfo PRI;
    local DHGameReplicationInfo GRI;
    local DHSquadReplicationInfo SRI;
    local int TeamIndex, SquadIndex;
    local string SquadName;

    PRI = DHPlayerReplicationInfo(PC.PlayerReplicationInfo);
    SRI = PC.SquadReplicationInfo;

    TeamIndex = PRI.Team.TeamIndex;
    SquadIndex = Marker.SquadIndex;
    SquadName = SRI.GetSquadName(TeamIndex, SquadIndex);

    return default.TypeName $ " request (" $ SquadName $ ")";
}

defaultproperties
{
    MarkerName="Fire Support"
    IconMaterial=Texture'DH_InterfaceArt2_tex.Icons.developer'
    IconColor=(R=204,G=,B=255,A=255)
    IconCoords=(X1=0,Y1=0,X2=31,Y2=31)
    GroupIndex=5
    bShouldShowOnCompass=false
    bIsUnique=true
    Scope=SQUAD
    LifetimeSeconds=180 // 3 minutes
}

