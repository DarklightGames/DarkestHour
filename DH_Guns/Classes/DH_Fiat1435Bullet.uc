//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_Fiat1435Bullet extends DHBullet;

defaultproperties
{
    Speed=39832 // 660 m/s
    BallisticCoefficient=0.276  // https://www.topgun.es/punta-65-carcano-160gr-hornady.html
    Damage=110.0
    MyDamageType=class'DH_Weapons.DH_Fiat1435DamageType'
}
