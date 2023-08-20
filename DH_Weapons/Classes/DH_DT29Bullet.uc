//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_DT29Bullet extends DHBullet;

defaultproperties
{
    Speed=50696.0 // 840 m/s (differs from RO because it stated 2760 fps but with incorrect conversion to UU)
    BallisticCoefficient=0.511 // TODO: was 0.37 in RO, why the change?
    Damage=117.0
    MyDamageType=class'DH_Weapons.DH_DT29DamType'
}
