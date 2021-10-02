//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2018
//==============================================================================

class DHMapMarker_FireSupport extends DHMapMarker
    abstract;

var color             ActivatedIconColor; // for off-map artillery requests

static function string GetCaptionString(DHPlayer PC, DHGameReplicationInfo.MapMarker Marker)
{
    local string SquadName;
    local DHSquadReplicationInfo SRI;

    if (PC == none || PC.Pawn == none)
    {
        return "";
    }

    if (PC.IsArtillerySpotter() && PC.GetSquadIndex() == Marker.SquadIndex)
    {
        return "Your fire support request";
    }
    else
    {
        SRI = PC.SquadReplicationInfo;
        SquadName = SRI.GetSquadName(PC.GetTeamNum(), Marker.SquadIndex);

        return SquadName @ "(" $ default.MarkerName $ ")" @ "-" @ GetDistanceString(PC, Marker);
    }
}

static function color GetIconColor(DHPlayerReplicationInfo PRI, DHGameReplicationInfo.MapMarker Marker)
{
    local DHPlayer PC;

    if (PRI == none)
    {
        return default.IconColor;
    }

    PC = DHPlayer(PRI.Owner);

    if (PC != none
        && PC.IsArtilleryOperator()
        && PC.ArtillerySupportSquadIndex == Marker.SquadIndex
        || PC.IsArtillerySpotter()
        && PRI.SquadIndex == Marker.SquadIndex)
    {
        return default.ActivatedIconColor;
    }

    return default.IconColor;
}

defaultproperties
{
    IconColor=(R=255,G=0,B=0,A=100)
    ActivatedIconColor=(R=255,G=0,B=0,A=255)
    IconMaterial=Texture'InterfaceArt_tex.OverheadMap.overheadmap_Icons'
    IconCoords=(X1=0,Y1=0,X2=63,Y2=63)
    GroupIndex=5
    LifetimeSeconds=120
    Type=MT_OnMapArtilleryRequest
    OverwritingRule=UNIQUE_PER_GROUP
    Scope=SQUAD
    RequiredSquadMembers=2
    Cooldown=10
    Permissions_CanSee(0)=(LevelSelector=TEAM,RoleSelector=ERS_ARTILLERY_OPERATOR)
    Permissions_CanSee(1)=(LevelSelector=SQUAD,RoleSelector=ERS_ARTILLERY_SPOTTER)
    Permissions_CanRemove(0)=(LevelSelector=SQUAD,RoleSelector=ERS_ARTILLERY_SPOTTER)
    Permissions_CanPlace(0)=ERS_ARTILLERY_SPOTTER
    OnPlacedExternalNotifications(0)=(RoleSelector=ERS_ARTILLERY_OPERATOR,Message=class'DHFireSupportMessage',MessageIndex=3)
    OnPlacedMessage=class'DHFireSupportMessage'
    OnPlacedMessageIndex=0
}
