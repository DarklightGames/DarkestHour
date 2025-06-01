//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_MN9130ScopedPEFire extends DH_MN9130Fire;

defaultproperties
{
    ProjectileClass=class'DH_Weapons.DH_MN9130ScopedBullet'
    Spread=22.0
    PctRestDeployRecoil=0.25
    FireIronAnim="Scope_shoot"
    AddedPitch=4
    ShakeRotMag=(X=50.0,Y=50.0,Z=400.0)
    ShakeRotTime=5.0
    AimError=500.0
}
