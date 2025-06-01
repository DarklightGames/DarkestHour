//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_MN9130ScopedFire extends DH_MN9130Fire;

defaultproperties
{
    ProjectileClass=class'DH_Weapons.DH_MN9130ScopedBullet'
    Spread=25.0
    PctRestDeployRecoil=0.25
    FireIronAnim="Scope_shoot"
    ShakeRotMag=(X=50.0,Y=50.0,Z=400.0)
    ShakeRotTime=5.0
    AimError=500.0
}
