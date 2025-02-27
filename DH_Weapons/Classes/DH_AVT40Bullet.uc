//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_AVT40Bullet extends DHBullet;

defaultproperties
{
    Speed=50696.0 // 2756 fps  // TODO: was 2519 fps in RO, why the change?
    BallisticCoefficient=0.511 // TODO: was 0.37 in RO, why the change?
    Damage=117.0
    MyDamageType=class'DH_Weapons.DH_AVT40DamType'
}
