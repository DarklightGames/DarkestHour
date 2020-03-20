//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2018
//==============================================================================

class DHMapMarker_FireSupport_HE extends DHMapMarker_FireSupport
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
return super.GetCaptionString(PC, Marker) $ " (HE request)";
}

defaultproperties
{
    MarkerName="Fire Support (HE)"
    IconMaterial=Texture'DH_InterfaceArt2_tex.Icons.developer'
}

