//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2018
//==============================================================================

class DHMapMarker_FireSupport extends DHMapMarker
    abstract;

enum EFireSupportType
{
    FST_HighExplosive,
    FST_Smoke
};

var EFireSupportType Type;

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

static function string GetCaptionString(DHPlayer PC, vector WorldLocation)
{
    local vector PlayerLocation;
    local int Distance;

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
    MarkerName="Fire Support"
    IconMaterial=Texture'DH_InterfaceArt2_tex.Icons.Calipers'
    IconColor=(R=204,G=,B=255,A=255)
    IconCoords=(X1=0,Y1=0,X2=31,Y2=31)
    GroupIndex=5
    bShouldShowOnCompass=true
    bIsUnique=true
    bIsSquadSpecific=true
    bIsVisibleToTeam=true
}

