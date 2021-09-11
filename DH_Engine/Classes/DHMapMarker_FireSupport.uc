//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2018
//==============================================================================

class DHMapMarker_FireSupport extends DHMapMarker
    abstract;

enum EArtilleryType
{
    AT_HighExplosives,
    AT_Smoke
};

enum EArtilleryRange
{
    AR_OnMap,
    AR_OffMap
};

var string            TypeName;
var EArtilleryType    ArtilleryType;
var EArtilleryRange   ArtilleryRange;
var color             ActivatedIconColor; // for off-map artillery requests

static function OnMapMarkerPlaced(DHPlayer PC, DHGameReplicationInfo.MapMarker Marker)
{
    switch (default.ArtilleryRange)
    {
        case EArtilleryRange.AR_OffMap:
            PC.ServerSaveArtilleryTarget(Marker.WorldLocation);
            break;
        case EArtilleryRange.AR_OnMap:
            break;
    }
}

static function OnMapMarkerRemoved(DHPlayer PC, DHGameReplicationInfo.MapMarker Marker)
{
    switch (default.ArtilleryRange)
    {
        case EArtilleryRange.AR_OffMap:
            PC.ServerSaveArtilleryTarget(vect(0, 0, 0));
            break;
        case EArtilleryRange.AR_OnMap:
            break;
    }
}

static function string GetCaptionString(DHPlayer PC, DHGameReplicationInfo.MapMarker Marker)
{
    local int Distance;
    local vector PlayerLocation, WorldLocation;
    local string SquadName, ArtilleryType;
    local DHSquadReplicationInfo SRI;

    if (PC == none || PC.Pawn == none)
    {
        return "";
    }

    switch (default.ArtilleryRange)
    {
        case EArtilleryRange.AR_OffMap:
            return "";
        case EArtilleryRange.AR_OnMap:
            if(PC.IsArtillerySpotter() && PC.GetSquadIndex() == Marker.SquadIndex)
            {
                return "Your fire support request";
            }
            else
            {
                WorldLocation = Marker.WorldLocation;
                WorldLocation.Z = 0.0;

                PlayerLocation = PC.Pawn.Location;
                PlayerLocation.Z = 0.0;

                Distance = int(class'DHUnits'.static.UnrealToMeters(VSize(WorldLocation - PlayerLocation)));

                SRI = PC.SquadReplicationInfo;
                SquadName = SRI.GetSquadName(PC.GetTeamNum(), Marker.SquadIndex);

                ArtilleryType = default.TypeName;

                return SquadName @ "-" @ ArtilleryType @ "-" @ (Distance / 5) * 5 $ "m";
            }
    }

    return "";
}

static function color GetIconColor(DHPlayerReplicationInfo PRI, DHGameReplicationInfo.MapMarker Marker)
{
    local DHPlayer PC;

    if (PRI == none)
    {
        return default.IconColor;
    }

    switch (default.ArtilleryRange)
    {
        case EArtilleryRange.AR_OffMap:
            return default.IconColor;
        case EArtilleryRange.AR_OnMap:
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

    return default.ActivatedIconColor;
}

static function bool IsOnMapArtillery()
{
    return default.ArtilleryRange == AR_OnMap;
}

defaultproperties
{
    IconMaterial=Texture'DH_InterfaceArt2_tex.Icons.developer'
    IconColor=(R=204,G=,B=255,A=255)
    IconCoords=(X1=0,Y1=0,X2=31,Y2=31)
    GroupIndex=-1
    bShouldShowOnCompass=false
    OverwritingRule=UNIQUE
    Scope=TEAM
    LifetimeSeconds=-1            // artillery requests never expire
    RequiredSquadMembers=3
    Permissions_CanSee(0)=(LevelSelector=TEAM,RoleSelector=ARTILLERY_OPERATOR)
    Permissions_CanSee(1)=(LevelSelector=SQUAD,RoleSelector=ARTILLERY_SPOTTER)
    Permissions_CanRemove(0)=(LevelSelector=SQUAD,RoleSelector=ARTILLERY_SPOTTER)
    Permissions_CanPlace(0)=ARTILLERY_SPOTTER
}
