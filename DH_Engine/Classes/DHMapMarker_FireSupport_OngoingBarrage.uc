//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2018
//==============================================================================

class DHMapMarker_FireSupport_OngoingBarrage extends DHMapMarker_FireSupport
    abstract;
   
// Only allow artillery roles and the SL who made the mark to see artillery requests.
static function bool CanSeeMarker(DHPlayerReplicationInfo PRI, DHGameReplicationInfo.MapMarker Marker)
{
    return true;
}

static function string GetCaptionString(DHPlayer PC, DHGameReplicationInfo.MapMarker Marker)
{
    return "";
}

defaultproperties
{
    MarkerName="Ongoing Barrage"
    TypeName="HE"
    IconMaterial=Texture'DH_InterfaceArt2_tex.Icons.Defend'
    IconColor=(R=255,G=255,B=255,A=255)
    OverwritingRule=OFF
    Scope=TEAM
    LifetimeSeconds=-1            // artillery requests never expire
}
