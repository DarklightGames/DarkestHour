//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2019
//==============================================================================

class DH_SatchelChargeSmallProjectile extends DH_SatchelCharge10lb10sProjectile;

defaultproperties
{
    MyDamageType=class'DH_Weapons.DH_SatchelSmallDamType'

    Damage=600.0
    DamageRadius=600.0

    EngineDamageMassThreshold=10.0
    EngineDamageRadius=185.0
    EngineDamageMax=75.0

    TreadDamageMassThreshold=12.0
    TreadDamageRadius=64.0
    TreadDamageMax=65.0
}
