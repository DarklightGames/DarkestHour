//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_MP41Bullet extends DHBullet;

defaultproperties
{
    Speed=22934.0 // differs from RO but that had incorrect conversion to UU
    BallisticCoefficient=0.16
    WhizType=2
    Damage=59.0
    MyDamageType=class'DH_Weapons.DH_MP41DamType'
}
