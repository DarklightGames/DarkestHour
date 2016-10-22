//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DH_MN9130Bullet extends DHBullet;

defaultproperties
{
    Speed=52204.0 // 2838 fps  // TODO: was 2660 fps in RO, why the change?
    BallisticCoefficient=0.511 // TODO: was 0.37 in RO, why the change?
    Damage=115.0
    MyDamageType=class'DH_Weapons.DH_MN9130DamType'
    MyVehicleDamage=class'DH_Weapons.DH_MN9130VehDamType'
}
