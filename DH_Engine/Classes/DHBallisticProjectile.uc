//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
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

// New function to set hit location in team's mortar targets so it's marked on the map for mortar crew
function SetHitLocation(vector HitLocation)
{
    local DHGameReplicationInfo   GRI;
    local DHPlayerReplicationInfo PRI;
    local int      TeamIndex, ClosestMortarTargetIndex;
    local float    ClosestMortarTargetDistance, MortarTargetDistance;
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

    ClosestMortarTargetIndex = -1;
    ClosestMortarTargetDistance = 1000000000.0;

    if (TeamIndex == AXIS_TEAM_INDEX)
    {
        // Find the closest mortar target
        for (i = 0; i < arraycount(GRI.GermanMortarTargets); ++i)
        {
            if (!GRI.GermanMortarTargets[i].bIsActive)
            {
                continue;
            }

            MortarTargetDistance = VSize(GRI.GermanMortarTargets[i].Location - HitLocation);

            if (MortarTargetDistance < ClosestMortarTargetDistance)
            {
                ClosestMortarTargetDistance = MortarTargetDistance;
                ClosestMortarTargetIndex = i;
            }
        }

        // If we still have a mortar target index of 255, it means none of the targets were close enough
        if (ClosestMortarTargetDistance < class'DHGameReplicationInfo'.default.MortarTargetDistanceThreshold)
        {
            // A 1.0 in the Z-component indicates to display the hit on the map
            HitLocation.Z = 1.0;
        }

        if (ClosestMortarTargetIndex != -1)
        {
            GRI.GermanMortarTargets[ClosestMortarTargetIndex].HitLocation = HitLocation;
        }
    }
    else if (TeamIndex == ALLIES_TEAM_INDEX)
    {
        // Find the closest mortar target
        for (i = 0; i < arraycount(GRI.AlliedMortarTargets); ++i)
        {
            if (!GRI.AlliedMortarTargets[i].bIsActive)
            {
                continue;
            }

            MortarTargetDistance = VSize(GRI.AlliedMortarTargets[i].Location - HitLocation);

            if (MortarTargetDistance < ClosestMortarTargetDistance)
            {
                ClosestMortarTargetDistance = MortarTargetDistance;
                ClosestMortarTargetIndex = i;
            }
        }

        // If we still have a mortar target index of 255, it means none of the targets were close enough
        if (ClosestMortarTargetDistance < class'DHGameReplicationInfo'.default.MortarTargetDistanceThreshold)
        {
            // A 1.0 in the Z-component indicates to display the hit on the map
            HitLocation.Z = 1.0;
        }

        if (ClosestMortarTargetIndex != -1)
        {
            GRI.AlliedMortarTargets[ClosestMortarTargetIndex].HitLocation = HitLocation;
        }
    }
}

// New function to find the closest mortar observer when mortar shell kills an enemy player
// Used to give additional points to the observer & the mortarman for working together for a kill!
function Controller GetClosestMortarTargetController()
{
    local DHGameReplicationInfo GRI;
    local float Distance, ClosestDistance;
    local int   ClosestIndex, i;

    ClosestIndex = -1;
    ClosestDistance = class'DHGameReplicationInfo'.default.MortarTargetDistanceThreshold;

    GRI = DHGameReplicationInfo(Level.Game.GameReplicationInfo);

    if (GRI == none || InstigatorController == none)
    {
        return none;
    }

    switch (InstigatorController.GetTeamNum())
    {
        case AXIS_TEAM_INDEX:
            for (i = 0; i < arraycount(GRI.GermanMortarTargets); ++i)
            {
                if (GRI.GermanMortarTargets[i].Controller == none)
                {
                    continue;
                }

                Distance = VSize(Location - GRI.GermanMortarTargets[i].Location);

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

            return GRI.GermanMortarTargets[ClosestIndex].Controller;

        case ALLIES_TEAM_INDEX:
            for (i = 0; i < arraycount(GRI.AlliedMortarTargets); ++i)
            {
                if (GRI.AlliedMortarTargets[i].Controller == none)
                {
                    continue;
                }

                Distance = VSize(Location - GRI.AlliedMortarTargets[i].Location);

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

            return GRI.AlliedMortarTargets[ClosestIndex].Controller;

        default:
            break;
    }

    return none;
}

defaultproperties
{
}

