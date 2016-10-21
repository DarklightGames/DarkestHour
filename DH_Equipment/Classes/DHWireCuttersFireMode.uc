//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DHWireCuttersFireMode extends WeaponFire;

// Modified to check (via a trace) that player is facing an obstacle that can be cut & that player is stationary & not diving to prone
simulated function bool AllowFire()
{
    local DHObstacleInstance TracedObstacle;
    local vector             HitLocation, HitNormal;

    TracedObstacle = DHObstacleInstance(Trace(HitLocation, HitNormal, 100.0 * vector(Weapon.Rotation), Weapon.Location, true));

    if (TracedObstacle != none && TracedObstacle.Info.CanBeCut() &&
        Instigator != none && !Instigator.IsProneTransitioning() && Instigator.Velocity == vect(0.0, 0.0, 0.0))
    {
        return true;
    }

    return false;
}

defaultproperties
{
    PreFireTime=5.0
    MaxHoldTime=5.0
    bModeExclusive=true
    bFireOnRelease=false
}

