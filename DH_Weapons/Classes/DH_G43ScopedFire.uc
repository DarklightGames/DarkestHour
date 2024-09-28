//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_G43ScopedFire extends DH_G43Fire;

defaultproperties
{
    Spread=40.0
    AddedPitch=16

    ProjectileClass=class'DH_Weapons.DH_G43ScopedBullet'
    FireIronAnim="Scope_Shoot"
    FireLastAnim="shoot_last"
    FireIronLastAnim="Scope_Shoot_Last"
    FireAnim="Shoot_g43"
}
