//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DHWireCuttersFireMode extends DHWeaponFire;

// Modified to check (via a trace) that player is facing an obstacle that can be cut & that player is stationary & not diving to prone
simulated function bool AllowFire()
{
    local DHObstacleInstance TracedObstacle;
    local vector             HitLocation, HitNormal;

    if (Instigator != none && !Instigator.IsProneTransitioning() && Instigator.Velocity == vect(0.0, 0.0, 0.0))
    {
        TracedObstacle = DHObstacleInstance(Trace(HitLocation, HitNormal, Weapon.Location + (100.0 * vector(Weapon.Rotation)), Weapon.Location, true));

        if (TracedObstacle != none && TracedObstacle.Info.CanBeCut())
        {
            return true;
        }
    }

    return false;
}

defaultproperties
{
    PreFireTime=5.0
    MaxHoldTime=5.0
    bModeExclusive=true
    bFireOnRelease=false
    bIgnoresWeaponLock=true
}

