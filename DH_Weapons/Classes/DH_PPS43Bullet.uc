//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DH_PPS43Bullet extends DHBullet;

defaultproperties
{
    Speed=24000.0
    BallisticCoefficient=0.15
    WhizType=2
    Damage=55.0
    MyDamageType=class'DH_Weapons.DH_PPS43DamType'
    MyVehicleDamage=class'DH_Weapons.DH_PPS43VehDamType'
}
