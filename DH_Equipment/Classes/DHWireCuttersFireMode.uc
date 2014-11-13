//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DHWireCuttersFireMode extends WeaponFire;

simulated function bool AllowFire()
{
    if (Instigator == none)
    {
        return false;
    }

    if (Instigator.Velocity != vect(0, 0, 0))
    {
        return false;
    }

    return true;
}

function StartFiring()
{
    Level.Game.Broadcast(Instigator, "StartFiring");
}

function StopFiring()
{
    Level.Game.Broadcast(Instigator, "StopFiring");
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

