//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2019
//==============================================================================

class DHBallisticProjectile extends ROBallisticProjectile
    abstract;


// debugging stuff
var bool bIsCalibrating;
var float LifeStart;
var vector StartLocation;
var float DebugMils;

function int FindClosestRequest(vector HitLocation, array<DHGameReplicationInfo.ArtilleryRequest> Requests)
{
    local vector RequestLocation;
    local DHGameReplicationInfo GRI;
    local DHGameReplicationInfo.ArtilleryRequest Request;
    local int i, LastClosest;
    local float ClosestDistance, Dist;

    ClosestDistance = class'UFloat'.static.Infinity();

    GRI = DHGameReplicationInfo(Level.Game.GameReplicationInfo);
    LastClosest = -1;
    
    // for(i = 0; i < Requests.Length; i++)
    // {
    //     Request = Requests[i];
    //     if(DHPlayer(InstigatorController).SquadReplicationInfo.IsSquadActive(Request.TeamIndex, i) 
    //         && Request.ExpiryTime > GRI.ElapsedTime)
    //     {
    //         RequestLocation = GRI.GetWorldCoords(Request.LocationX, Request.LocationY);
    //         RequestLocation.Z = 0.0;
    //         HitLocation.Z = 0.0;
    //         Log("HitLocation: " $ HitLocation);
    //         Log("RequestLocation: " $ RequestLocation);
    //         Dist = VSize(HitLocation - RequestLocation);
    //         Log("Dist: " $ Dist);
    //         Log("Request.MaximumDistance: " $ Request.MaximumDistance);

    //         if (Dist < Request.MarkerClasMaximumDistance && ClosestDistance > Dist)
    //         {
    //             ClosestDistance = Dist;
    //             LastClosest = i;
    //         }
    //     }
    // }
        
    return LastClosest;
}

defaultproperties
{
}

