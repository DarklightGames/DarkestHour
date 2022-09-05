//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2022
//==============================================================================

class DH_DP27LateBullet extends DHBullet;

defaultproperties
{
    Speed=50696.0 // 840 m/s (differs from RO because it stated 2760 fps but with incorrect conversion to UU)
    BallisticCoefficient=0.511 // TODO: was 0.37 in RO, why the change?
    Damage=115.0
    MyDamageType=class'DH_Weapons.DH_DP27LateDamType'
}
