//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DH_Flak38CannonShellMixed extends DH_Flak38CannonShellAP
    abstract;

// This is only a dummy class and this projectile should never be spawned, so just in case we'll destroy & log
simulated function PreBeginPlay()
{
    Warn("DH_Flak38CannonShellMixed actor has spawned & is being destroyed - this is only a dummy class & should never be spawned !");
    Destroy();
}

defaultproperties
{
}
