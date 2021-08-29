//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2018
//==============================================================================

class DHMapMarker_FireSupport extends DHMapMarker
    abstract;

var string  TypeName;
var int     RequiredSquadMembers;

// Any squad leader can call artillery support.
static function bool CanPlaceMarker(DHPlayerReplicationInfo PRI)
{
    local DHPlayer PC;

    if (PRI == none)
    {
        return false;
    }

    PC = DHPlayer(PRI.Owner);

    return PC != none && PC.IsArtillerySpotter();
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
    // RequiredSquadMembers=3
    RequiredSquadMembers=3
}
