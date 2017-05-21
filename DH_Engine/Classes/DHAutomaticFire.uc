//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2017
//==============================================================================

class DHAutomaticFire extends DHProjectileFire
    abstract;

// Modified to make the player stop firing when they switch to from ironsights
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

function ModeTick(float DeltaTime)
{
    super.ModeTick(DeltaTime);

    if (bIsFiring && !AllowFire())
    {
        Weapon.StopFire(ThisModeNum);
    }
}

function float MaxRange()
{
    return 9000.0; // about 150 meters
}

defaultproperties
{
    bPawnRapidFireAnim=true
}

