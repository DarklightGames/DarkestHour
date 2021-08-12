//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2021
//==============================================================================

class DHMapMarker_Paradrop extends DHMapMarker
    abstract;

static function bool CanPlayerUse(DHPlayerReplicationInfo PRI)
{
    return PRI != none &&
           (PRI.bAdmin ||
            PRI.bSilentAdmin ||
            (PRI.Level != none &&
             PRI.Level.NetMode == NM_Standalone));
}

defaultproperties
{
    MarkerName="ADMIN: Paradrop"
    IconMaterial=Texture'DH_InterfaceArt2_tex.Icons.paratroopers'
    IconColor=(R=0,G=204,B=255,A=255)
    IconCoords=(X1=0,Y1=0,X2=31,Y2=31)
    GroupIndex=5
    bShouldShowOnCompass=false
    bIsUnique=true
    bIsPersonal=true
}
