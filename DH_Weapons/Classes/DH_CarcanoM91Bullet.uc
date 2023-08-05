//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2022
//==============================================================================

class DH_CarcanoM91Bullet extends DHBullet;

defaultproperties
{
    Speed=37418.24              // 620m/s (https://en.wikipedia.org/wiki/Breda_30)
    BallisticCoefficient=0.276  // https://www.topgun.es/punta-65-carcano-160gr-hornady.html
    Damage=100.0                // Almost an intermediate cartridge, lower damage than other rifles.
    MyDamageType=class'DH_Weapons.DH_CarcanoM91DamType'
}