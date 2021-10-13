//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2018
//==============================================================================

class DHMapMarker_ArtilleryHit extends DHMapMarker
    abstract;

var int VisibilityRange; // [m]

static function bool CanSeeMarker(DHPlayerReplicationInfo PRI, DHGameReplicationInfo.MapMarker Marker)
{
    local DHPlayer PC;

    if (PRI == none)
    {
        return false;
    }

    if (PRI.Level != none && PRI.Level.NetMode == NM_Standalone)
    {
        // For debugging purposes, just let us see our own hits in standalone.
        return true;
    }

    PC = DHPlayer(PRI.Owner);

    return PC != none && PC.ArtilleryHitInfo.bIsWithinRadius;
}

defaultproperties
{
    IconMaterial=MaterialSequence'DH_InterfaceArt2_tex.Artillery.HitMarker'
    IconCoords=(X1=0,Y1=0,X2=31,Y2=31)
    GroupIndex=6
    Type=MT_ArtilleryHit
    OverwritingRule=UNIQUE_PER_GROUP
    Scope=PERSONAL
    LifetimeSeconds=15 // 30 seconds
    Permissions_CanSee(0)=(LevelSelector=TEAM,RoleSelector=ERS_ARTILLERY_OPERATOR)
    Permissions_CanPlace(0)=ERS_ARTILLERY_OPERATOR
    VisibilityRange=50
}
