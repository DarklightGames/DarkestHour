//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DH_PPD40Bullet extends DHBullet;

defaultproperties
{
    WhizType=2
    BallisticCoefficient=0.15
    Speed=24000.0
    Damage=55.0
    MyDamageType=class'DH_Weapons.DH_PPD40DamType'
    MyVehicleDamage=class'DH_Weapons.DH_PPD40VehDamType'
}
