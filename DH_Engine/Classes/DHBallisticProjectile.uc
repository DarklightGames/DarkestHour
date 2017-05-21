//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2017
//==============================================================================

class DHBallisticProjectile extends ROBallisticProjectile
    abstract;

var bool    bIsArtilleryProjectile; // Whether or not we report our hits to be tracked on artillery targets.
                                    // This should not be set in defaultproperties, but should instead be
                                    // set in whatever logic block that spawns the projectile.

simulated function BlowUp(vector HitLocation)
{
    if (Role == ROLE_Authority && bIsArtilleryProjectile)
    {
        SetHitLocation(HitLocation);
    }
}

// New function to set hit location in team's artillery targets so it's marked on the map for mortar crew
function SetHitLocation(vector HitLocation)
{
    local DHGameReplicationInfo   GRI;
    local DHPlayerReplicationInfo PRI;
    local int      TeamIndex, ClosestArtilleryTargetIndex;
    local float    ClosestArtilleryTargetDistance, ArtilleryTargetDistance;
    local int      i;

    GRI = DHGameReplicationInfo(Level.Game.GameReplicationInfo);

    if (GRI == none || InstigatorController == none || InstigatorController.Pawn == none)
    {
        return;
    }

    PRI = DHPlayerReplicationInfo(InstigatorController.PlayerReplicationInfo);

    if (PRI == none || PRI.RoleInfo == none)
    {
        return;
    }

    TeamIndex = InstigatorController.GetTeamNum();

    // Zero out the z coordinate for 2D distance checking from targets
    HitLocation.Z = 0.0;

    ClosestArtilleryTargetIndex = -1;
    ClosestArtilleryTargetDistance = 1000000000.0;

    if (TeamIndex == AXIS_TEAM_INDEX)
    {
        // Find the closest artillery target
        for (i = 0; i < arraycount(GRI.GermanArtilleryTargets); ++i)
        {
            if (!GRI.GermanArtilleryTargets[i].bIsActive)
            {
                continue;
            }

            ArtilleryTargetDistance = VSize(GRI.GermanArtilleryTargets[i].Location - HitLocation);

            if (ArtilleryTargetDistance < ClosestArtilleryTargetDistance)
            {
                ClosestArtilleryTargetDistance = ArtilleryTargetDistance;
                ClosestArtilleryTargetIndex = i;
            }
        }

        // If we still have a artillery target index of 255, it means none of the targets were close enough
        if (ClosestArtilleryTargetDistance < class'DHGameReplicationInfo'.default.ArtilleryTargetDistanceThreshold)
        {
            // A 1.0 in the Z-component indicates to display the hit on the map
            HitLocation.Z = 1.0;
        }

        if (ClosestArtilleryTargetIndex != -1)
        {
            GRI.GermanArtilleryTargets[ClosestArtilleryTargetIndex].HitLocation = HitLocation;
        }
    }
    else if (TeamIndex == ALLIES_TEAM_INDEX)
    {
        // Find the closest artillery target
        for (i = 0; i < arraycount(GRI.AlliedArtilleryTargets); ++i)
        {
            if (!GRI.AlliedArtilleryTargets[i].bIsActive)
            {
                continue;
            }

            ArtilleryTargetDistance = VSize(GRI.AlliedArtilleryTargets[i].Location - HitLocation);

            if (ArtilleryTargetDistance < ClosestArtilleryTargetDistance)
            {
                ClosestArtilleryTargetDistance = ArtilleryTargetDistance;
                ClosestArtilleryTargetIndex = i;
            }
        }

        // If we still have a artillery target index of 255, it means none of the targets were close enough
        if (ClosestArtilleryTargetDistance < class'DHGameReplicationInfo'.default.ArtilleryTargetDistanceThreshold)
        {
            // A 1.0 in the Z-component indicates to display the hit on the map
            HitLocation.Z = 1.0;
        }

        if (ClosestArtilleryTargetIndex != -1)
        {
            GRI.AlliedArtilleryTargets[ClosestArtilleryTargetIndex].HitLocation = HitLocation;
        }
    }
}

// New function to find the closest artillery observer when mortar shell kills an enemy player
// Used to give additional points to the observer & the mortarman for working together for a kill!
function Controller GetClosestArtilleryTargetController()
{
    local DHGameReplicationInfo GRI;
    local float Distance, ClosestDistance;
    local int   ClosestIndex, i;

    ClosestIndex = -1;
    ClosestDistance = class'DHGameReplicationInfo'.default.ArtilleryTargetDistanceThreshold;

    GRI = DHGameReplicationInfo(Level.Game.GameReplicationInfo);

    if (GRI == none || InstigatorController == none)
    {
        return none;
    }

    switch (InstigatorController.GetTeamNum())
    {
        case AXIS_TEAM_INDEX:
            for (i = 0; i < arraycount(GRI.GermanArtilleryTargets); ++i)
            {
                if (GRI.GermanArtilleryTargets[i].Controller == none)
                {
                    continue;
                }

                Distance = VSize(Location - GRI.GermanArtilleryTargets[i].Location);

                if (Distance <= ClosestDistance)
                {
                    ClosestDistance = Distance;
                    ClosestIndex = i;
                }
            }

            if (ClosestIndex == -1)
            {
                return none;
            }

            return GRI.GermanArtilleryTargets[ClosestIndex].Controller;

        case ALLIES_TEAM_INDEX:
            for (i = 0; i < arraycount(GRI.AlliedArtilleryTargets); ++i)
            {
                if (GRI.AlliedArtilleryTargets[i].Controller == none)
                {
                    continue;
                }

                Distance = VSize(Location - GRI.AlliedArtilleryTargets[i].Location);

                if (Distance <= ClosestDistance)
                {
                    ClosestDistance = Distance;
                    ClosestIndex = i;
                }
            }

            if (ClosestIndex == -1)
            {
                return none;
            }

            return GRI.AlliedArtilleryTargets[ClosestIndex].Controller;

        default:
            break;
    }

    return none;
}

defaultproperties
{
}

