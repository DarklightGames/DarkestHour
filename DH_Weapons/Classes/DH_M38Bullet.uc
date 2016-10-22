//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DH_M38Bullet extends DHBullet;

defaultproperties
{
    BallisticCoefficient=0.511
    Speed=48282 // 2625 fps
    Damage=120.0
    MyDamageType=class'DH_Weapons.DH_M38DamType'
    MyVehicleDamage=class'DH_Weapons.DH_M38VehDamType'
}
