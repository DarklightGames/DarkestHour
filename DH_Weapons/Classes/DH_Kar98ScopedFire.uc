//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_Kar98ScopedFire extends DH_Kar98Fire;

defaultproperties
{
    ProjectileClass=Class'DH_Kar98ScopedBullet'
    AmmoClass=Class'DH_Kar98Ammo'
    Spread=20.0
    AddedPitch=15
    PctRestDeployRecoil=0.25
    FireIronAnim="Scope_Shoot"
    ShakeRotMag=(X=50.0,Y=50.0,Z=400.0)
    ShakeRotTime=5.0
    AimError=500.0
}
