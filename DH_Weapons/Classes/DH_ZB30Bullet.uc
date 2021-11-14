//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2020
//==============================================================================

class DH_ZB30Bullet extends DHBullet;

defaultproperties
{
    Speed=45264.0 // 750 m/s
    BallisticCoefficient=0.515 // 7.92x57mm (RO uses G1 method to measure BC) (G7 is 0.36)
    Damage=115.0
    MyDamageType=class'DH_Weapons.DH_ZB30DamType'
}
