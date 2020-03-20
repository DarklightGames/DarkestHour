//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2018
//==============================================================================

class DHMapMarker_FireSupport extends DHMapMarker
    abstract;

static function bool CanPlayerUse(DHPlayerReplicationInfo PRI)
{
    local DHPlayer PC;

    if (PRI == none)
    {
        return false;
    }

    PC = DHPlayer(PRI.Owner);

    return PC != none && PC.IsSLorASL();    // TODO: we can have this be just ASL maybe.
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

    return SquadName;
}

defaultproperties
{
    MarkerName="Fire Support"
    IconMaterial=Texture'DH_InterfaceArt2_tex.Icons.developer'
    IconColor=(R=204,G=,B=255,A=255)
    IconCoords=(X1=0,Y1=0,X2=31,Y2=31)
    GroupIndex=5
    bShouldShowOnCompass=false
    bIsUnique=false
    bIsVisibleToTeam=false
    LifetimeSeconds=180 // 3 minutes
}

