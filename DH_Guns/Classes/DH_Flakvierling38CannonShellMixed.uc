//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_Flakvierling38CannonShellMixed extends DH_Flakvierling38CannonShellAP;


// Matt: this is only a dummy class and this projectile should never be spawned, so just in case we'll destroy & log
simulated function PreBeginPlay()
{
    Warn("DH_Flakvierling38CannonShellMixed actor has spawned & is being destroyed - this is only a dummy class & should never be spawned !");
    Destroy();
}

defaultproperties
{
}
