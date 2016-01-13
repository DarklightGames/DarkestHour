//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DH_Kar98ScopedFire extends DH_Kar98Fire;

defaultproperties
{
    PreLaunchTraceDistance=3017.6 //50m
    FireIronAnim="Scope_Shoot"
    PctRestDeployRecoil=0.25
    AmmoClass=class'DH_Weapons.DH_Kar98ScopedAmmo'
    ShakeRotMag=(X=50.0,Y=50.0,Z=400.0)
    ShakeRotRate=(X=12500.0,Y=12500.0,Z=12500.0)
    ShakeRotTime=5.0
    ProjectileClass=class'DH_Weapons.DH_Kar98ScopedBullet'
    aimerror=550.0
    Spread=30.0
}
