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
    local vector MarkerDirection, ViewDirection, PlayerLocation;
    local rotator ViewRotation;
    local int Deflection, Distance;
    local string DeflectionOut, DistanceOut;

    if (PC == none || PC.Pawn != none)
    {
        PlayerLocation = PC.Pawn.Location;
        PlayerLocation.Z = 0.0;
        WorldLocation.Z = 0.0;

        ViewRotation.Yaw = PC.CalcViewRotation.Yaw;
        ViewDirection = vector(ViewRotation);
        MarkerDirection = WorldLocation - PlayerLocation;

        Distance = int(class'DHUnits'.static.UnrealToMeters(VSize(MarkerDirection)));
        DistanceOut = string((Distance / 5) * 5) $ "m";

        Deflection = class'DHUnits'.static.RadiansToMilliradians(class'UVector'.static.SignedAngle(MarkerDirection, ViewDirection, vect(0, 0, 1)));

        if (Abs(Deflection) > 500)
        {
            return DistanceOut;
        }

        if (Deflection > 0)
        {
            DeflectionOut = "+";
        }

        DeflectionOut $= string(Deflection) $ "mil";

        return DistanceOut @ DeflectionOut;
    }

    return "";
}

defaultproperties
{
    MarkerName="Measure"
    IconMaterial=Texture'DH_InterfaceArt2_tex.Icons.pin'
    IconColor=(R=255,G=42,B=127,A=255)
    IconCoords=(X1=0,Y1=0,X2=31,Y2=31)
    GroupIndex=4
    bShouldShowOnCompass=true
    bIsUnique=true
}

