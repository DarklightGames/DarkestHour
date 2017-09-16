//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2017
//==============================================================================

class DHMapMarker_Squad_Attack extends DHMapMarker_Squad
    abstract;

static function OnMapMarkerPlaced(DHPlayer PC)
{
    if (PC != none && PC.SquadReplicationInfo != none)
    {
        PC.SquadReplicationInfo.BroadcastSquadLocalizedMessage(PC.GetTeamNum(), PC.GetSquadIndex(), class'DHSquadOrderMessage', 1);
    }
}

defaultproperties
{
    IconMaterial=texture'DH_InterfaceArt_tex.HUD.squad_order_attack'
    IconColor=(R=255,G=255,B=0,A=255)
    MarkerName="Attack"
    bIsUnique=true
}
