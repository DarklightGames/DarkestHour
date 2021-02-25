//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2021
//==============================================================================

class DHMapMarker_Ruler extends DHMapMarker
    abstract;

static function bool CanPlayerUse(DHPlayerReplicationInfo PRI)
{
    local DHRoleInfo RI;
    local DHPlayer PC;

    RI = DHRoleInfo(PRI.RoleInfo);
    PC = DHPlayer(PRI.Owner);

    /*
    if (RI.bCanUseMortars || RI.bCanBeTankCrew)
    {
        return true;
    }
    */

    return true;
}

static function string GetCaptionString(DHPlayer PC, vector WorldLocation)
{
    local vector PlayerLocation;
    local int Distance;

    if (PC == none || PC.Pawn != none)
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
