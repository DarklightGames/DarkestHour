//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2018
//==============================================================================

class DHMapMarker_Ruler extends DHMapMarker
    abstract;

static function bool CanPlayerUse(DHPlayerReplicationInfo PRI)
{
    local DHRoleInfo RI;
    local DHPlayer PC;

    RI = DHRoleInfo(PRI.RoleInfo);
    PC = DHPlayer(PRI.Owner);

    if (RI.bCanUseMortars ||
        RI.bCanBeTankCrew)
    {
        return true;
    }
}

static function AddMarker(DHPlayer PC, float MapLocationX, float MapLocationY)
{
   PC.AddRulerMarker(MapLocationX, MapLocationY);
}

static function RemoveMarker(DHPlayer PC, optional int Index)
{
   PC.RemoveRulerMarker();
}

defaultproperties
{
    MarkerName="Measure"
    IconMaterial=Texture'DH_InterfaceArt2_tex.Icons.pin'
    IconColor=(R=255,G=42,B=127,A=255)
    IconCoords=(X1=0,Y1=0,X2=31,Y2=31)
    GroupIndex=4
    bShouldShowOnCompass=true
}
