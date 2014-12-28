//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_AutomaticFire extends DH_ProjectileFire
    abstract;

// Overridden to make the player stop firing when they switch to from ironsights
simulated function bool AllowFire()
{
    if (Weapon.IsInState('IronSightZoomIn') ||
        Weapon.IsInState('IronSightZoomOut') ||
        Weapon.IsInState('TweenDown') ||
        Instigator.bIsSprinting)
    {
        return false;
    }

    return super.AllowFire();
}

function ModeTick(float dt)
{
    super.ModeTick(dt);

    if (bIsFiring && !AllowFire())
    {
        Weapon.StopFire(ThisModeNum);
    }
}

defaultproperties
{
    PreLaunchTraceDistance=1312.000000
    bPawnRapidFireAnim=true
}

