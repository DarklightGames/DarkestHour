//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DH_MN9130Bullet extends DHBullet;

defaultproperties
{
    BallisticCoefficient=0.511 //
    Damage=115
    MyDamageType=class'DH_Weapons.DH_MN9130DamType'
    MyVehicleDamage=class'ROInventory.MN9130VehDamType'
    Speed=52204 // 2838 fps
}
