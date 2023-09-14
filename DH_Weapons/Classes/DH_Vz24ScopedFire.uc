//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_Vz24ScopedFire extends DH_Vz24Fire;

defaultproperties
{
    ProjectileClass=class'DH_Weapons.DH_Vz24ScopedBullet'
    AmmoClass=class'DH_Weapons.DH_Kar98Ammo'
    Spread=20.0
    AddedPitch=15
    PctRestDeployRecoil=0.25
    FireIronAnim="Scope_Shoot"
    ShakeRotMag=(X=50.0,Y=50.0,Z=400.0)
    ShakeRotTime=5.0
    AimError=500.0
}
