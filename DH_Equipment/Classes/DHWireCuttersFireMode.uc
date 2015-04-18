//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DHWireCuttersFireMode extends WeaponFire;

simulated function bool AllowFire()
{
    local vector HitLocation, HitNormal, TraceEnd, TraceStart;
    local Actor HitActor;
    local DHObstacleInstance O;

    TraceStart = Weapon.Location;
    TraceEnd = vector(Weapon.Rotation) * 100.0;

    HitActor = Trace(HitLocation, HitNormal, TraceEnd, TraceStart, true);
    O = DHObstacleInstance(HitActor);

    if (O == none || !O.Info.CanBeCut())
    {
        return false;
    }

    if (Instigator == none ||
        Instigator.IsProneTransitioning() ||
        Instigator.Velocity != vect(0.0, 0.0, 0.0))
    {
        return false;

    }

    return true;
}

function StartFiring()
{
    Log("DHWireCuttersFireMode::StartFiring");
}

function StopFiring()
{
    Log("DHWireCuttersFireMode::StopFiring");
}

/*event ModeDoFire()
{
    if (!AllowFire())
    {
        return;
    }
}

event ModeHoldFire()
{
    super.ModeHoldFire

    if (!AllowFire())
    {
        return;
    }

    bIsFiring = true;
}*/

defaultproperties
{
    PreFireTime=5.0
    MaxHoldTime=5.0
    bModeExclusive=true
    bFireOnRelease=false
}

