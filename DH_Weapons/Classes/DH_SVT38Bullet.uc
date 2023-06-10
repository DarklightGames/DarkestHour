//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_SVT38Bullet extends DHBullet;

defaultproperties
{
    Speed=50696.0 // 2756 fps  // TODO: was 2519 fps in RO, why the change?
    BallisticCoefficient=0.511 // TODO: was 0.37 in RO, why the change?
    Damage=117.0
    MyDamageType=class'DH_Weapons.DH_SVT38DamType'
}
