//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DH_DP28Bullet extends DHBullet;

defaultproperties
{
    MyDamageType=class'DH_Weapons.DH_DP28DamType'
    MyVehicleDamage=class'DH_Weapons.DH_DP28VehDamType'
    Speed=50696.0 // 840 m/s   // TODO: was 44082 (2760 fps) in RO, why the change?
    BallisticCoefficient=0.511 // TODO: was 0.37 in RO, why the change?
    Damage=115.0
}
