//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DH_Winchester1897Bullet extends DHBullet;

defaultproperties
{
    Speed=22029.0
    BallisticCoefficient=0.04
    Damage=60 // TODO: this was was 45, but 29th ID have increased - 60 seems too high, as it is for every separate round & it's the same as a .45 calibre bullet
    MyDamageType=class'DH_Weapons.DH_Winchester1897DamType'
    MyVehicleDamage=class'DH_Weapons.DH_Winchester1897VehDamType'
}
