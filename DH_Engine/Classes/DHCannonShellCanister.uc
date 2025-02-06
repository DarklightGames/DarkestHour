//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DHCannonShellCanister extends DHBullet;

var int NumberOfProjectilesPerShot; // the number of separate small projectiles launched by each canister shot

defaultproperties
{
    NumberOfProjectilesPerShot=50
    WhizType=2
    BallisticCoefficient=4.0
    Speed=45988.0
    Damage=120.0
    MyDamageType=class'DH_Engine.DHCanisterShotDamageType'
}
