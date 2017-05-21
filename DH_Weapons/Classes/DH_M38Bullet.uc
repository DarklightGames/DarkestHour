//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2017
//==============================================================================

class DH_M38Bullet extends DHBullet;

defaultproperties
{
    Speed=48282.0 // 2625 fps  // TODO: was 2514 fps in RO, why the change?
    BallisticCoefficient=0.511 // TODO, was 0.37 in RO, why the change?
    Damage=115.0
    MyDamageType=class'DH_Weapons.DH_M38DamType'
    MyVehicleDamage=class'DH_Weapons.DH_M38VehDamType'
}
