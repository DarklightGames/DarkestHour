//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2018
//==============================================================================

class DHMapMarker_Ruler extends DHMapMarker
    abstract;

// allow only artillery roles to place a Ruler marker
static function bool CanPlaceMarker(DHPlayerReplicationInfo PRI)
{
    local DHPlayer PC;

    PC = DHPlayer(PRI.Owner);
    return PC.IsArtilleryRole();
}
    
// allow only artillery roles to remove a Ruler marker
static function bool CanRemoveMarker(DHPlayerReplicationInfo PRI, DHGameReplicationInfo.MapMarker Marker)
{
    local DHPlayer PC;

    PC = DHPlayer(PRI.Owner);
    return PC.IsArtilleryRole();
}

// keep in mind that this class is only inserted to personal map makers!
// thus a Ruler marker can only be seen by the person who created it anyway
static function bool CanSeeMarker(DHPlayerReplicationInfo PRI, DHGameReplicationInfo.MapMarker Marker)
{
    local DHPlayer PC;

    PC = DHPlayer(PRI.Owner);
    return PC.IsArtilleryRole();
}

// Override this to have a caption accompany the marker.
static function string GetCaptionString(DHPlayer PC, DHGameReplicationInfo.MapMarker Marker)
{
    local vector PlayerLocation;
    local int Distance;
    local vector WorldLocation;

    WorldLocation = Marker.WorldLocation;

    if (PC != none && PC.Pawn != none)
    {
        PlayerLocation = PC.Pawn.Location;
        PlayerLocation.Z = 0.0;
        WorldLocation.Z = 0.0;

        Distance = int(class'DHUnits'.static.UnrealToMeters(VSize(WorldLocation - PlayerLocation)));

        return string((Distance / 5) * 5) $ "m";
    }

    return "";
}

defaultproperties
{
    MarkerName="Measure"
    IconMaterial=Texture'DH_InterfaceArt2_tex.Icons.Calipers'
    IconColor=(R=0,G=204,B=255,A=255)
    IconCoords=(X1=0,Y1=0,X2=31,Y2=31)
    GroupIndex=4
    bShouldShowOnCompass=true
    bIsUnique=true
    bIsPersonal=true
}

