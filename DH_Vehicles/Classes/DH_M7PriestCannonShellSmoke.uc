//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2019
//==============================================================================
// This is a 105mm shell with the "base" charge, which has a significantly lower
// muzzle velocity than a fully charged round. This allows the Priest to be used
// to deliver rounds with a higher angle-of-incidence.
//==============================================================================

class DH_M7PriestCannonShellSmoke extends DH_ShermanM4A3105CannonShellSmoke;

simulated function Explode(vector HitLocation, vector HitNormal)
{
    local DHPlayer PC;
    local DHGameReplicationInfo GRI;
    local vector MapLocation;

    PC =  DHPlayer(InstigatorController);
    if(PC != none)
    {
        GRI = DHGameReplicationInfo(PC.GameReplicationInfo);
        GRI.GetMapCoords(HitLocation, MapLocation.X, MapLocation.Y);
        class'DH_Engine.DHMapMarker_ArtilleryHit_Smoke'.static.AddMarker(PC, MapLocation.X, MapLocation.Y);
    }
    super.Explode(HitLocation, HitNormal);
}

defaultproperties
{
    SpeedFudgeScale=1.0
    Speed=8962.5         // 198m/s x 75%
    MaxSpeed=8962.5
    LifeSpan=20.0
}

