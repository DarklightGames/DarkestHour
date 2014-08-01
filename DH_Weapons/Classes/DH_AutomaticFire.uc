//=============================================================================
// DH_AutomaticFire
//=============================================================================
// Automatic fire class
//=============================================================================
// Red Orchestra Source
// Copyright (C) 2005 John "Ramm-Jaeger" Gibson
//=============================================================================

class DH_AutomaticFire extends DH_ProjectileFire
    abstract;

// Overriden to make the player stop firing when they switch to from ironsights
simulated function bool AllowFire()
{
    if (Weapon.IsInState('IronSightZoomIn') || Weapon.IsInState('IronSightZoomOut') || Weapon.IsInState('TweenDown') || Instigator.bIsSprinting)
    {
        return false;
    }
    else
    {
        return super.AllowFire();
    }
}

defaultproperties
{
     PreLaunchTraceDistance=1312.000000
     bPawnRapidFireAnim=true
}

